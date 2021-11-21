import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
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
    RSAPublicKey publicKey = CryptoUtils.rsaPublicKeyFromDERBytes(
            Uint8List.fromList(utf8.encode(rawPublicKey)));;
    return User(data["userID"], data["firstName"], data["lastName"], data["email"], publicKey);
  }
}