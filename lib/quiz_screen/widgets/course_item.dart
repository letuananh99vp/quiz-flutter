import 'package:flutter/material.dart';
import 'package:js_quiz/quiz_screen/question_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CourseItem extends StatelessWidget {
  final String url;
  final String name;
  final String imgSrc;
  const CourseItem({
    super.key,
    required this.url,
    required this.imgSrc,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuestionScreen(
                      url: url,
                      courseName: name,
                    )))
      },
      child: Column(
        spacing: 6,
        children: [
          Container(
            width: 80,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Color.fromRGBO(171, 194, 227, 0.27),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Image.network(
              imgSrc,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.image_not_supported),
            ),
          ),
          Text(name),
        ],
      ),
    );
  }
}
