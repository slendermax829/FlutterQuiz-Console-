import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_quiz/Quiz.dart';
import 'package:flutter_quiz/Question.dart';

const String _baseUrl = 'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/';
const int _totalQuizzes = 8;

String get url => _baseUrl;
int get totalQuizzes => _totalQuizzes;

//typedef QuizFetchProgress = void Function(String message);

Future<bool> validateURL() async
{
  var url = Uri.parse(_baseUrl);

  var response = await Future.delayed(Duration(seconds: 3), (){
    return http.get(url);
  });

  return response.statusCode == 200;
}

Future<List<Quiz>> fetchQuizzes({Function(String message)? onProgress}) async
{
  List<Quiz?> lst = [];

  for(int i = 1; i <= _totalQuizzes; i++)
  {
    var validation = await _validateQuiz(i);

    if(!validation)
    {
      continue;
    }

    var quiz = await _fetchQuiz(i);

    if(quiz == null)
    {
      continue;
    }

    onProgress?.call('Fetched ${quiz.name}');
    lst.add(quiz);
  }

  return lst.nonNulls.toList();
}

Future<bool> _validateQuiz(int quizNum) async
{
  try{
    var url = Uri.parse('$_baseUrl?quiz=quiz${quizNum.toString().padLeft(2,'0')}');
    var response = await http.get(url);

    // For some reason some quizzes contain unusual text that utilizes escape sequences that cause them to not return properly
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true)) as Map<String, dynamic>;

    if (jsonData['response'] == false)
    {
      print('Quiz $quizNum not RECEIVED, Reason: ${jsonData['reason']} ');
      return false;
    }
    print('Quiz $quizNum RECEIVED');
    return true;

  }catch(e){
    return false;
  }

}

Future<Quiz?> _fetchQuiz(int quizNum) async
{
  var url = Uri.parse('$_baseUrl?quiz=quiz${quizNum.toString().padLeft(2,'0')}');
  var response = await http.get(url);

  // For some reason some quizzes contain unusual text that utilizes escape sequences that cause them to not return properly
  var jsonData = jsonDecode(utf8.decode(response.bodyBytes, allowMalformed: true)) as Map<String, dynamic>;

  if(jsonData['response'] == false)
  {
    return null;
  }

  var quizData = jsonData['quiz'] as Map<String, dynamic>;

  List<dynamic> questionList = quizData['questions'];

  if(questionList.isEmpty)
  {
    return null;
  }

  List<Question> questions = questionList.map((q){
    return Question.fromJson(q);
  }).toList();

  return Quiz(quizData['name'], questions);
}

Future<Quiz?> testFetch(int quizNumber) async => await _fetchQuiz(quizNumber);
Future<bool> testValidateQuiz(int quizNumber) async => await _validateQuiz(quizNumber);
