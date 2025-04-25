import 'package:flutter/material.dart';

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
        backgroundColor: const Color(0xFF0F469A),
        foregroundColor: Colors.white,
        minimumSize: Size(width ?? double.infinity, 48),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: Text(text),
    );
  }
}
