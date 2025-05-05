import 'package:flutter/material.dart';
import 'package:js_quiz/constants/constants.dart';
import 'package:js_quiz/quiz_screen/widgets/course_item.dart';
import 'package:js_quiz/quiz_screen/widgets/quiz_banner.dart';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuizBanner(),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: QuizConstants.courseList.length,
                  itemBuilder: (context, index) {
                    return CourseItem(
                      url: QuizConstants.courseList[index].url,
                      imgSrc: QuizConstants.courseList[index].imgSrc,
                      name: QuizConstants.courseList[index].name,
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
