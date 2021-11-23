import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/asymmetric/api.dart';

class LocalUser{
  String userID;
  String firstName;
  String lastName;
  String email;
  RSAPublicKey publicKey;
  RSAPrivateKey privateKey;
  bool frozen;

  LocalUser(this.userID, this.firstName, this.lastName, this.email, this.publicKey, this.privateKey, this.frozen);

  factory LocalUser.fromJson(dynamic data){
    String rawPublicKey = data["publicKey"];
    String rawPrivateKey = data["privateKey"];
    RSAPublicKey publicKey = CryptoUtils.rsaPublicKeyFromDERBytes(
            base64Decode(rawPublicKey));
    RSAPrivateKey privateKey = CryptoUtils.rsaPrivateKeyFromDERBytes(
            base64Decode(rawPrivateKey));
    return LocalUser(data["userID"], data["firstName"], data["lastName"], data["email"], publicKey, privateKey, data["frozen"] == 1);
  }
}