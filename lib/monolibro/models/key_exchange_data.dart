class KeyExchangeData{
  String format;
  String encoding;
  String publicKey;

  KeyExchangeData(this.format, this.encoding, this.publicKey);

  factory KeyExchangeData.fromJson(dynamic data){
    return KeyExchangeData(data["format"], data["encoding"], data["publicKey"]);
  }
}