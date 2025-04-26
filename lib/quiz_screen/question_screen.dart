import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/mono-blue.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:js_quiz/constants/constants.dart';
import 'package:js_quiz/quiz_screen/widgets/button.dart';
import 'package:js_quiz/quiz_screen/widgets/confirm_dialog.dart';
import 'package:js_quiz/repositories/preference_repository.dart';

import 'widgets/answer_item.dart';

class QuestionScreen extends StatefulWidget {
  final List<QuizData> questions;
  final String courseName;
  final String localKey;
  final Function onSaved;
  const QuestionScreen(
      {super.key,
      required this.questions,
      required this.courseName,
      required this.localKey,
      required this.onSaved});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  bool _isExpanded = false;
  int _currentQuestion = 1;
  Map<String, dynamic> _answers = {};
  bool isDisabledSaveBtn = true;
  final StatusAnswer _statusAnswer =
      StatusAnswer(correctAnswer: 0, incorrectAnswer: 0);

  @override
  void initState() {
    super.initState();
    getDataPreferenceRepo();
  }

  getDataPreferenceRepo() async {
    List<QuizData> data = widget.questions;
    Map<String, dynamic> answers =
        await PreferenceRepository().getSaveData(widget.localKey);
    for (int index = 1; index <= answers.length; index++) {
      String? savedAnswer = answers['$index'];
      if (savedAnswer != null) {
        if (savedAnswer == data[index - 1].correctAnswer) {
          _statusAnswer.correctAnswer++;
        } else if (savedAnswer != data[index - 1].correctAnswer) {
          _statusAnswer.incorrectAnswer++;
        }
      }
    }
    setState(() {
      _answers = answers;
      _currentQuestion = answers.length + 1;
    });
  }

  _handleSaveAnswer() {
    PreferenceRepository().saveData(widget.localKey, _answers);
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    QuizData? quizData = widget.questions[_currentQuestion - 1];
    int totalQuestions = widget.questions.length;
    String selectedAnswer = _answers['$_currentQuestion'] ?? '';
    int remaining = totalQuestions - _statusAnswer.totalAnswers;

    return SafeArea(
        bottom: false,
        child: Scaffold(
          extendBody: true,
          appBar: _buildAppBar(totalQuestions, remaining),
          body: Container(
            margin: EdgeInsets.fromLTRB(16, 16, 16, 96),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: QuizColors.boxshadowColor,
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
                    '($_currentQuestion) ${quizData!.question}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    width: double.infinity,
                    height: quizData.code.isEmpty ? 0 : null,
                    color: Color(0xffeaeef3),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
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
                  ),
                  ...quizData.options.map((question) => AnswerItem(
                        question: question,
                        selectedAnswer: selectedAnswer,
                        correctAnswer: quizData.correctAnswer,
                        onTap: () => {
                          if (selectedAnswer.isEmpty)
                            {
                              setState(() {
                                _answers['$_currentQuestion'] = question[0];
                                isDisabledSaveBtn = false;
                                if (question[0] == quizData.correctAnswer) {
                                  _statusAnswer.correctAnswer++;
                                } else {
                                  _statusAnswer.incorrectAnswer++;
                                }
                              })
                            }
                        },
                      )),
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
          bottomNavigationBar: _buildBottomBar(selectedAnswer),
        ));
  }

  _buildAppBar(int totalQuestions, int remaining) {
    return AppBar(
      toolbarHeight: 76,
      centerTitle: true,
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (isDisabledSaveBtn) {
              Navigator.pop(context);
              return;
            }
            showConfirmDialog(context).then((value) {
              if (value == true) {
                _handleSaveAnswer();
              }
              Navigator.pop(context);
            });
          }),
      title: Column(
        children: [
          Text(
            widget.courseName,
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomBar(String selectedAnswer) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 14,
        children: [
          ButtonWidget(
            onPressed: () {
              _handleSaveAnswer();
              setState(() {
                isDisabledSaveBtn = true;
              });
            },
            text: "Lưu",
            width: 70,
            isDisabled: isDisabledSaveBtn,
          ),
          Row(
            spacing: 14,
            children: [
              ButtonWidget(
                onPressed: () => {
                  setState(() {
                    _isExpanded = false;
                    if (_currentQuestion > 1) {
                      _currentQuestion = _currentQuestion - 1;
                    }
                  })
                },
                text: "Previous",
                width: 100,
                isDisabled: _currentQuestion == 1,
              ),
              ButtonWidget(
                onPressed: () => {
                  setState(() {
                    _isExpanded = false;
                    if (_currentQuestion < widget.questions.length) {
                      _currentQuestion = _currentQuestion + 1;
                    }
                  })
                },
                text: "Next",
                width: 100,
                isDisabled: _currentQuestion == widget.questions.length ||
                    selectedAnswer.isEmpty,
              ),
            ],
          )
        ],
      ),
    );
  }
}
