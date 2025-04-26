import 'package:flutter/material.dart';
import 'package:js_quiz/constants/constants.dart';

class ButtonWidget extends StatelessWidget {
  final Function onPressed;
  final String text;
  final double? width;
  final bool? isDisabled;

  const ButtonWidget(
      {super.key,
      required this.onPressed,
      required this.text,
      this.width,
      this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled == true ? null : () => onPressed(),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: QuizColors.primaryColor,
        foregroundColor: Colors.white,
        minimumSize: Size(width ?? double.infinity, 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: Text(text),
    );
  }
}
