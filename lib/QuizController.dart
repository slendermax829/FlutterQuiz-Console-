import 'dart:io';

import 'package:flutter_quiz/ConsoleUI.dart';
import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/QuestionDisplayer.dart';
import 'package:flutter_quiz/QuizPool.dart';
import 'package:flutter_quiz/QuizParser.dart' as QuizParser;
import 'package:flutter_quiz/QuizUI.dart';

/// The main Controller for the program.
///
/// Handles quiz session as well as for displaying ui prompts.
class QuizController with QuizUI {
  /// Flag to signal if the quiz is a practice quiz or not.
  static bool isPractice = false;

  /// Console UI used for menus and results.
  late final ConsoleUI ui;

  /// Custom collection of loaded quizzes.
  late final QuizPool pool;

  /// Presenter used to show questions and validate submitted answers.
  late final QuestionDisplayer qDisplay;

  /// Creates a quiz controller.
  QuizController();

  /// initial setup for the program
  void start() async {
    this.ui = ConsoleUI();
    this.pool = QuizPool();
    this.qDisplay = QuestionDisplayer();

    await _validateConnection();

    await _fetchQuizzes();

    _initializeMenu();
  }

  /// Validates if the connection to retrieve quiz information is valid.
  ///
  /// Terminates the program if status code is not 200.
  Future<void> _validateConnection() async {
    clearScreen();
    yellowPrintln('TESTING CONNECTION...\n');

    bool isConnected = await QuizParser.validateURL();

    if (!isConnected) {
      redPrintln('\nCONNECTION UNSUCCESSFUL');
      throw HttpException('Connection to api not found.');
    }
    greenPrintln('\nCONNECTION SUCCESSFUL!');
    await Future.delayed(Duration(seconds: 3));
  }

  /// Fetches quizzes and feeds them into the pool.
  Future<void> _fetchQuizzes() async {
    clearScreen();
    yellowPrintln('FETCHING QUIZZES...');

    await pool.populatePool();

    greenPrintln('\nLOADED ${pool.numberOfQuizzes} QUIZZES');
    greenPrintln('ACCQUIRED ${pool.numberOfQuestions} QUESTIONS');

    await Future.delayed(Duration(seconds: 3));
  }

  /// Initial UI Menu.
  ///
  /// Retrieves [input] from user input to make selection.
  void _initializeMenu() {
    while (true) {
      var input = ui.promptMenu();

      switch (input) {
        case 1:
          _selectQuiz();
          return;
        case 2:
          _selectRandomQuiz();
        case 3:
          continue;
        case 4:
          _quit();
        default:
          continue;
      }
    }
  }

  /// Selects a quiz from the pool to be tested on.
  void _selectQuiz() {
    var input = ui.promptSelectQuiz(pool.quizzes);
    var quiz = pool.quizzes.firstWhere((q) => q.quizNum == input);

    qDisplay.questions = List.from(quiz.questions)
      ..shuffle(); // random order of questions
    _quizLoop();
    //greenPrintln('Selected ${quiz.name}');
  }

  /// Selects a range of random questions from all available quizzes to be tested on.
  void _selectRandomQuiz() {
    var input = ui.promptRandomQuiz(pool.numberOfQuestions);
    var questions = pool.getRandomQuestions(range: input);

    qDisplay.questions = questions;

    _quizLoop();
  }

  /// The Main quiz loop for the user to be tested on.
  ///
  /// Questions are displayed from [QuestionDisplayer] and handles logic
  /// to determine if question is correct or not.
  ///
  /// If [isPractice] is true then the quiz will be counted as a practice test.
  void _quizLoop() {
    var BACK = '/b';
    var NEXT = '/n';

    var isRunning = true;
    var score = 0;
    //var questionNum = 1;
    var questionIndex = 0;
    var numOfQuestions = qDisplay.questions.length;

    // List<(String,Question)> correctQuestions = [];
    // List<(String,Question)> incorrectQuestions = [];

    List<(bool, String, Question)> questionRecord = []; // list of records to be displayed for results (isCorrect,userInput,currQuestion)
    List<bool> answered = List<bool>.filled(
      numOfQuestions,
      false,
      growable: false,
    ); // list to keep track which questions are answered/unanswered

    while (isRunning) {
      var questionNum = questionIndex + 1;

      isPractice == true
          ? qDisplay.displayPracticeQuestion(questionNum)
          : qDisplay.displayQuestion(questionNum);

      var input;

      switch (qDisplay.currQuestion.type.number) {
        case 1:
          input = _promptForMC();

        case 2:
          input = _promptForFIB();
      }

      if (input == BACK) {
        var prevIndex = _findUnansweredQuestion(answered, questionIndex, -1);

        if (prevIndex != null) {
          questionIndex = prevIndex; // go back one question
          continue;
        }

        continue; //loopback
      } else if (input == NEXT) {
        var nextIndex = _findUnansweredQuestion(answered, questionIndex, 1);

        if (nextIndex != null) {
          questionIndex = nextIndex;
          continue; // go forward one question
        }

        continue; //loopback
      }

      if (input == null) {
        continue; // loopback
      }

      bool isCorrect = qDisplay.submitAnswer(input);
      answered[questionIndex] =
          true; // indicate that this question was answered

      switch (isCorrect) {
        case true:
          score++;
          questionRecord.add((true, input, qDisplay.currQuestion));

        case false:
          questionRecord.add((false, input, qDisplay.currQuestion));
      }

      var nextUnansweredQuestion = _findUnansweredQuestion(
        answered,
        questionIndex,
        1,
      );

      if (nextUnansweredQuestion == null && !answered.contains(false)) {
        isRunning = false; // All questions were answered heading to results
      } else {
        //questionIndex++;
        questionIndex =
            nextUnansweredQuestion ?? answered.indexWhere((a) => a == false);
      }
    }

    _results(score, questionRecord);
  }

  /// Calculate final score while displaying the results from test session.
  ///
  /// Asks user if want to continue or not.
  void _results(int score, List<(bool, String, Question)> qR) {
    var finalScore = ((score / qDisplay.questions.length) * 100).round();
    var input = ui.displayResults(finalScore, qR);

    switch (input) {
      case 1:
        _initializeMenu();
        return;
      case 2:
        _quit();
        return;
    }
  }

  /// User input for multiple choice questions.
  ///
  /// Can only select numbers unlike fill in the blank.
  String? _promptForMC() {
    //var input = stdin.readLineSync()?.trim().toLowerCase();
    var input = userInput();
    var optionLength = qDisplay.currQuestion.options.length;

    if (input == null) {
      return null;
    }

    if (input == '/b' || input == '/n') {
      return input;
    }

    var checkInput = int.tryParse(input);

    if (checkInput != null && checkInput >= 1 && checkInput <= optionLength) {
      return input;
    } else {
      return null;
    }
  }

  /// User input for fill in the blank questions.
  String? _promptForFIB() {
    //var input = stdin.readLineSync()?.trim().toLowerCase();
    var input = userInput();

    if (input == null || input == '') {
      return null;
    }

    if (input == '/b' || input == '/n') {
      return input;
    }

    return input;
  }

  /// Finds the next/prev unanswered question.
  ///
  /// [step] is either -1 for prev question or 1 for next question.
  int? _findUnansweredQuestion(
    List<bool> answered,
    int currentIndex,
    int step,
  ) {
    var canidate = currentIndex + step;

    while (canidate >= 0 && canidate < answered.length) {
      if (answered[canidate] == false) {
        return canidate;
      }

      canidate += step;
    }
    return null;
  }

  /// Terminates the program safely.
  void _quit() {
    ui.quitDisplay();
    exit(0); // ensure program terminates correctly
  }
}
