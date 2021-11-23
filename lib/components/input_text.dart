import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/theme_colors.dart';

class InputText extends StatelessWidget {
  InputText({Key? key, this.hint, this.controller, this.errorMessage, this.error, this.keyboardType, this.focusNode}) : super(key: key);
  final TextEditingController? controller;
  final String? hint;
  final String? errorMessage;
  final bool? error;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: TextField(
              keyboardType: keyboardType,
              focusNode: focusNode,
              controller: controller,
              cursorColor: ThemeColors.defaultAccent[3],
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: (error??false) ? ThemeColors.errorAccent[0] : ThemeColors.grayAccent[2]),
                ),
                hintText: hint,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: (error??false) ? ThemeColors.errorAccent[0] : ThemeColors.defaultAccent[3]),
                )
              ),
            )
          ),
          Visibility(
            visible: error ?? false,
            child: Paragraph(
              text: errorMessage ?? "",
              color: ThemeColors.errorAccent[0]
            )
          )
        ],
      )
    );
  }
}
