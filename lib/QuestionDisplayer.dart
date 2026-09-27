import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/QuizUI.dart';

class QuestionDisplayer with QuizUI
{
  late List<Question>_questions;

  Question? _currQuestion;

  bool _practiceTest = false;

  List<Question> get questions => _questions;

  set questions(List<Question>? newList)
  {
    _questions = newList == null ? <Question>[] : List<Question>.from(newList);
  }

  bool get practice => _practiceTest;
  set practice(bool toggle) => _practiceTest = toggle;

  QuestionDisplayer();

  void displayQuestion()
  {
    if(_currQuestion == null)
    {
      return;
    }

    if(_practiceTest)
    {
      bluePrintln('*** PRACTICE ***\n');
    }

    if(_currQuestion!.type.number == 1)
    {
      bluePrintln("Multiple Choice, Type in a corresponding number");
    }else{
      bluePrintln("Fill in the Blank");
    }

    bluePrintln(_currQuestion.toString());
  }

  void nextQuestion()
  {
    try{
      _currQuestion = _questions.removeAt(0);
    }catch(e){
      return;
    }
  }
}