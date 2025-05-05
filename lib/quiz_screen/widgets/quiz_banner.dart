import 'package:flutter/material.dart';

class QuizBanner extends StatelessWidget {
  const QuizBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(24),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(
              'https://i.pinimg.com/474x/b2/1f/c1/b21fc18ff7f31908414f9ed3f818346e.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Color.fromARGB(71, 15, 71, 154),
            BlendMode.darken,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Test Your Knowledge with Quizzes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "You're just looking for a playful way to learn new facts, our quizzes are designed to entertain and educate.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
          Expanded(
            flex: 1,
            child: SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
