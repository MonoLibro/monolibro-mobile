import 'package:fluttertoast/fluttertoast.dart';
import 'package:monolibro/globals/cryptography_utils.dart';
import 'package:monolibro/globals/database.dart';
import 'package:monolibro/globals/message_utils.dart';
import 'package:monolibro/globals/ws_control.dart';
import 'package:monolibro/monolibro/context.dart';
import 'package:monolibro/monolibro/intention.dart';
import 'package:monolibro/monolibro/models/activity.dart';
import 'package:monolibro/monolibro/models/activity_action.dart';
import 'package:monolibro/monolibro/models/activity_entry.dart';
import 'package:monolibro/monolibro/models/details.dart';
import 'package:monolibro/monolibro/models/payload.dart';
import 'package:monolibro/monolibro/models/user.dart';
import 'package:monolibro/monolibro/operation.dart';
import 'package:monolibro/monolibro/voting_session.dart';
import 'package:monolibro/monolibro/wsclient.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:uuid/uuid.dart';

void register(WSClient client){
  client.registerHandler(Operation.createAccountInit, (Context context){
    String userID = context.payload.data["userID"];
    Fluttertoast.showToast(
      msg: "Creating Account: ${userID}",
      toastLength: Toast.LENGTH_SHORT,
    );
    String firstName = context.payload.data["firstName"];
    String lastName = context.payload.data["lastName"];
    String email = context.payload.data["lastName"];
    String publicKey = context.payload.data["publicKey"];
    AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keypair = CryptographyUtils.generateRSAKeyPair();
    User user = User(userID, firstName, lastName, email, keypair.publicKey, false);
    wsClientGlobal.wsClient.state.addUser(user);
  });

  client.registerHandler(Operation.joinActivity, (Context context){
    String code = context.payload.data["activity"];
    Fluttertoast.showToast(
      msg: "Join Activity: ${code}",
      toastLength: Toast.LENGTH_SHORT,
    );
    String userID = context.payload.data["user"];
    double price = context.payload.data["price"];
    if (!wsClientGlobal.wsClient.state.activities.containsKey(code)) return;
    var activity = wsClientGlobal.wsClient.state.getActivity(code);
    var user = wsClientGlobal.wsClient.state.getUser(userID);
    if (!activity!.amIHost()) return;
    if (activity.committed) return;
    List<ActivityEntry> entries = activity.entries;
    List<List> entriesSerialized = [];
    for (ActivityEntry i in entries){
      List listItem = [i.user.userID, i.price];
      entriesSerialized.add(listItem);
    }
    Map<String, dynamic> data = {
      "code": activity.code,
      "name": activity.name,
      "hostUser": activity.hostUser.userID,
      "timestamp": activity.timestamp,
      "totalPrice": activity.totalPrice,
      "entries": entriesSerialized
    };
    activity.subscribedStream.add(
      ActivityAction(
        Action.memberJoin,
        user: user,
        price: price,
      )
    );
    Payload replyPayload = Payload(
      1,
      context.payload.sessionID,
      Details(
        Intention.specific,
        userID,
      ),
      Operation.joinActivityData,
      data
    );
    String replyMsg = MessageUtils.serialize(replyPayload, wsClientGlobal.wsClient.state.localUser!.privateKey);
    wsClientGlobal.wsClient.channel.sink.add(replyMsg);
  });

  client.registerHandler(Operation.joinActivityData, (Context context){
    String code = context.payload.data["code"];
    Fluttertoast.showToast(
      msg: "Data Recieved: ${code}",
      toastLength: Toast.LENGTH_SHORT,
    );
    if (!wsClientGlobal.wsClient.state.waitingActivities.containsKey(code)) return;
    String timestamp = context.payload.data["timestamp"];
    String hostUserID = context.payload.data["hostUser"];
    User hostUser = wsClientGlobal.wsClient.state.getUser(hostUserID)!;
    double totalPrice = context.payload.data["totalPrice"];
    String name = context.payload.data["name"];
    List<dynamic> entriesRaw = context.payload.data["entries"];
    Activity activity = Activity(code, timestamp, hostUser, totalPrice, name);
    
    for (List i in entriesRaw){
      User user = wsClientGlobal.wsClient.state.getUser(i[0])!;
      double price = i[1];
      activity.entries.add(
        ActivityEntry(user, price)
      );
    }
    
    wsClientGlobal.wsClient.state.waitingActivities[code]!.sink.add(activity);
  });

    client.registerAsyncHandler(Operation.syncUsers, (Context context) async {
    // When recieving the user
    String userID = context.payload.data["userID"];
    String firstName = context.payload.data["firstName"];
    String lastName = context.payload.data["lastName"];
    String email = context.payload.data["lastName"];
    String publicKey = context.payload.data["publicKey"];
    AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keypair = CryptographyUtils.generateRSAKeyPair();
    User user = User(userID, firstName, lastName, email, keypair.publicKey, false);
    await wsClientGlobal.wsClient.state.addUser(user);

    // Sends all users from self
    var qResult = await dbWrapper.executeWithResult("SELECT * FROM User");
    List payloadData = qResult;
    Payload p = Payload(1, Uuid().v4(), Details(Intention.specific, "userID"), Operation.syncUsersData, {
      "sync": true,
      "syncData": payloadData,
    });
    var pk = wsClientGlobal.wsClient.state.localUser!.privateKey;
    var msg = MessageUtils.serialize(p, pk);
    wsClientGlobal.wsClient.channel.sink.add(msg);
  });
  
  client.registerAsyncHandler(Operation.syncUsersData, (Context context) async {
    // When recieving the users
    if (context.payload.data["sync"]){
      wsClientGlobal.wsClient.state.userSyncStream.add(context.payload.data["syncData"]);
    }
    wsClientGlobal.wsClient.state.userSyncStream.add([]);
  });
}