import 'dart:async';

import 'package:monolibro/monolibro/voting_session.dart';

class State{
  Map<String, VotingSession> votingSessions = {};
  StreamController<String> debugStream = StreamController<String>();
}