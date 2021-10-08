import 'package:flutter/widgets.dart';

class InputGroup{
  const InputGroup({required this.inputBuilder, required this.count, required this.icon, required this.title, this.expandable});
  final Widget Function(int) inputBuilder;
  final Widget icon;
  final String title;
  final int count;
  final bool? expandable;
}

class InputLayoutControl{
  const InputLayoutControl({required this.builder, required this.count});
  final InputGroup Function(int) builder;
  final int count;
}