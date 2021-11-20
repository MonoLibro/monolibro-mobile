import 'package:monolibro/monolibro/intention.dart';
import 'package:monolibro/monolibro/operation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef MessageHandler = void Function();

class WSClient{
  late WebSocketChannel channel;
  Map<Operation, MessageHandler> handlers = {};

  WSClient(String address, int port){
    channel = WebSocketChannel.connect(
      Uri.parse("ws://$address:$port")
    );
  }

  void registerHandler(Operation operation, MessageHandler callback){
    handlers[operation] = callback;
  }

  void ready(){
    channel.stream.listen((data) {
      
    });
  }
}