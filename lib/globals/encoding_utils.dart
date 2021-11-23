import 'dart:convert';
import 'dart:typed_data';

class EncodingUtils {
  static Uint8List stringToBytes(String data) {
    return Uint8List.fromList(utf8.encode(data));
  }

  static String bytesToString(Uint8List data) {
    return utf8.decode(data);
  }

  static String base64UrlNoPaddingEncode(Uint8List data) {
    return base64Url.encode(data).split("=")[0];
  }

  static Uint8List base64UrlNoPaddingDecode(String data) {
    return base64Url.decode(data + '=' * (4 - data.length % 4));
  }
}
