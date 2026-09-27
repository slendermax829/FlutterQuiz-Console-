import 'dart:async';
import 'dart:io';

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

      int? parsedInput = input != null ? int.tryParse(input) : null;

      if(input == null)
      {
        continue; // loopback
      }

      switch(parsedInput)
      {
        case 1:
          _selectQuiz();

        case 2:
          _selectRandomQuiz();
          
        case 3:
          displayer.practice = !displayer.practice;
          
        case 4:
          _quit();
          return;
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

    while(true)
    {
      displayer.nextQuestion();
      displayer.displayQuestion();
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
  }
}