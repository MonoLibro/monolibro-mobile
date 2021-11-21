import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:monolibro/monolibro/context.dart';
import 'package:monolibro/monolibro/models/key_exchange_data.dart';
import 'package:monolibro/monolibro/models/payload.dart';
import 'package:monolibro/monolibro/operation.dart';
import 'package:monolibro/monolibro/state.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef MessageHandler = void Function(Context context);
typedef AsyncMessageHandler = Future<void> Function(Context context);

class WSClient{
  late WebSocketChannel channel;
  late RSAPublicKey publicKey;
  Map<Operation, List<MessageHandler>> handlers = {};
  Map<Operation, List<AsyncMessageHandler>> asyncHandlers = {};


  State state = State();

  WSClient(String address, int port){
    channel = WebSocketChannel.connect(
      Uri.parse("ws://$address:$port")
    );
  }

  void registerHandler(Operation operation, MessageHandler callback){
    if (!handlers.containsKey(operation)){
      handlers[operation] = <MessageHandler>[];
    }
    handlers[operation]!.add(callback);
  }

  void registerAsyncHandler(Operation operation, AsyncMessageHandler callback){
    if (!asyncHandlers.containsKey(operation)){
      asyncHandlers[operation] = <AsyncMessageHandler>[];
    }
    asyncHandlers[operation]!.add(callback);
  }

  void ready(){
    channel.stream.listen((data) {
      Map decodedMessage = jsonDecode(data);
      if (decodedMessage.containsKey("publicKey")){
        KeyExchangeData keyExchangeData = KeyExchangeData.fromJson(data);
        var publicKey = CryptoUtils.rsaPublicKeyFromDERBytes(
            Uint8List.fromList(utf8.encode(keyExchangeData.publicKey)));
      }
      else{
        Payload payload = Payload.fromJson(decodedMessage);
        Context ctx = Context(this, state, payload);
        if (handlers.containsKey(payload.operation)){
          for (MessageHandler handler in handlers[payload.operation]!){
            handler(ctx);
          }
        }
        if (asyncHandlers.containsKey(payload.operation)){
          for (MessageHandler handler in asyncHandlers[payload.operation]!){
            handler(ctx);
          }
        } 
      }
    });
  }
}