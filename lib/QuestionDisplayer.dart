import 'dart:io';

import 'package:flutter_quiz/Question.dart';
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
    _practiceTest ? bluePrintln(' *** PRACTICE ***\n') : stdout.write("");

    bluePrintln(_currQuestion.toString());
  }
  
  bool submitAnswer(String? userInput)
  {
    return _currQuestion.checkUserInput(userInput);
  }
}