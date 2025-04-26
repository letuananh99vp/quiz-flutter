import 'package:flutter/material.dart';
import 'package:js_quiz/quiz_screen/widgets/course_item.dart';

class QuizColors {
  static const Color primaryColor = Color(0xFF0F469A);
  static const Color boxshadowColor = Color.fromRGBO(0, 0, 0, 0.25);
}

class QuizConstants {
  static List<CourseItem> courseList = [
    CourseItem(
      imgSrc:
          "https://static.vecteezy.com/system/resources/previews/027/127/463/non_2x/javascript-logo-javascript-icon-transparent-free-png.png",
      url:
          "https://raw.githubusercontent.com/lydiahallie/javascript-questions/master/README.md",
      name: "JavaScript",
      bgColor: 'FEF8DC',
      processColor: 'DAB92C',
      localKey: 'javascript',
    ),
  ];
}

class QuizData {
  String question = '';
  String code = '';
  List<String> options = [];
  String correctAnswer = '';
  String explanation = '';

  QuizData(
      {required this.question,
      required this.code,
      required this.options,
      required this.correctAnswer,
      required this.explanation});
}

class StatusAnswer {
  int correctAnswer = 0;
  int incorrectAnswer = 0;
  StatusAnswer({required this.correctAnswer, required this.incorrectAnswer});
  int get totalAnswers => correctAnswer + incorrectAnswer;
}
