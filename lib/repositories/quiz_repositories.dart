import 'package:http/http.dart' as http;
import 'package:js_quiz/quiz_screen/question_screen.dart';
import 'package:js_quiz/utils/quiz.dart';

Future<List<QuizData>> loadQuizQuestionsFromGitHub() async {
  try {
    final url =
        'https://raw.githubusercontent.com/lydiahallie/javascript-questions/master/README.md';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final content = response.body;
      return QuizParser.parseFromGitHub(content);
    }
    return [];
  } catch (e) {
    return [];
  }
}
