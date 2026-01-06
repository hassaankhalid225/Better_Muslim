import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/models.dart';

class QuizService {
  Future<List<QuizQuestion>> getDailyQuestions({int count = 5}) async {
    final String response = await rootBundle.loadString(
      'assets/data/quiz_questions.json',
    );
    final List<dynamic> data = json.decode(response);
    final List<QuizQuestion> questions = data
        .map((json) => QuizQuestion.fromJson(json))
        .toList();

    if (questions.isEmpty) {
      throw Exception('No Quiz Questions found');
    }

    // Get current day of year
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final daysSinceStart = now.difference(startOfYear).inDays;

    // Return 5 questions starting from the day's index
    final startIndex = daysSinceStart % questions.length;
    final List<QuizQuestion> dailyQuestions = [];

    for (int i = 0; i < count && i < questions.length; i++) {
      final index = (startIndex + i) % questions.length;
      dailyQuestions.add(questions[index]);
    }

    return dailyQuestions;
  }

  Future<List<QuizQuestion>> getAllQuestions() async {
    final String response = await rootBundle.loadString(
      'assets/data/quiz_questions.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => QuizQuestion.fromJson(json)).toList();
  }
}
