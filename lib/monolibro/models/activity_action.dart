import 'package:monolibro/monolibro/models/user.dart';

enum Action{
  memberJoin,
  memberLeave,
  update,
  commit,
  exit,
}

class ActivityAction{
  Action action;
  User? user;
  double? price;

  ActivityAction(this.action, {this.user, this.price});
}