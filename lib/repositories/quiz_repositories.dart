import 'package:http/http.dart' as http;
import 'package:js_quiz/constants/constants.dart';
import 'package:js_quiz/utils/quiz.dart';

Future<List<QuizData>> loadQuizQuestions(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final content = response.body;
      return url.contains('github')
          ? QuizParser.parseFromGitHub(content)
          : QuizParser.convertQuizApiToQuizDataList(content);
    }
    return [];
  } catch (e) {
    return [];
  }
}
