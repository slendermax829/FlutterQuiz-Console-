import 'dart:io';

import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/QuizController.dart';
import 'package:flutter_quiz/QuizUI.dart';

class QuestionDisplayer with QuizUI
{
  late List<Question>_questions;
  late Question _currQuestion;

  bool _practiceTest = false;

  List<Question> get questions => _questions;
  set questions(List<Question>? newList)
  {
    _questions = newList == null ? <Question>[] : List<Question>.from(newList);
  }

  bool get practice => _practiceTest;
  set practice(bool toggle) => _practiceTest = toggle;

  Question get currQuestion => _currQuestion;

  String? get currentAnswer => _currQuestion.answer;

  QuestionDisplayer();

  void displayQuestion(int questionNum)
  {
    _currQuestion = _questions[questionNum-1];

    clearScreen();
    stdout.write('[$questionNum] ');
    bluePrintln(_currQuestion.toString());
  }

  void displayPracticeQuestion(int questionNum)
  {
    _currQuestion = _questions[questionNum-1];

    clearScreen();

    yellowPrintln('*** PRACTICE ***\n');
    stdout.write('[$questionNum] ');
    bluePrintln(_currQuestion.toString());
  }

  void _displayAnswer(String? userInput, bool isCorrect)
  {
    var isRunning = true;

    while(isRunning)
    {
      clearScreen();
      isCorrect == true ? greenPrintln('CORRECT!\n') : redPrintln('INCORRECT!\n');

      isCorrect == true ? greenPrintln(_currQuestion.toString()) : redPrintln(_currQuestion.toString());

      if(isCorrect)
      {
        greenPrintln('CORRECT ANSWER: ${_currQuestion.answer}');
      }else{
        greenPrintln('CORRECT ANSWER: ${_currQuestion.answer}');
        redPrintln('YOUR ANSWER: $userInput');
      }

      bluePrintln('\nHit \'Enter\' to Continue.');

      var input = stdin.readLineSync();

      if(input == null || input != '')
      {
        continue;
      }

      isRunning = false;
    }

  }
  
  bool submitAnswer(String? userInput)
  {
    var correct = _currQuestion.checkUserInput(userInput);

    if(QuizController.isPractice)
    {
      _displayAnswer(userInput, correct);
    }

    return correct;
  }
}