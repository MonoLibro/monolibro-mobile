import 'package:monolibro/monolibro/context.dart';
import 'package:monolibro/monolibro/operation.dart';
import 'package:monolibro/monolibro/wsclient.dart';

void register(WSClient client){
  client.registerHandler(Operation.voteSessionQuery, (Context context){
    
  });
  client.registerHandler(Operation.clientDebug, (Context context){
    context.state.debugStream.sink.add(context.payload.data["debuginfo"]);
  });
}