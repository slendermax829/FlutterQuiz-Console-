import 'package:flutter_quiz/Question.dart';
import 'dart:math' as math;

class Quiz 
{
  final String _quizName;
  final List<Question> _questions;

  String get name => _quizName;

  int get quizNum
  {
    var split = _quizName.split(' ');
    return int.tryParse(split[1]) ?? -1;
  }

  List<Question> get questions => _questions;

  List<Question> get randQuestions => List.from(_questions)..shuffle();

  int get numOfQuestions => _questions.length;

  Quiz(this._quizName, this._questions);

  Question? getQuestion(int questionNum)
  {
    if(questionNum < 1 || questionNum > numOfQuestions)
    {
      return null;
    }

    return _questions[questionNum - 1];
  }

  Record getRandomQuestion()
  {
    var rand = math.Random();

    var chosenQuestion = _questions[rand.nextInt(numOfQuestions)-1];

    return (quizNum, chosenQuestion);
  }
}