import 'dart:async';

import 'package:flutter_quiz/Quiz.dart';
import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/QuizParser.dart' as QuizParser;
import 'dart:math' as math;

class QuestionPool 
{
  List<Quiz> _quizzes = [];

  List<Quiz> get quizzes => _quizzes;
  List<int> get quizNumbers => _quizzes.map((q)=> q.quizNum).toList();

  int get numberOfQuizzes => _quizzes.length;
  int get numberOfQuestions => _quizzes.fold<int>(0,(sum,quiz) => quiz.numOfQuestions + sum);

  QuestionPool();

  Future<void> populatePool() async
  {
    try{

      if(!_quizzes.isEmpty)
      {
        print('Quiz Cache Cleared');
        _quizzes.clear();
      }
      print('Getting Quizzes');
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

    while(true)
    {
      var quizNum = quizNumbers[rand.nextInt(numberOfQuizzes)-1];
      var selectedQuiz = _quizzes.firstWhere((q) => q.quizNum == quizNum);

      var questionNum = rand.nextInt(selectedQuiz.numOfQuestions);
      var selectedQuestion = selectedQuiz.questions[questionNum-1];

      if(!routlette.contains((quizNum,questionNum)))
      {
        routlette.add((quizNum,questionNum));
        randQuestions.add(selectedQuestion);
      }

      if(randQuestions.length == range)
      {
        break;
      }

    }
    return randQuestions;
  }

}