import 'dart:io';

import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/QuizController.dart';
import 'package:flutter_quiz/QuizUI.dart';

/// A Question Display class that can display the question toward the user
class QuestionDisplayer with QuizUI {
  late List<Question> _questions;
  late Question _currQuestion;

  bool _practiceTest = false;

  /// Questions queued for the current quiz session.
  List<Question> get questions => _questions;

  /// Replaces the current question list.
  set questions(List<Question>? newList) {
    _questions = newList == null ? <Question>[] : List<Question>.from(newList);
  }

  /// Currently displayed question.
  Question get currQuestion => _currQuestion;

  /// Answer for the current question.
  String? get currentAnswer => _currQuestion.answer;

  /// Constructor for QuestionDisplayer.
  QuestionDisplayer();

  /// Displays a question in standard quiz mode.
  /// 
  /// Displays the question from [_questions] based on [questionNum]
  void displayQuestion(int questionNum) {
    _currQuestion = _questions[questionNum - 1];

    clearScreen();
    stdout.write('[$questionNum] ');
    bluePrintln(_currQuestion.toString());
    bluePrintln('Type /b to go back to prev question or /n to next question.');
  }

  /// Displays a question in practice mode.
  void displayPracticeQuestion(int questionNum) {
    _currQuestion = _questions[questionNum - 1];

    clearScreen();

    yellowPrintln('*** PRACTICE ***\n');
    stdout.write('[$questionNum] ');
    bluePrintln(_currQuestion.toString());
    bluePrintln('Type /b to go back to prev question or /n to next question.');
  }
  
  /// Displays the answer if current quiz is in practice mode.
  /// 
  /// Displays the [userInput] and informs if the answer was [isCorrect].
  void _displayAnswer(String? userInput, bool isCorrect) {
    var isRunning = true;

    while (isRunning) {
      clearScreen();
      isCorrect == true
          ? greenPrintln('CORRECT!\n')
          : redPrintln('INCORRECT!\n');

      isCorrect == true
          ? greenPrintln(_currQuestion.toString())
          : redPrintln(_currQuestion.toString());

      if (isCorrect) {
        greenPrintln('CORRECT ANSWER: ${_currQuestion.answer}');
      } else {
        greenPrintln('CORRECT ANSWER: ${_currQuestion.answer}');
        redPrintln('YOUR ANSWER: $userInput');
      }

      bluePrintln('\nHit \'Enter\' to Continue.');

      var input = stdin.readLineSync();

      if (input == null || input != '') {
        continue;
      }

      isRunning = false;
    }
  }

  /// Submits an answer for the current question and returns whether it was correct.
  bool submitAnswer(String? userInput) {
    var correct = _currQuestion.checkUserInput(userInput);

    if (QuizController.isPractice) {
      _displayAnswer(userInput, correct);
    }

    return correct;
  }
}
