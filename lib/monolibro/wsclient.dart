import 'dart:convert';

import 'package:monolibro/monolibro/context.dart';
import 'package:monolibro/monolibro/models/payload.dart';
import 'package:monolibro/monolibro/operation.dart';
import 'package:monolibro/monolibro/state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef MessageHandler = void Function(Context context);
typedef AsyncMessageHandler = Future<void> Function(Context context);

class WSClient{
  late WebSocketChannel channel;
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
      var decodedMessage = jsonDecode(data);
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
    });
  }
}