import 'dart:io';

import 'package:flutter_quiz/UI.dart';

class ConsoleUI extends UI
{
  ConsoleUI(): super();
  
  void displayMenu()
  {
    while(true)
    {
      clearScreen();
      bluePrint('Welcome to FlutterQuiz');
      bluePrint('Make a selection by typing a number.');

      bluePrint('\n1. Take a Quiz');
      bluePrint('2. Quit\n');

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
          break;

        case 2:
          quit();
          return;
      }
    }
  }

  void _selectQuiz()
  {
    clearScreen();
    greenPrint('Work in progress be a patient pickle.');
    sleep(Duration(seconds: 2));
  }
}