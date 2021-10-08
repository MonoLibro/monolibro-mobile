import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/globals/theme_colors.dart';

class InputText extends StatelessWidget{
  const InputText({Key? key, this.hint}) : super(key: key);
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: 40,
        child: TextField(
          cursorColor: ThemeColors.defaultAccent[3],
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeColors.grayAccent[2]),
            ),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeColors.defaultAccent[3]),
            )
          ),
        )
      ),
    );
  }
}