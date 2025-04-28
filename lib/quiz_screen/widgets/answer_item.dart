import 'package:flutter/material.dart';

class AnswerItem extends StatelessWidget {
  final String question;
  final String selectedAnswer;
  final String correctAnswer;
  final Function onTap;

  const AnswerItem({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isCorrect = correctAnswer == question[0] && selectedAnswer.isNotEmpty;
    bool isIncorrect =
        selectedAnswer != correctAnswer && selectedAnswer == question[0];
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
              color: isCorrect
                  ? Color(0xff006400)
                  : isIncorrect
                      ? Color.fromRGBO(100, 0, 0, 1)
                      : Color(0xffcccccc)),
          color: isCorrect
              ? Color.fromRGBO(0, 100, 0, 0.25)
              : isIncorrect
                  ? Color.fromRGBO(100, 0, 0, 0.25)
                  : Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          question,
          style: TextStyle(fontSize: 15, color: Color(0xff343333)),
        ),
      ),
    );
  }
}
