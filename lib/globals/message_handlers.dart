import 'package:monolibro/globals/cryptography_utils.dart';
import 'package:monolibro/globals/ws_control.dart';
import 'package:monolibro/monolibro/context.dart';
import 'package:monolibro/monolibro/models/user.dart';
import 'package:monolibro/monolibro/operation.dart';
import 'package:monolibro/monolibro/voting_session.dart';
import 'package:monolibro/monolibro/wsclient.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';

void register(WSClient client){
  client.registerHandler(Operation.voteSessionQuery, (Context context){
    
  });
  client.registerHandler(Operation.createAccountInit, (Context context){
    String userID = context.payload.data["userID"];
    String firstName = context.payload.data["firstName"];
    String lastName = context.payload.data["lastName"];
    String email = context.payload.data["lastName"];
    String publicKey = context.payload.data["publicKey"];
    AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keypair = CryptographyUtils.generateRSAKeyPair();
    User user = User(userID, firstName, lastName, email, keypair.publicKey, false);
    wsClientGlobal.wsClient.state.addUser(user);
  });
}