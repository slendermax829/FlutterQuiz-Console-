import 'dart:io';

import 'package:flutter_quiz/ConsoleUI.dart';
import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/QuestionDisplayer.dart';
import 'package:flutter_quiz/QuizPool.dart';
import 'package:flutter_quiz/QuizParser.dart' as QuizParser;
import 'package:flutter_quiz/QuizUI.dart';

class QuizController with QuizUI
{
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
    while (true)
    {
      var input = ui.promptMenu();

      switch(input)
      {
        case 1:
          _selectQuiz();
          return;
        case 2:
          print('Selecting rand Quiz');
          return;
        case 3:
          continue;
        case 4:
          _quit();
        default:
          continue;
      }
    }
  }

  void _selectQuiz() async
  {
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

    // List<(String,Question)> correctQuestions = [];
    // List<(String,Question)> incorrectQuestions = [];

    List<(bool,String,Question)> questionRecord = [];

    while(isRunning)
    {
      isPractice == true ? qDisplay.displayPracticeQuestion(questionNum):
      qDisplay.displayQuestion(questionNum);

      var input;

      switch(qDisplay.currQuestion.type.number)
      {
        case 1:
          input = _promptForMC();

        case 2:
          input = _promptForFIB();
      }

      if(input == null)
      {
        continue; // loopback
      }

      bool isCorrect = qDisplay.submitAnswer(input);

      switch(isCorrect)
      {
        case true:
          score++;
          questionRecord.add((true,input,qDisplay.currQuestion));

        case false:
          questionRecord.add((false,input,qDisplay.currQuestion));
      }

      if(questionNum == numOfQuestions)
      {
        isRunning = false;

      }else{
        questionNum++;
      }
    }
    
    _results(score,questionRecord);
  }

  void _results(int score, List<(bool,String,Question)> qR)
  {
    var finalScore = ((score/qDisplay.questions.length)*100).round();
    var input = ui.displayResults(finalScore, qR);

    switch(input)
    {
      case 1:
        _initializeMenu();
        return;
      case 2:
        _quit();
        return;
    }
  }


  String? _promptForMC()
  {

    var input = stdin.readLineSync()?.trim().toLowerCase();
    var optionLength = qDisplay.currQuestion.options.length;
    
    if(input == null)
    {
      return null;
    }

    var checkInput = int.tryParse(input);

    if(checkInput != null && checkInput >= 1 && checkInput <= optionLength)
    {
      return input;
    }else{
      return null;
    }
  }

  String? _promptForFIB()
  {
    var input = stdin.readLineSync()?.trim().toLowerCase();

    return input;

  }

  void _quit()
  {
    ui.quitDisplay();
    exit(0); // ensure program terminates correctly
  }
}