import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/export.dart';

class CryptographyUtils {
  static Uint8List _processInBlocks(
      AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }

  static Uint8List rsaEncryptOAEP(Uint8List data, RSAPublicKey publicKey) {
    var cipher = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

    return _processInBlocks(cipher, data);
  }

  static Uint8List rsaSignPSS(Uint8List dataToSign, RSAPrivateKey privateKey) {
    var signer = RSASigner(SHA256Digest(), '0609608648016503040201')
      ..init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));

    var sig = signer.generateSignature(dataToSign);

    return sig.bytes;
  }

  static bool rsaVerifyPSS(
      Uint8List data, Uint8List signature, RSAPublicKey publicKey) {
    var verifier = RSASigner(SHA256Digest(), '0609608648016503040201')
      ..init(false, PublicKeyParameter<RSAPublicKey>(publicKey));

    var sig = RSASignature(signature);

    try {
      return verifier.verifySignature(data, sig);
    } on ArgumentError {
      return false;
    }
  }
}
