import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:monolibro/globals/cryptography_utils.dart';
import 'package:monolibro/globals/encoding_utils.dart';
import 'package:monolibro/monolibro/models/payload.dart';

class MessageUtils {
  static String serialize(Payload payload, RSAPrivateKey privateKey) {
    var payloadJson = jsonEncode(payload.toJson());
    var payloadEncoded = EncodingUtils.base64UrlNoPaddingEncode(
        EncodingUtils.stringToBytes(payloadJson));

    var signature = CryptographyUtils.rsaSignPSS(
        EncodingUtils.stringToBytes(payloadEncoded), privateKey);
    var signatureEncoded = EncodingUtils.base64UrlNoPaddingEncode(signature);

    return payloadEncoded + "." + signatureEncoded;
  }

  static Payload? deserialize(String message, RSAPublicKey publicKey) {
    var msgSlices = message.split(".");

    var payloadEncoded = msgSlices[0];

    var signature = EncodingUtils.base64UrlNoPaddingDecode(msgSlices[1]);

    var match = CryptographyUtils.rsaVerifyPSS(
        EncodingUtils.stringToBytes(payloadEncoded), signature, publicKey);

    if (match) {
      var payloadJson = EncodingUtils.base64UrlNoPaddingDecode(payloadEncoded);
      return Payload.fromJson(
          jsonDecode(EncodingUtils.bytesToString(payloadJson)));
    } else {
      return null;
    }
  }
}
