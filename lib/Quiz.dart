import 'package:flutter_quiz/Question.dart';

import 'dart:math' as math;

/// Represents a named quiz and its questions.
class Quiz {
  final String _quizName;
  final List<Question> _questions;

  /// Display name of the quiz.
  String get name => _quizName;

  /// Numeric quiz identifier parsed from the quiz name.
  int get quizNum {
    var split = _quizName.split(' ');
    return int.tryParse(split[1]) ?? -1; // -1 = no quiz exists
  }

  /// Questions that belong to this quiz.
  List<Question> get questions => _questions;

  /// Copy of the questions list in random order.
  List<Question> get randQuestions => List.from(_questions)..shuffle();

  /// Number of questions in the quiz.
  int get numOfQuestions => _questions.length;

  /// Creates a quiz with a name and its questions.
  Quiz(this._quizName, this._questions);

  /// Returns the question for a one-based question number, or `null`.
  Question? getQuestion(int questionNum) {
    if (questionNum < 1 || questionNum > numOfQuestions) {
      return null;
    }

    return _questions[questionNum - 1];
  }

  /// Returns a random question paired with this quiz number.
  Record getRandomQuestion() {
    var rand = math.Random();

    var chosenQuestion = _questions[rand.nextInt(numOfQuestions) - 1];

    return (quizNum, chosenQuestion);
  }
}
