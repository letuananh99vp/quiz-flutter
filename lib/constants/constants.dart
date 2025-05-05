import 'package:flutter/material.dart';
import 'package:js_quiz/quiz_screen/widgets/course_item.dart';

class QuizColors {
  static const Color primaryColor = Color(0xFF0F469A);
  static const Color boxshadowColor = Color.fromRGBO(0, 0, 0, 0.25);
}

class QuizConstants {
  static const String baseUrl =
      "https://quizapi.io/api/v1/questions?apiKey=69Zuah9dgDUM8ruNelJBH4EKnEotbCidFZW9lJqQ";
  static List<CourseItem> courseList = [
    CourseItem(
      imgSrc:
          "https://i.pinimg.com/originals/13/40/7c/13407c12f50f08d328800c3caef43f61.png",
      url:
          "https://raw.githubusercontent.com/lydiahallie/javascript-questions/master/README.md",
      name: "JavaScript",
    ),
    ...[
      {
        "imgSrc": "https://cdn-icons-png.flaticon.com/512/15474/15474213.png",
        "url": "$baseUrl&category=html",
        "name": "HTML"
      },
      {
        "imgSrc":
            "https://creazilla-store.fra1.digitaloceanspaces.com/icons/3244252/nextjs-icon-md.png",
        "url": "$baseUrl&category=next-js",
        "name": "Nextjs"
      },
      {
        "imgSrc":
            "https://pluspng.com/img-png/nodejs-png-node-js-on-light-background-1843.png",
        "url": "$baseUrl&category=nodejs",
        "name": "Nodejs"
      },
      {
        "imgSrc":
            "https://static-00.iconduck.com/assets.00/react-javascript-js-framework-facebook-icon-2048x1822-f7kq7hho.png",
        "url": "$baseUrl&category=react",
        "name": "React"
      },
      {
        "imgSrc":
            "https://cdn.freebiesupply.com/logos/large/2x/vue-9-logo-png-transparent.png",
        "url": "$baseUrl&category=vuejs",
        "name": "Vuejs"
      },
      {
        "imgSrc": "https://pngimg.com/uploads/linux/linux_PNG21.png",
        "url": "$baseUrl&category=linux",
        "name": "Linux"
      },
      {
        "imgSrc":
            "https://cdn4.iconfinder.com/data/icons/logos-and-brands/512/97_Docker_logo_logos-1024.png",
        "url": "$baseUrl&category=docker",
        "name": "Docker"
      },
      {
        "imgSrc": "https://icons.veryicon.com/png/o/folder/folder-2/sql-4.png",
        "url": "$baseUrl&category=sql",
        "name": "SQL"
      },
      {
        "imgSrc":
            "https://logospng.org/download/laravel/logo-laravel-icon-1024.png",
        "url": "$baseUrl&category=laravel",
        "name": "Laravel"
      },
      {
        "imgSrc":
            "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/postgresql-icon.png",
        "url": "$baseUrl&category=postgres",
        "name": "Postgres"
      },
      {
        "imgSrc":
            "https://brandslogos.com/wp-content/uploads/images/large/django-logo.png",
        "url": "$baseUrl&category=django",
        "name": "Django"
      },
      {
        "imgSrc":
            "https://static.vecteezy.com/system/resources/previews/020/975/579/original/wordpress-logo-wordpress-icon-transparent-free-png.png",
        "url": "$baseUrl&category=wordpress",
        "name": "Wordpress"
      },
    ].map((item) => CourseItem(
          imgSrc: item["imgSrc"]!,
          url: item["url"]!,
          name: item["name"]!,
        )),
  ];
}

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
