import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/mono-blue.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:js_quiz/quiz_js/widgets/button.dart';
import 'package:js_quiz/repositories/quiz_repositories.dart';

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

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  bool _isExpanded = false;
  int currentQuestion = 1;
  List<QuizData?> _questions = [];
  final Map<int, String> _answers = {};
  bool isLoading = true;
  final StatusAnswer _statusAnswer =
      StatusAnswer(correctAnswer: 0, incorrectAnswer: 0);

  @override
  void initState() {
    super.initState();
    getQuizData();
  }

  getQuizData() async {
    List<QuizData> data = await loadQuizQuestionsFromGitHub();
    setState(() {
      isLoading = false;
      _questions = data;
    });
  }

  _buildAnswerItem(
      String question, String selectedAnswer, String correctAnswer) {
    bool isCorrect = correctAnswer == question[0] && selectedAnswer.isNotEmpty;
    bool isIncorrect =
        selectedAnswer != correctAnswer && selectedAnswer == question[0];
    return InkWell(
      onTap: () {
        if (selectedAnswer.isEmpty) {
          setState(() {
            _answers[currentQuestion] = question[0];
            if (question[0] == correctAnswer) {
              _statusAnswer.correctAnswer++;
            } else {
              _statusAnswer.incorrectAnswer++;
            }
          });
        }
      },
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    QuizData? quizData = _questions[currentQuestion - 1];
    int totalQuestions = _questions.length;
    String selectedAnswer = _answers[currentQuestion] ?? '';
    int remaining = totalQuestions - _statusAnswer.totalAnswers;

    return SafeArea(
        bottom: false,
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            toolbarHeight: 76,
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  "JavaScript",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "$totalQuestions Question",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(16),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Correct: ${_statusAnswer.correctAnswer}",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff006400),
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Incorrect: ${_statusAnswer.incorrectAnswer}",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff8b0000),
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Remaining: $remaining",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Container(
            margin: EdgeInsets.fromLTRB(16, 16, 16, 96),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  blurRadius: 16,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '($currentQuestion) ${quizData!.question}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: HighlightView(
                      quizData.code,
                      language: 'javascript',
                      theme: monoBlueTheme,
                      padding: EdgeInsets.all(12),
                      textStyle: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ...quizData.options.map((question) => _buildAnswerItem(
                      question, selectedAnswer, quizData.correctAnswer)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: selectedAnswer.isEmpty
                            ? null
                            : () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                        icon: Icon(_isExpanded
                            ? Icons.expand_less
                            : Icons.expand_more),
                        iconAlignment: IconAlignment.end,
                        label: Text('Show explanation'),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: SizedBox(
                          width: double.infinity,
                          height: _isExpanded ? null : 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: HtmlWidget(
                              quizData.explanation,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 14,
              children: [
                ButtonWidget(
                  onPressed: () => {
                    setState(() {
                      _isExpanded = false;
                      if (currentQuestion > 1) {
                        currentQuestion = currentQuestion - 1;
                      }
                    })
                  },
                  text: "Previous",
                  width: 100,
                  isDisabled: currentQuestion == 1,
                ),
                ButtonWidget(
                  onPressed: () => {
                    setState(() {
                      _isExpanded = false;
                      if (currentQuestion < _questions.length) {
                        currentQuestion = currentQuestion + 1;
                      }
                    })
                  },
                  text: "Next",
                  width: 100,
                  isDisabled: currentQuestion == _questions.length ||
                      selectedAnswer.isEmpty,
                ),
              ],
            ),
          ),
        ));
  }
}
