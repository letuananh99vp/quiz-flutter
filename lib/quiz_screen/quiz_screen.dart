import 'package:flutter/material.dart';
import 'package:js_quiz/constants/constants.dart';
import 'package:js_quiz/quiz_screen/widgets/course_item.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Scaffold(
            body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 18,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quiz",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                ...QuizConstants.courseList.map((item) => CourseItem(
                    url: item.url, imgSrc: item.imgSrc, name: item.name)),
              ],
            ),
          ),
        )));
  }
}
