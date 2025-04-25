import 'package:flutter/material.dart';
import 'package:js_quiz/quiz_js/quiz_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF0F469A)),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white, surfaceTintColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: QuizScreen(),
    );
  }
}
