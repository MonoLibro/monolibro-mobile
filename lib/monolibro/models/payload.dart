import 'package:monolibro/monolibro/models/details.dart';
import 'package:monolibro/monolibro/operation.dart';

class Payload {

  int version;
  String sessionID;
  Details details;
  Operation operation;
  Map<String, dynamic> data;

  Payload(this.version, this.sessionID, this.details, this.operation, this.data);

  factory Payload.fromJson(dynamic json) {
    Details details = Details.fromJson(json["details"]);
    Operation operation = Operation.values[json["operation"] + 2];
    return Payload(json["version"], json["sessionID"], details, operation, json["data"]);
  }

  @override
  String toString() {
    return '';
  }
}