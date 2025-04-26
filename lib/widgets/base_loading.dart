import 'package:flutter/material.dart';
import 'package:js_quiz/constants/constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BaseLoading extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  const BaseLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading
            ? Container(
                decoration: BoxDecoration(color: QuizColors.primaryColor),
                child: Center(
                  child: LoadingAnimationWidget.inkDrop(
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              )
            : SizedBox.shrink()
      ],
    );
  }
}
