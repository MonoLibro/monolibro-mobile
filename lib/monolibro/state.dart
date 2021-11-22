import 'package:monolibro/globals/database.dart';
import 'package:monolibro/monolibro/models/activity.dart';
import 'package:monolibro/monolibro/models/activity_entry.dart';
import 'package:monolibro/monolibro/models/user.dart';
import 'package:monolibro/monolibro/voting_session.dart';
import 'package:pointycastle/asymmetric/api.dart';

class State{
  Map<String, VotingSession> votingSessions = {};
  Map<String, Activity> activities = {};
  Map<String, User> users = {};

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

  Future<void> init() async {
    users = await getUsers();
    activities = await getActivites();
  }

  Future<Map<String, User>> getUsers() async {
    Map<String, User> users = {};
    List<Map> userRecords = await dbWrapper.executeWithResult("SELECT * FROM User;");
    for (Map record in userRecords){
      String userID = record["userID"];
      String firstName = record["firstName"];
      String lastName = record["lateName"];
      String email = record["email"];
      RSAPublicKey? publicKey = null;
      bool frozen = record["frozen"] == 1;
      users[userID] = User(userID, firstName, lastName, email, publicKey!, frozen);
    }
    return users;
  }
  
  Future<Map<String, Activity>> getActivites() async {
    Map<String, Activity> activities = {};
    List<Map> activityCodeRecords = await dbWrapper.executeWithResult("SELECT code * FROM Activity;");
    List<String> activityCodes = [for (Map i in activityCodeRecords) i["code"]];
    for (String code in activityCodes){
      List<Map> activityEntries = await dbWrapper.executeWithResult("SELECT * FROM Activity, ActivityEntry WHERE Activity.code = ActivityEntry.code");
      String name = activityEntries[0]["name"];
      User hostUser = getUser(activityEntries[0]["hostUser"])!;
      double totalPrice = activityEntries[0]["totalPrice"];
      String timestamp = activityEntries[0]["timestamp"];
      bool comitted = activityEntries[0]["comitted"] == 1;
      Activity activity = Activity(code, timestamp, hostUser, totalPrice, name, committed: comitted);
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
}