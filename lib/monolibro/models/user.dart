import 'package:monolibro/globals/cryptography_utils.dart';
import 'package:pointycastle/asymmetric/api.dart';

class User{
  String userID;
  String firstName;
  String lastName;
  String email;
  RSAPublicKey publicKey;

  User(this.userID, this.firstName, this.lastName, this.email, this.publicKey);

  factory User.fromJson(dynamic data){
    String rawPublicKey = data["publicKey"];
    RSAPublicKey publicKey = CryptographyUtils.asn1ToRSAPublicKey(rawPublicKey);
    return User(data["userID"], data["firstName"], data["lastName"], data["email"], publicKey);
  }
}