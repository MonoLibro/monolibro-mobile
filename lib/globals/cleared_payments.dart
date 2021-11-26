import 'package:monolibro/monolibro/models/user.dart';

class ClearedPayments{
  User user;
  String timestamp;
  double payment;
  bool isActiveReciever;

  ClearedPayments(this.user, this.timestamp, this.payment, this.isActiveReciever);
}