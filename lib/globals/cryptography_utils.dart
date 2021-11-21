import 'dart:convert';

import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/asn1/asn1_parser.dart';
import 'package:pointycastle/asymmetric/api.dart';

class CryptographyUtils {
  RSAPublicKey asn1ToRSAPublicKey(String ans1) {
    var rootSeq = ASN1Parser(base64Decode(ans1)).nextObject() as ASN1Sequence;
    var keySeq = rootSeq.elements![1] as ASN1Sequence;

    var modulus = keySeq.elements![0] as ASN1Integer;
    var exponent = keySeq.elements![1] as ASN1Integer;

    return RSAPublicKey(modulus.integer!, exponent.integer!);
  }
}