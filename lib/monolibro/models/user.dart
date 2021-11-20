import 'package:pem/pem.dart';
import 'package:pointycastle/asymmetric/api.dart';

class User {
  String userID;
  String firstName;
  String lastName;
  String email;
  RSAPublicKey publicKey;

  User(this.userID, this.firstName, this.lastName, this.email, this.publicKey);

  factory User.fromJson(dynamic json) {
    
    return User(
      json['userID'] as String, json['firstName'] as String, json['lastName'] as String, json['email'] as String, pk);
  }

  @override
  String toString() {
    return '';
  }
}