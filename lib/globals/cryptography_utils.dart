import 'dart:convert';
import 'package:pointycastle/asn1/asn1_parser.dart';
import 'package:pointycastle/asymmetric/api.dart';

class CryptographyUtils{
  String encodePublicKeyToASN_1(RSAPublicKey publicKey){
    
  }

  RSAPublicKey decodePublicKeyFromASN_1(String ans1){
    // Codec<String, String> stringToBase64 = utf8.fuse(base64);
    ASN1Parser p = ASN1Parser(base64Url.decode(ans1));
    p.
  }
}