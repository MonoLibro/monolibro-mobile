import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:monolibro/globals/encoding_utils.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';

class CryptographyUtils {
  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair(
      {int keyLength = 2048}) {
    var rng = SecureRandom('Fortuna')
      ..seed(
          KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));

    var gen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), keyLength, 64),
          rng));

    final pair = gen.generateKeyPair();

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
        pair.publicKey as RSAPublicKey, pair.privateKey as RSAPrivateKey);
  }

  static String rsaPublicKeyToDEREncoded(RSAPublicKey publicKey) {
    var algSeq = ASN1Sequence();
    algSeq.add(ASN1ObjectIdentifier.fromName('rsaEncryption'));
    algSeq.add(ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0])));

    var keySeq = ASN1Sequence();
    keySeq.add(ASN1Integer(publicKey.modulus));
    keySeq.add(ASN1Integer(publicKey.exponent));
    var keyBitStr =
        ASN1BitString(stringValues: Uint8List.fromList(keySeq.encode()));

    var rootSeq = ASN1Sequence();
    rootSeq.add(algSeq);
    rootSeq.add(keyBitStr);

    return EncodingUtils.base64UrlNoPaddingEncode(rootSeq.encode());
  }

  static RSAPublicKey derEncodedToRSAPublicKey(String pubKeyDerEncoded) {
    var pubKeyDer = EncodingUtils.base64UrlNoPaddingDecode(pubKeyDerEncoded);
    return CryptoUtils.rsaPublicKeyFromDERBytes(pubKeyDer);
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
