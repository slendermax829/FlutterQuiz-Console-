import 'dart:async';
import 'dart:io';

import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/QuestionDisplayer.dart';
import 'package:flutter_quiz/QuestionPool.dart';
import 'package:flutter_quiz/QuizUI.dart';
import 'package:flutter_quiz/QuizParser.dart' as QuizParser;

class ConsoleUI with QuizUI
{
  final QuestionPool pool = QuestionPool();
  final QuestionDisplayer displayer = QuestionDisplayer();

  ConsoleUI();

  Future<void> init() async
  {
    try
    {
      yellowPrintln('TESTING CONNECTION...');

      var response = await Future.delayed(Duration(seconds: 2), () => QuizParser.validateURL());

      if (!(response))
      {
        clearScreen();
        redPrint('CONNECTION FAILED');
        exit(1);
      }

      await _initPool();

      _displayMenu();

    }catch(e){
      throw 'An error had occurred: $e';
    }
  }

  Future<void> _initPool() async
  {
    clearScreen();
    yellowPrintln('FETCHING QUIZZES\n');
    await pool.populatePool();
  }

  void _displayMenu()
  {
      while(true)
      {
        clearScreen();
        customPrintln(s: 'Welcome to Flutter-Quiz',r: 79,g: 18,b: 209);
        bluePrintln('Make a selection by typing a number.\n');

        bluePrintln('1. Take a Quiz');
        bluePrintln('2. Take a Random Quiz');
        displayer.practice ? bluePrintln('3. Disable Practice') : bluePrintln('3. Enable Practice');
        bluePrintln('4. Quit');

        displayer.practice ? greenPrintln('\nPRACTICE ENABLED') : stdout.writeln('\n'"");

        String? input = stdin.readLineSync();

        if(input == null)
        {
          continue; // loopback
        }

        int parsedInput = int.tryParse(input) ?? 0;

        if(parsedInput == 1){
          _selectQuiz();
          break;

        }else if(parsedInput == 2){
          _selectRandomQuiz();
        }else if(parsedInput ==3){
          displayer.practice = !displayer.practice;

        }else if(parsedInput == 4){
          _quit();
          break;
        }
      }
  }

  void _selectQuiz() async
  {
    //pool = QuestionPool()..populatePool();

    while(true)
    {
      clearScreen();

      bluePrintln('Please Select a Quiz to Take');
      bluePrintln('Select a Quiz by typing its corresponding number\n');

      for(int num in pool.quizNumbers)
      {
        bluePrintln('* Quiz [$num]');
      }

      var input = stdin.readLineSync();

      if(input == null)
      {
        continue; // loopback
      }

      if(input == 'back')
      {
        return;
      }
      
      var parsedInput = int.tryParse(input);

      if(parsedInput != null && pool.quizNumbers.contains(parsedInput))
      {
        displayer.questions = pool.getQuestionsFromQuiz(parsedInput);
        _quizLoop();
        return;
      }
    }
  }

  void _quizLoop()
  {
    var score = 0;
    var questionNum = 1;
    var numOfQuestions = displayer.questions.length;

    List<Question> correctQuestions = [];
    List<Question> incorrectQuestions = [];

    while(questionNum <= numOfQuestions)
    {
      displayer.displayQuestion(questionNum);

      var input = stdin.readLineSync();

      if(input == null)
      {
        continue;
      }

      if(displayer.currQuestion.type.number == 1 && int.tryParse(input) == null)
      {
        continue;
      }

      bool isCorrect = displayer.submitAnswer(input);

      switch(isCorrect)
      {
        case true:
          correctQuestions.add(displayer.currQuestion);
        case false:
          incorrectQuestions.add(displayer.currQuestion);
      }

      score = isCorrect ? score + 1 : score;
      questionNum++;
    }

    var finalScore = ((score/numOfQuestions)*100).round();

    _displayResults(finalScore, correctQuestions, incorrectQuestions);
  }

  void _displayResults(int finalScore, List<Question> correct, List<Question> incorrect)
  {
      while(true){
        clearScreen();
        bluePrintln('RESULTS\n');
        bluePrintln('Number of Questions: ${correct.length + incorrect.length}');
        bluePrint('Correct: '); greenPrintln('${correct.length}');
        bluePrint('Incorrect: '); redPrintln('${incorrect.length}');
        finalScore >= 70 ? greenPrintln('FINAL SCORE: $finalScore\n') : redPrintln('FINAL SCORE: $finalScore\n');

        bluePrintln('Please make a selection by typing in a number');
        bluePrintln('1. Retake new quiz');
        bluePrintln('2. Quit\n');

        var input = stdin.readLineSync();

        if(input == null)
        {
          continue;
        }

        var parsedInput = int.tryParse(input);

        if(parsedInput == 1){
          _displayMenu();
          break;
        }else if(parsedInput == 2){
          _quit();
          break;
        }
    }
  }

  void _selectRandomQuiz()
  {
    clearScreen();
    yellowPrint('Work in Progress be a Patient Pickle LOL');
    sleep(Duration(seconds: 3));
  }

  void _quit()
  {
    clearScreen();
    bluePrint('Have a Nice Day ;^)');
    sleep(Duration(seconds: 3));
    clearScreen();
    exit(0); // ensure program terminates correctly
  }

}