import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:monolibro/globals/cryptography_utils.dart';
import 'package:monolibro/monolibro/models/payload.dart';

class MessageUtils {
  static String serialize(Payload payload, RSAPublicKey publicKey) {
    var payloadJson = jsonEncode(payload.toJson());

    var payloadEncrypted = CryptographyUtils.rsaEncryptOAEP(
        Uint8List.fromList(utf8.encode(payloadJson)), publicKey);

    return base64Url.encode(payloadEncrypted).split("=")[0];
  }
}
