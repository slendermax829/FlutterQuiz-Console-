import 'dart:io';

import 'package:flutter_quiz/ConsoleUI.dart';
import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/QuestionDisplayer.dart';
import 'package:flutter_quiz/QuizPool.dart';
import 'package:flutter_quiz/QuizParser.dart' as QuizParser;
import 'package:flutter_quiz/QuizUI.dart';

class QuizController with QuizUI
{
  static const String _BACK = '/b';
  static const String _QUIT = '/q';

  static bool isPractice = false;

  late final ConsoleUI ui;
  late final QuizPool pool;
  late final QuestionDisplayer qDisplay;

  QuizController();

  void start() async
  {
    this.ui = ConsoleUI();
    this.pool = QuizPool();
    this.qDisplay = QuestionDisplayer();

    await _validateConnection();

    await _fetchQuizzes();

    _initializeMenu();
  }

  Future<void> _validateConnection() async
  {
    clearScreen();
    yellowPrintln('TESTING CONNECTION...\n');
    //sleep(Duration(seconds: 3));

    bool isConnected = await QuizParser.validateURL();

    if(!isConnected)
    {
      redPrintln('\nCONNECTION UNSUCCESSFUL');
      throw HttpException('Connection to api not found.');
    }
    greenPrintln('\nCONNECTION SUCCESSFUL!');
    await Future.delayed(Duration(seconds: 3));
  }

  Future<void> _fetchQuizzes() async
  {
    clearScreen();
    yellowPrintln('FETCHING QUIZZES...');

    await pool.populatePool();

    greenPrintln('\nLOADED ${pool.numberOfQuizzes} QUIZZES');
    greenPrintln('ACCQUIRED ${pool.numberOfQuestions} QUESTIONS');

    await Future.delayed(Duration(seconds: 3));
  }

  void _initializeMenu()
  {
    var isRunning = true;

    while (isRunning)
    {
      var input = ui.promptMenu();

      switch(input)
      {
        case 1:
          //print('Selecting Quiz');
          _selectQuiz();
          isRunning = false;

        case 2:
          print('Selecting rand Quiz');
          isRunning = false;

        case 3:
          continue;

        case 4:
          clearScreen();
          print('Bye Bye');
          isRunning = false;

        default:
          continue;
      }
    }
  }

  void _selectQuiz() async
  {
    var isRunning = true;
    var input = ui.promptSelectQuiz(pool.quizzes);
    var quiz = pool.quizzes.firstWhere((q)=> q.quizNum == input);

    qDisplay.questions = List.from(quiz.questions)..shuffle(); // random order of questions
    _quizLoop();
    //greenPrintln('Selected ${quiz.name}');
  }

  void _quizLoop()
  {
    var isRunning = true;
    var score = 0;
    var questionNum = 1;
    var numOfQuestions = qDisplay.questions.length;

    List<(String,Question)> correctQuestions = [];
    List<(String,Question)> incorrectQuestions = [];

    while(isRunning)
    {
      isPractice == true ? qDisplay.displayPracticeQuestion(questionNum):
      qDisplay.displayQuestion(questionNum);

      var input = stdin.readLineSync();

      if(input == null)
      {
        continue;
      }

      bool isCorrect = qDisplay.submitAnswer(input);

      switch(isCorrect)
      {
        case true:
          score++;
          correctQuestions.add((input,qDisplay.currQuestion));

        case false:
          incorrectQuestions.add((input,qDisplay.currQuestion));
      }

      if(questionNum == numOfQuestions)
      {
        isRunning = false;
      }else{
        questionNum++;
      }
    }
  }
}