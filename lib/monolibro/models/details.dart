import 'package:monolibro/monolibro/intention.dart';

class Details {
  Intention intention;
  String target;

  Details(this.intention, this.target);

  factory Details.fromJson(dynamic json) {
    Intention intention = Intention.values[json["intention"] + 1];
    return Details(intention, json["target"]);
  }

  Map toJson() => {
        "intention": intention.value,
        "target": target,
      };
}
