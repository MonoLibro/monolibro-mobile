enum Intention{
  // DO NOT change the order of the operation
  debug,
  broadcast,
  specific,
  system,
}

extension IntentionExtension on Intention{
  int get value {
    return Intention.values.indexOf(this) - 1;
  }
}