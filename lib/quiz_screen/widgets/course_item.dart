import 'package:flutter/material.dart';
import 'package:js_quiz/constants/constants.dart';
import 'package:js_quiz/quiz_screen/question_screen.dart';
import 'package:js_quiz/repositories/preference_repository.dart';
import 'package:js_quiz/repositories/quiz_repositories.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CourseItem extends StatefulWidget {
  final String url;
  final String name;
  final String bgColor;
  final String processColor;
  final String imgSrc;
  final String localKey;
  final Function? setLoading;
  const CourseItem({
    super.key,
    required this.url,
    required this.imgSrc,
    required this.name,
    required this.bgColor,
    required this.processColor,
    required this.localKey,
    this.setLoading,
  });

  @override
  State<CourseItem> createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> {
  List<QuizData> _questions = [];
  int _totalAnswer = 0;

  @override
  void initState() {
    super.initState();
    getQuizData();
  }

  getQuizData() async {
    List<QuizData> data = await loadQuizQuestionsFromGitHub(widget.url);
    widget.setLoading!(false);
    setState(() {
      _questions = data;
    });
    getDataPreferenceRepo();
  }

  getDataPreferenceRepo() async {
    Map<String, dynamic> answers =
        await PreferenceRepository().getSaveData(widget.localKey);
    setState(() {
      _totalAnswer = answers.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalQuestion = _questions.length;
    return InkWell(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuestionScreen(
                      questions: _questions,
                      courseName: widget.name,
                      onReset: () => getDataPreferenceRepo(),
                      localKey: widget.localKey,
                    )))
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
                    widget.imgSrc,
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
                    Text(widget.name),
                    Text('$totalQuestion Question'),
                  ],
                )
              ],
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Color(int.parse('0xFF${widget.bgColor}')),
                  borderRadius: BorderRadius.circular(9999)),
              child: CircularPercentIndicator(
                radius: 30.0,
                lineWidth: 5.0,
                percent: _totalAnswer / totalQuestion,
                center: Text('$_totalAnswer/$totalQuestion'),
                backgroundColor: Color(int.parse('0xFF${widget.bgColor}')),
                progressColor: Color(int.parse('0xFF${widget.processColor}')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
