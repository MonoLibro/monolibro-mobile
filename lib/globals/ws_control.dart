import 'package:monolibro/globals/message_handlers.dart';
import 'package:monolibro/monolibro/wsclient.dart';

class WSControl{
  late WSClient wsClient;

  WSControl(){
    wsClient = WSClient("192.168.0.235", 3200);
    register(wsClient);
    wsClient.ready();
  }
}

WSControl wsClientGlobal = WSControl();