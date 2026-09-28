import 'dart:async';
import 'dart:io';

import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/QuestionDisplayer.dart';
import 'package:flutter_quiz/Quiz.dart';
import 'package:flutter_quiz/QuizController.dart';
import 'package:flutter_quiz/QuizPool.dart';
import 'package:flutter_quiz/QuizUI.dart';
import 'package:flutter_quiz/QuizParser.dart' as QuizParser;

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

  // void _selectQuiz() async
  // {
  //   //pool = QuestionPool()..populatePool();

  //   while(true)
  //   {
  //     clearScreen();

  //     bluePrintln('Please Select a Quiz to Take');
  //     bluePrintln('Select a Quiz by typing its corresponding number\n');

  //     for(int num in pool.quizNumbers)
  //     {
  //       bluePrintln('* Quiz [$num]');
  //     }

  //     var input = stdin.readLineSync();

  //     if(input == null)
  //     {
  //       continue; // loopback
  //     }

  //     if(input == 'back')
  //     {
  //       return;
  //     }
      
  //     var parsedInput = int.tryParse(input);

  //     if(parsedInput != null && pool.quizNumbers.contains(parsedInput))
  //     {
  //       displayer.questions = pool.getQuestionsFromQuiz(parsedInput);
  //       _quizLoop();
  //       return;
  //     }
  //   }
  // }

  // void _quizLoop()
  // {
  //   var score = 0;
  //   var questionNum = 1;
  //   var numOfQuestions = displayer.questions.length;

  //   List<Question> correctQuestions = [];
  //   List<Question> incorrectQuestions = [];

  //   while(questionNum <= numOfQuestions)
  //   {
  //     displayer.displayQuestion(questionNum);

  //     var input = stdin.readLineSync();

  //     if(input == null)
  //     {
  //       continue;
  //     }

  //     if(displayer.currQuestion.type.number == 1 && int.tryParse(input) == null)
  //     {
  //       continue;
  //     }

  //     bool isCorrect = displayer.submitAnswer(input);

  //     switch(isCorrect)
  //     {
  //       case true:
  //         correctQuestions.add(displayer.currQuestion);
  //       case false:
  //         incorrectQuestions.add(displayer.currQuestion);
  //     }

  //     score = isCorrect ? score + 1 : score;
  //     questionNum++;
  //   }

  //   var finalScore = ((score/numOfQuestions)*100).round();

  //   _displayResults(finalScore, correctQuestions, incorrectQuestions);
  // }

  // void _displayResults(int finalScore, List<Question> correct, List<Question> incorrect)
  // {
  //     while(true){
  //       clearScreen();
  //       bluePrintln('RESULTS\n');
  //       bluePrintln('Number of Questions: ${correct.length + incorrect.length}');
  //       bluePrint('Correct: '); greenPrintln('${correct.length}');
  //       bluePrint('Incorrect: '); redPrintln('${incorrect.length}');
  //       finalScore >= 70 ? greenPrintln('FINAL SCORE: $finalScore\n') : redPrintln('FINAL SCORE: $finalScore\n');

  //       bluePrintln('Please make a selection by typing in a number');
  //       bluePrintln('1. Retake new quiz');
  //       bluePrintln('2. Quit\n');

  //       var input = stdin.readLineSync();

  //       if(input == null)
  //       {
  //         continue;
  //       }

  //       var parsedInput = int.tryParse(input);

  //       if(parsedInput == 1){
  //         _displayMenu();
  //         break;
  //       }else if(parsedInput == 2){
  //         _quit();
  //         break;
  //       }
  //   }
  // }

  // void _selectRandomQuiz()
  // {
  //   clearScreen();
  //   yellowPrint('Work in Progress be a Patient Pickle LOL');
  //   sleep(Duration(seconds: 3));
  // }

  // void _quit()
  // {
  //   clearScreen();
  //   bluePrint('Have a Nice Day ;^)');
  //   sleep(Duration(seconds: 3));
  //   clearScreen();
  //   exit(0); // ensure program terminates correctly
  // }

}