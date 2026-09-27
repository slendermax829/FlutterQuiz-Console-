import 'package:flutter_quiz/ConsoleUI.dart';
import 'package:flutter_quiz/QuizParser.dart' as QuizParser;

void main(List<String> arguments) async
{
  var menu = ConsoleUI();
  await menu.init();
}
