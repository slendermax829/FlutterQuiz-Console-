import 'dart:io';

import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/Quiz.dart';
import 'package:flutter_quiz/QuizController.dart';
import 'package:flutter_quiz/QuizUI.dart';
class ConsoleUI with QuizUI
{
  
  ConsoleUI();

  int promptMenu()
  {
      bool setPractice = QuizController.isPractice;
      List<int> selections = [1,2,3,4];

      while(true)
      {
        clearScreen();
        customPrintln(s: 'Welcome to Flutter-Quiz',r: 79,g: 18,b: 209);
        bluePrintln('Make a selection by typing a number.\n');

        bluePrintln('1. Take a Quiz');
        bluePrintln('2. Take a Random Quiz');
        setPractice? bluePrintln('3. Disable Practice') : bluePrintln('3. Enable Practice');
        bluePrintln('4. Quit');

        setPractice ? greenPrintln('\nPRACTICE ENABLED') : stdout.writeln('\n'"");

        String? input = stdin.readLineSync();

        if(input == null)
        {
          continue; // loopback
        }

        int parsedInput = int.tryParse(input) ?? 0;

        if(!selections.contains(parsedInput))
        {
          continue;
        }

        if(parsedInput == 3)
        {
          setPractice = !setPractice;
          QuizController.isPractice = setPractice;
        }

        return parsedInput;
      }
  }

  int promptSelectQuiz(List<Quiz> quizzes)
  {
    while(true)
    {
      clearScreen();
      bluePrintln('Please Select a Quiz to Take\n');

      for(Quiz q in quizzes)
      {
        bluePrintln('[*] ${q.name}');
      }

      bluePrintln('\nSelect a Quiz by typing its corresponding number\n');

      var input = stdin.readLineSync();

      if(input == null)
      {
        continue;
      }

      var parsedInput = int.tryParse(input);
      var quizNumbers = quizzes.map((q)=> q.quizNum).toList();

      if(parsedInput!=null && quizNumbers.contains(parsedInput))
      {
        return parsedInput;
      }
    }
  }

  int displayResults(int finalScore, List<(bool,String,Question)> qR)
  {
    var selections = <int>[1,2];
    var total = qR.length;
    
    var totalCorrect = qR.where((record) => record.$1 == true).length;
    var totalIncorrect = qR.where((record) => record.$1 == false).length;

    while(true){
      clearScreen();
      bluePrintln('RESULTS\n');
      bluePrintln('Number of Questions: $total');
      bluePrint('CORRECT: '); greenPrintln('$totalCorrect');
      bluePrint('INCORRECT: '); redPrintln('$totalIncorrect');
      finalScore >= 70 ? greenPrintln('FINAL SCORE: $finalScore\n') : redPrintln('FINAL SCORE: $finalScore\n');

      if(QuizController.isPractice)
      {
        yellowPrintln('SUMMARY\n');
        for(int i = 0; i < qR.length; i++)
        {
          var isCorrect  = qR[i].$1;
          yellowPrint('${i+1}. ');
          isCorrect == true ? 
            greenPrintln('USER ANSWER: ${qR[i].$2}, ANSWER: ${qR[i].$3.answer}') 
          : redPrintln('USER ANSWER: ${qR[i].$2}, ANSWER: ${qR[i].$3.answer}');
        }
      }

      bluePrintln('\nPlease make a selection by typing in a number');
      bluePrintln('1. Take a new quiz');
      bluePrintln('2. Quit\n');

      var input = stdin.readLineSync();

      if(input == null)
      {
        continue; // loopback
      }

      int parsedInput = int.tryParse(input) ?? 0;

      if(!selections.contains(parsedInput))
      {
        continue;
      }

      return parsedInput;
    }
  }

  void quitDisplay()
  {
    clearScreen();
    bluePrint('Have a Nice Day ;^)');
    sleep(Duration(seconds: 3));
    clearScreen();
  }

}