import 'dart:async';

import 'package:flutter_quiz/Quiz.dart';
import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/QuizParser.dart' as QuizParser;

import 'dart:math' as math;

/// Stores quizzes loaded from the http source.
class QuizPool {
  List<Quiz> _quizzes = [];

  /// Loaded quizzes.
  List<Quiz> get quizzes => _quizzes;

  /// Numeric identifiers for all loaded quizzes.
  List<int> get quizNumbers => _quizzes.map((q) => q.quizNum).toList();

  /// Total number of loaded quizzes.
  int get numberOfQuizzes => _quizzes.length;

  /// Total number of questions across all loaded quizzes.
  int get numberOfQuestions =>
      _quizzes.fold<int>(0, (sum, quiz) => quiz.numOfQuestions + sum);

  /// Constructor for pool
  QuizPool();

  /// Loads quizzes from the parser once and stores them.
  Future<void> populatePool() async {
    try {
      if (!_quizzes.isEmpty) {
        return;
      }

      _quizzes = await QuizParser.fetchQuizzes();
    } catch (e) {
      throw 'Error attempting to fetch quizzes: $e';
    }
  }

  /// Returns all questions for the quiz number, or `null` if not found.
  List<Question>? getQuestionsFromQuiz(int quizNum) {
    if (!quizNumbers.contains(quizNum)) {
      return null;
    }

    var selectedQuiz = _quizzes.firstWhere((q) => q.quizNum == quizNum);

    return selectedQuiz.questions;
  }

  /// Returns up to [range] random questions without duplicates.
  List<Question> getRandomQuestions({int range = 10}) {
    var rand = math.Random();
    var routlette = Set<Record>(); // A set of records that are used to ensure no duplicates of the same question is drawn (quizNum,questionNum)

    List<Question> randQuestions = []; // questions to be returned

    if (_quizzes.isEmpty || range <= 0) {
      return randQuestions;
    }

    var targetCount = math.min(
      range,
      numberOfQuestions,
    ); // to avoid length exception

    while (true) {
      var quizNum = quizNumbers[rand.nextInt(numberOfQuizzes)]; // gets a random quiz index
      var selectedQuiz = _quizzes.firstWhere((q) => q.quizNum == quizNum);

      var questionNum = rand.nextInt(selectedQuiz.numOfQuestions); // gets a random question index from 'selectedQuiz'
      var selectedQuestion = selectedQuiz.questions[questionNum];

      if (!routlette.contains((quizNum, questionNum))) {
        routlette.add((quizNum, questionNum));
        randQuestions.add(selectedQuestion);
      }

      if (randQuestions.length == targetCount) {
        break;
      }
    }
    return randQuestions;
  }
}
