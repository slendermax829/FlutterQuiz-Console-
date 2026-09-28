import 'dart:io';

import 'package:flutter_quiz/ConsoleUI.dart';
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
    await _validateConnection();

    this.ui = ConsoleUI();
    this.pool = QuizPool();
    this.qDisplay = QuestionDisplayer();

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

  void _initializeMenu()
  {
    var isRunning = true;

    while (isRunning)
    {
      var input = ui.promptMenu();

      switch(input)
      {
        case 1:
          print('Selecting Quiz');
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

  void _selectQuiz()
  {
    var isRunning = true;
    var validQuizzes;

    while(isRunning)
    {
      var input = ui.promptMenu();
    }
  }
}