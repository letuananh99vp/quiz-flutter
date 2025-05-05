import 'package:flutter/material.dart';
import 'package:js_quiz/quiz_screen/question_screen.dart';

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
    int totalQuestion = 1;
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuestionScreen(
                      url: url,
                      courseName: name,
                      onReset: () => () => {},
                    )))
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 16,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 72,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(171, 194, 227, 0.27),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Image.network(
                    imgSrc,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.question_answer),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name),
                    Text('$totalQuestion Question'),
                  ],
                )
              ],
            ),
            // Container(
            //   width: 60,
            //   height: 60,
            //   decoration: BoxDecoration(
            //       color: Color(int.parse('0xFF${widget.bgColor}')),
            //       borderRadius: BorderRadius.circular(9999)),
            //   child: CircularPercentIndicator(
            //     radius: 30.0,
            //     lineWidth: 5.0,
            //     // percent: _totalAnswer / totalQuestion ?? 0.1,
            //     center: Text('$_totalAnswer/$totalQuestion'),
            //     backgroundColor: Color(int.parse('0xFF${widget.bgColor}')),
            //     progressColor: Color(int.parse('0xFF${widget.processColor}')),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
