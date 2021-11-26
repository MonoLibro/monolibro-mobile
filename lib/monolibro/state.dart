import 'dart:async';

import 'package:monolibro/globals/cleared_payments.dart';
import 'package:monolibro/globals/cryptography_utils.dart';
import 'package:monolibro/globals/database.dart';
import 'package:monolibro/globals/local_user.dart';
import 'package:monolibro/globals/message_utils.dart';
import 'package:monolibro/globals/ws_control.dart';
import 'package:monolibro/monolibro/intention.dart';
import 'package:monolibro/monolibro/models/activity.dart';
import 'package:monolibro/monolibro/models/activity_entry.dart';
import 'package:monolibro/monolibro/models/details.dart';
import 'package:monolibro/monolibro/models/payload.dart';
import 'package:monolibro/monolibro/models/user.dart';
import 'package:monolibro/monolibro/operation.dart';
import 'package:monolibro/monolibro/voting_session.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:uuid/uuid.dart';

class State{
  Map<String, VotingSession> votingSessions = {};
  Map<String, Activity> activities = {};
  Map<String, StreamController<Activity>> waitingActivities = {};
  Map<String, User> users = {};
  LocalUser? localUser;
  StreamController<List> userSyncStream = StreamController();
  StreamController<List> activitySyncStream = StreamController();
  List<ClearedPayments> clearedPayments = [];

  Future<void> initUserCallback(List event) async {
    for (Map i in event){
      String userID = i["userID"];
      String firstName = i["firstName"];
      String lastName = i["lastName"];
      String email = i["email"];
      String publicKey = i["publicKey"];
      double frozen = i["frozen"];
      dbWrapper.execute("INERT INTO VALUES ('$userID', '$firstName', '$lastName', '$email', '$publicKey', $frozen)");
    }
    await getUsers();
  }

  Future<void> initUsers() async {
    // Syncs from other devices.
    
    // Gets all user from self
    users = await getUsers();
    var keys =  CryptographyUtils.generateRSAKeyPair();
    List<Map> localUsers = await dbWrapper.executeWithResult("select * from LocalUser;");
    if (localUsers.isNotEmpty){
      String userID = localUsers[0]["userID"];
      String firstName = localUsers[0]["firstName"];
      String lastName = localUsers[0]["lastName"];
      String email = localUsers[0]["email"];
      bool frozen = localUsers[0]["frozen"] == 1;
      localUser = LocalUser(userID, firstName, lastName, email, keys.publicKey, keys.privateKey, frozen);
      users[userID] = User(userID, firstName, lastName, email, keys.publicKey, frozen);

      // Registers back calling function and initalize activities
      userSyncStream.stream.listen((List event) {
        // When recieving, register the users to db
        initUserCallback(event);
      });

      // Sends sync req and local user to others
      var syncReq = Payload(
        1,
        Uuid().v4(),
        Details(
          Intention.broadcast,
          "",
        ),
        Operation.syncUsers,
        {
          "userID": userID,
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "publicKey": "",
          "frozen": frozen ? 1 : 0,
        }
      );
      var msg = MessageUtils.serialize(syncReq, keys.privateKey);
      wsClientGlobal.wsClient.channel.sink.add(msg);
    }
  }

  Future<void> initActivities() async {
    activities = await getActivites();
    
  }

  User? getUser(String userID){
    if (users.containsKey(userID)){
      return users[userID];
    }
  }

  Activity? getActivity(String code){
    if (activities.containsKey(code)){
      return activities[code];
    }
  }

  Future<Map<String, User>> getUsers() async {
    Map<String, User> users = {};
    List<Map> userRecords = await dbWrapper.executeWithResult("SELECT * FROM User;");
    for (Map record in userRecords){
      String userID = record["userID"];
      String firstName = record["firstName"];
      String lastName = record["lateName"];
      String email = record["email"];
      RSAPublicKey? publicKey = CryptographyUtils.generateRSAKeyPair().publicKey;
      bool frozen = record["frozen"] == 1;
      users[userID] = User(userID, firstName, lastName, email, publicKey, frozen);
    }
    return users;
  }
  
  Future<Map<String, Activity>> getActivites() async {
    Map<String, Activity> activities = {};
    List<Map> activityCodeRecords = await dbWrapper.executeWithResult("SELECT code FROM Activity;");
    List<String> activityCodes = [for (Map i in activityCodeRecords) i["code"]];
    for (String code in activityCodes){
      List<Map> activityResult = await dbWrapper.executeWithResult("SELECT * FROM Activity WHERE Activity.code = $code");
      if (activityResult.isEmpty) continue;
      String name = activityResult[0]["name"];
      User hostUser = getUser(activityResult[0]["hostUser"])!;
      double totalPrice = activityResult[0]["totalPrice"];
      String timestamp = activityResult[0]["timestamp"];
      bool comitted = activityResult[0]["comitted"] == 1;
      Activity activity = Activity(code, timestamp, hostUser, totalPrice, name, committed: comitted);
      List<Map> activityEntries = await dbWrapper.executeWithResult("SELECT * FROM Activity, ActivityEntry WHERE Activity.code = ActivityEntry.code AND Activity.code = $code");
      for (Map entryRecord in activityEntries){
        User user = getUser(entryRecord["user"])!;
        double price = entryRecord["price"];
        ActivityEntry activityEntry = ActivityEntry(user, price);
        activity.entries.add(activityEntry);
      }
      activities[code] = activity;
    }
    return activities;
  }

  Future<void> addUser(User user, {bool replace = false}) async {
    if (getUser(user.userID) == null || replace){
      String key = "";
      await dbWrapper.execute("INSERT INTO User VALUES ('${user.userID}', '${user.firstName}', '${user.lastName}', '${user.email}', '$key', ${user.frozen ? 1 : 0})");
      users[user.userID] = user;
    }
  }

  Future<void> removeUser(User user) async {
    await dbWrapper.execute("DELETE FROM User WHERE userID = '${user.userID}';");
    users.remove(user.userID);
  }

  Future<void> updateUser(User user) async {
    String key = "";
    await dbWrapper.execute("UPDATE User SET firstName = '${user.firstName}', lastName = '${user.lastName}', email = '${user.email}', key = '$key', frozen = ${user.frozen ? 1 : 0} WHERE userID = '${user.userID}';");
  }

  Future<void> addActivity(Activity activity, {bool replace = false}) async {
    if (getActivity(activity.code) == null || replace){
      await dbWrapper.execute("INSERT INTO Activity VALUES ('${activity.code}', '${activity.name}', '${activity.hostUser.userID}', ${activity.totalPrice}, '${activity.timestamp}', ${activity.committed ? 1 : 0})");
      await dbWrapper.execute("DELETE FROM ActivityEntry WHERE code = '${activity.code}';");
      for (ActivityEntry entry in activity.entries){
        await dbWrapper.execute("INSERT INTO ActivityEntry VALUES ('${activity.code}', '${entry.user.userID}', ${entry.price})");
      }
      activities[activity.code] = activity;
    }
  }

  Future<void> removeActivity(Activity activity) async {
    await dbWrapper.execute("INSERT INTO Activity VALUES ('${activity.code}', '${activity.name}', '${activity.hostUser.userID}', ${activity.totalPrice}, '${activity.timestamp}', ${activity.committed ? 1 : 0})");
    await dbWrapper.execute("DELETE FROM ActivityEntry WHERE code = '${activity.code}';");
    activities.remove(activity.code);
  }

  Future<void> updateActivity(Activity activity) async {
    await dbWrapper.execute("DELETE FROM ActivityEntry WHERE code = '${activity.code}';");
    await dbWrapper.execute("INSERT INTO Activity VALUES ('${activity.code}', '${activity.name}', '${activity.hostUser.userID}', ${activity.totalPrice}, '${activity.timestamp}', ${activity.committed ? 1 : 0})");
    await dbWrapper.execute("DELETE FROM ActivityEntry WHERE code = '${activity.code}';");
    for (ActivityEntry entry in activity.entries){
      await dbWrapper.execute("INSERT INTO ActivityEntry VALUES ('${activity.code}', '${entry.user.userID}', ${entry.price})");
    }
  }
}