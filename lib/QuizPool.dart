import 'dart:async';

import 'package:flutter_quiz/Quiz.dart';
import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/QuizParser.dart' as QuizParser;
import 'dart:math' as math;

class QuizPool 
{
  List<Quiz> _quizzes = [];

  List<Quiz> get quizzes => _quizzes;
  List<int> get quizNumbers => _quizzes.map((q)=> q.quizNum).toList();

  int get numberOfQuizzes => _quizzes.length;
  int get numberOfQuestions => _quizzes.fold<int>(0,(sum,quiz) => quiz.numOfQuestions + sum);

  QuizPool();

  Future<void> populatePool() async
  {
    try{

      if(!_quizzes.isEmpty)
      {
        return;
      }
    
      _quizzes = await QuizParser.fetchQuizzes();

    }catch(e){
      throw 'Error attempting to fetch quizzes: $e';
    }
  }

  List<Question>? getQuestionsFromQuiz(int quizNum)
  {
    if(!quizNumbers.contains(quizNum))
    {
      return null;
    }

    var selectedQuiz = _quizzes.firstWhere((q) => q.quizNum == quizNum);
    
    return selectedQuiz.questions;
  }

  List<Question> getRandomQuestions({int range = 10})
  {
    var rand = math.Random();
    var routlette = Set<Record>();

    List<Question> randQuestions = [];

    if (_quizzes.isEmpty || range <= 0)
    {
      return randQuestions;
    }

    var targetCount = math.min(range, numberOfQuestions); // to avoid length exception

    while(true)
    {
      var quizNum = quizNumbers[rand.nextInt(numberOfQuizzes)];
      var selectedQuiz = _quizzes.firstWhere((q) => q.quizNum == quizNum);

      var questionNum = rand.nextInt(selectedQuiz.numOfQuestions);
      var selectedQuestion = selectedQuiz.questions[questionNum];

      if(!routlette.contains((quizNum,questionNum)))
      {
        routlette.add((quizNum,questionNum));
        randQuestions.add(selectedQuestion);
      }

      if(randQuestions.length == targetCount)
      {
        break;
      }

    }
    return randQuestions;
  }
}