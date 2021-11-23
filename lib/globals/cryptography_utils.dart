import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/export.dart';

class CryptographyUtils {
  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair(
      {int keyLength = 2048}) {
    var rng = SecureRandom();

    var gen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), keyLength, 64),
          rng));

    final pair = gen.generateKeyPair();

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
        pair.publicKey as RSAPublicKey, pair.privateKey as RSAPrivateKey);
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
