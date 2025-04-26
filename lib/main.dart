import 'package:flutter/material.dart';
import 'package:js_quiz/constants/constants.dart';
import 'package:js_quiz/quiz_screen/quiz_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz app',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: QuizColors.primaryColor),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white, surfaceTintColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: QuizScreen(),
    );
  }
}
