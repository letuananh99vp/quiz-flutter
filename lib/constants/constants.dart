import 'package:js_quiz/quiz_js/widgets/course_item.dart';

class QuizConstants {
  static List<CourseItem> courseList = [
    CourseItem(
      url:
          "https://cdn.iconscout.com/icon/free/png-256/free-html-5-logo-icon-download-in-svg-png-gif-file-formats--programming-langugae-language-pack-logos-icons-1175208.png",
      name: "HTML",
      question: 30,
      replied: 26,
      bgColor: 'FDE4E4',
      processColor: 'F82929',
    ),
    CourseItem(
      url:
          "https://static.vecteezy.com/system/resources/previews/027/127/463/non_2x/javascript-logo-javascript-icon-transparent-free-png.png",
      name: "JavaScript",
      question: 30,
      replied: 20,
      bgColor: 'FEF8DC',
      processColor: 'DAB92C',
    ),
  ];
}
