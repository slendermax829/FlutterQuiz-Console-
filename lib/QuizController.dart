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

  void _selectQuiz()
  {
    var input = ui.promptSelectQuiz(pool.quizzes);
    var quiz = pool.quizzes.firstWhere((q)=> q.quizNum == input);

    qDisplay.questions = List.from(quiz.questions)..shuffle(); // random order of questions
    _quizLoop();
    //greenPrintln('Selected ${quiz.name}');
  }

  void _selectRandomQuiz()
  {
    var input = ui.promptRandomQuiz(pool.numberOfQuestions);
    var questions = pool.getRandomQuestions(range: input);
    
    qDisplay.questions = questions;

    _quizLoop();
  }

  void _quizLoop()
  {
    var BACK = '/b';
    var NEXT = '/n';

    var isRunning = true;
    var score = 0;
    //var questionNum = 1;
    var questionIndex = 0;
    var numOfQuestions = qDisplay.questions.length;

    // List<(String,Question)> correctQuestions = [];
    // List<(String,Question)> incorrectQuestions = [];

    List<(bool,String,Question)> questionRecord = [];
    List<bool> answered = List<bool>.filled(numOfQuestions, false, growable: false);

    while(isRunning)
    {
      var questionNum = questionIndex + 1;

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

      if(input == BACK)
      {
        var prevIndex = _findUnansweredQuestion(answered, questionIndex, -1);

        if(prevIndex != null)
        {
          questionIndex = prevIndex;
          continue;
        }

        continue;

      }else if(input == NEXT)
      {
        var nextIndex = _findUnansweredQuestion(answered, questionIndex, 1);

        if(nextIndex != null)
        {
          questionIndex = nextIndex;
          continue;
        }

        continue;
      }

      if(input == null)
      {
        continue; // loopback
      }

      bool isCorrect = qDisplay.submitAnswer(input);
      answered[questionIndex] = true;

      switch(isCorrect)
      {
        case true:
          score++;
          questionRecord.add((true,input,qDisplay.currQuestion));

        case false:
          questionRecord.add((false,input,qDisplay.currQuestion));
      }

      var nextUnansweredQuestion = _findUnansweredQuestion(answered, questionIndex, 1);

      if(nextUnansweredQuestion == null && !answered.contains(false))
      {
        isRunning = false;

      }else{
        //questionIndex++;
        questionIndex = nextUnansweredQuestion ?? answered.indexWhere((a)=> a == false);
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

    if(input == '/b' || input == '/n')
    {
      return input;
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

    if(input == null || input == '')
    {
      return null;
    }

    if(input == '/b' || input == '/n')
    {
      return input;
    }

    return input;

  }

  int? _findUnansweredQuestion(List<bool> answered, int currentIndex, int step)
  {
    var canidate = currentIndex + step;

    while(canidate >= 0 && canidate < answered.length)
    {
      if(answered[canidate] == false)
      {
        return canidate;
      }

      canidate += step;
    }
    return null;
  }

  void _quit()
  {
    ui.quitDisplay();
    exit(0); // ensure program terminates correctly
  }
}