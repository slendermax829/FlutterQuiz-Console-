import 'package:flutter_quiz/ConsoleUI.dart';
import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/QuizParser.dart' as QuizParser;
import 'package:flutter_quiz/UI.dart';
import 'package:test/test.dart';

void main() {
  test('ValidateURL', () async {
      print(QuizParser.url);
      print(QuizParser.totalQuizzes);

      bool response = await QuizParser.validateURL();

      expect(response,true, reason: 'Connection Failed');
  });

  test("InitUI", () {
    //UI ui = UI();
    ConsoleUI ui = ConsoleUI();
    print('If you see this then the connection is A-OK');
    ui.displayMenu();
  });

  test('Question MC', () {
    Question q = Question("Am I a Multiple Choice?", QuestionType.MC);

    print(q.toString());

    expect(q.type.name, 'Multiple Choice', reason: "This question should be \'Multiple Choice\'");
    expect(q.type.number, 1, reason: 'Multiple Choice == 1');
    expect(q.typeRecord, ('Multiple Choice',1), reason: "(String name, int number)");
  });
}
