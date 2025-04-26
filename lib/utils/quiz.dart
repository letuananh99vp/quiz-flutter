import 'package:js_quiz/constants/constants.dart';

class QuizParser {
  /// Parses quiz data from GitHub JavaScript Questions repository
  static List<QuizData> parseFromGitHub(String rawContent) {
    final List<QuizData> quizList = [];

    // Tách nội dung thành các câu hỏi riêng biệt
    // Tìm tất cả các câu hỏi bắt đầu bằng "####" và số
    final questionRegex =
        RegExp(r'#{2,6}\s*(\d+)\.\s*(.+?)(?=#{2,6}\s*\d+\.|$)', dotAll: true);
    final questionMatches = questionRegex.allMatches(rawContent);

    for (final match in questionMatches) {
      final fullQuestionText = match.group(0) ?? '';

      try {
        final quizData = parseQuizQuestion(fullQuestionText);
        quizList.add(quizData);
      } catch (e) {
        print('Error parsing question: ${e.toString()}');
        // Tiếp tục với câu hỏi tiếp theo nếu có lỗi
      }
    }

    return quizList;
  }

  /// Parse một câu hỏi đơn lẻ
  static QuizData parseQuizQuestion(String questionText) {
    String question = '';
    String code = '';
    List<String> options = [];
    String correctAnswer = '';
    String explanation = '';

    // Tách thành phần câu hỏi và phần đáp án
    final parts = questionText.split('<details>');
    if (parts.length < 2) {
      throw FormatException('Question format not recognized');
    }

    final questionPart = parts[0];
    final answerPart = '<details>' + parts[1];

    // Lấy tiêu đề câu hỏi
    final titleRegex = RegExp(r'#{2,6}\s*\d+\.\s*(.+?)(\n|$)');
    final titleMatch = titleRegex.firstMatch(questionPart);
    if (titleMatch != null) {
      question = titleMatch.group(1)?.trim() ?? '';
    }

    // Lấy đoạn mã nếu có
    final codeRegex = RegExp(r'```[\s\S]*?```');
    final codeMatch = codeRegex.firstMatch(questionPart);
    if (codeMatch != null) {
      code = codeMatch
          .group(0)!
          .replaceFirst(RegExp(r'^```(javascript|js|dart|flutter)?\n'), '')
          .replaceFirst(RegExp(r'```$'), '')
          .trim();
    }

    // Lấy các lựa chọn
    final optionsRegex = RegExp(r'- ([A-E]):\s*(.+)', multiLine: true);
    final optionsMatches = optionsRegex.allMatches(questionPart);
    if (optionsMatches.isNotEmpty) {
      options = optionsMatches.map((m) {
        final optionLetter = m.group(1) ?? '';
        final optionText = m.group(2) ?? '';
        return '$optionLetter: $optionText'.trim();
      }).toList();
    }

    // Lấy đáp án chính xác
    final answerRegex =
        RegExp(r'#{1,6}\s*Answer:\s*([A-E])', caseSensitive: false);
    final answerMatch = answerRegex.firstMatch(answerPart);
    if (answerMatch != null) {
      correctAnswer = answerMatch.group(1) ?? '';
    }

    // Lấy phần giải thích - cần linh hoạt hơn vì định dạng có thể khác nhau
    final explanationStartIndex = answerPart.indexOf('Answer: $correctAnswer') +
        'Answer: $correctAnswer'.length;
    if (explanationStartIndex > 0 &&
        explanationStartIndex < answerPart.length) {
      // Lấy toàn bộ nội dung sau "Answer: X"
      explanation = extractExplanation(answerPart, correctAnswer);
    }

    return QuizData(
      question: question,
      code: code,
      options: options,
      correctAnswer: correctAnswer,
      explanation: explanation,
    );
  }
}

String extractExplanation(String answerPart, String correctAnswer) {
  String explanation = '';

  // Tìm vị trí bắt đầu của phần giải thích
  final answerMarker = 'Answer: $correctAnswer';
  final explanationStartIndex = answerPart.indexOf(answerMarker);

  if (explanationStartIndex >= 0) {
    // Lấy nội dung sau phần "Answer: X"
    explanation =
        answerPart.substring(explanationStartIndex + answerMarker.length);

    // Nếu có thẻ <p>, ưu tiên lấy nội dung từ đó
    final pTagRegex = RegExp(r'<p>([\s\S]*?)</p>');
    final pTagMatch = pTagRegex.firstMatch(explanation);

    if (pTagMatch != null) {
      // Lấy nội dung từ thẻ <p>
      explanation = pTagMatch.group(1) ?? '';
    } else {
      // Làm sạch nội dung nếu không có thẻ <p>
      explanation = explanation
          .replaceAll(
              RegExp(r'^[#\s]*'), '') // Loại bỏ dấu # và khoảng trắng đầu dòng
          .trim();
    }
    explanation = explanation.replaceAllMapped(
        RegExp(r'`([^`]+)`'),
        (match) =>
            '<code style="background-color: #f0f0f0; padding: 2px 4px; border-radius: 3px; font-weight: bold;">${match.group(1)}</code>');
    // Đảm bảo thẻ img hiển thị đúng (thêm thuộc tính nếu cần)
    explanation =
        explanation.replaceAllMapped(RegExp(r'<img\s+([^>]*)>'), (match) {
      String imgAttributes = match.group(1) ?? '';
      return '<img $imgAttributes style="display: block">';
    });
    explanation = explanation
        .replaceAll(RegExp(r'^\s*---+\s*$', multiLine: true),
            '') // Loại bỏ dòng chỉ có dấu ---
        .trim();
  }

  return explanation;
}
