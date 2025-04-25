import 'package:flutter/material.dart';
import 'package:js_quiz/quiz_screen/question_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CourseItem extends StatelessWidget {
  final String url;
  final String name;
  final int question;
  final int replied;
  final String bgColor;
  final String processColor;
  const CourseItem(
      {super.key,
      required this.url,
      required this.name,
      required this.question,
      required this.bgColor,
      required this.processColor,
      required this.replied});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QuestionScreen()))
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
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
                    color: Color(0xffABC2E3).withOpacity(0.27),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Image.network(
                    url,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name),
                    Text('$question Question'),
                  ],
                )
              ],
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Color(int.parse('0xFF$bgColor')),
                  borderRadius: BorderRadius.circular(9999)),
              child: CircularPercentIndicator(
                radius: 30.0,
                lineWidth: 5.0,
                percent: replied / question,
                center: Text('$replied/$question'),
                backgroundColor: Color(int.parse('0xFF$bgColor')),
                progressColor: Color(int.parse('0xFF$processColor')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
