import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/mono-blue.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:js_quiz/constants/constants.dart';
import 'package:js_quiz/quiz_screen/widgets/button.dart';
import 'package:js_quiz/quiz_screen/widgets/confirm_dialog.dart';
import 'package:js_quiz/repositories/preference_repository.dart';
import 'package:js_quiz/widgets/base_loading.dart';

import 'widgets/answer_item.dart';

class QuestionScreen extends StatefulWidget {
  final List<QuizData> questions;
  final String courseName;
  final String localKey;
  final Function onReset;
  const QuestionScreen(
      {super.key,
      required this.questions,
      required this.courseName,
      required this.localKey,
      required this.onReset});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  bool _isExpanded = false;
  int _currentQuestion = 1;
  Map<String, dynamic> _answers = {};
  bool isChanged = true;
  late StatusAnswer _statusAnswer =
      StatusAnswer(correctAnswer: 0, incorrectAnswer: 0);
  bool isLoading = true;
  Timer? _saveTimer;
  final int _debounceTime = 5;

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
      isLoading = false;
    });
  }

  _handleSaveAnswer() {
    PreferenceRepository().saveData(widget.localKey, _answers);
    widget.onReset();
  }

  _onReset() {
    setState(() {
      _isExpanded = false;
      _currentQuestion = 1;
      _answers = {};
      isChanged = true;
      _statusAnswer = StatusAnswer(correctAnswer: 0, incorrectAnswer: 0);
    });
    PreferenceRepository().removeData(widget.localKey);
    widget.onReset();
  }

  _onAnswer(String selectedAnswer, String question, QuizData quizData) {
    if (selectedAnswer.isEmpty) {
      setState(() {
        _answers['$_currentQuestion'] = question[0];
        isChanged = false;
        if (question[0] == quizData.correctAnswer) {
          _statusAnswer.correctAnswer++;
        } else {
          _statusAnswer.incorrectAnswer++;
        }
      });
      // Hủy timer cũ
      _saveTimer?.cancel();

      // Đặt timer mới để lưu
      _saveTimer = Timer(Duration(seconds: _debounceTime), () {
        if (mounted) {
          _handleSaveAnswer();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    QuizData quizData = widget.questions[_currentQuestion - 1];
    int totalQuestions = widget.questions.length;
    String selectedAnswer = _answers['$_currentQuestion'] ?? '';
    int remaining = totalQuestions - _statusAnswer.totalAnswers;

    return BaseLoading(
      isLoading: isLoading,
      child: SafeArea(
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
                      '($_currentQuestion) ${quizData.question}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    if (quizData.code.isNotEmpty)
                      Container(
                        width: double.infinity,
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
                          onTap: () =>
                              _onAnswer(selectedAnswer, question, quizData),
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: selectedAnswer.isEmpty ||
                                  quizData.explanation.isEmpty
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
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
          )),
    );
  }

  _buildAppBar(int totalQuestions, int remaining) {
    return AppBar(
      toolbarHeight: 76,
      centerTitle: true,
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
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: _answers.isEmpty
              ? null
              : () {
                  showConfirmDialog(context, 'Bạn có muốn đặt lại câu trả lời?')
                      .then((value) {
                    if (value == true) {
                      _onReset();
                    }
                  });
                },
        ),
      ],
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
        mainAxisAlignment: MainAxisAlignment.end,
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
      ),
    );
  }
}
