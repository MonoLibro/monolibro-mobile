import 'package:monolibro/monolibro/models/payload.dart';
import 'package:monolibro/monolibro/state.dart';
import 'package:monolibro/monolibro/wsclient.dart';

class Context{
  WSClient ws;
  State state;
  Payload payload;

  Context(this.ws, this.state, this.payload);
}