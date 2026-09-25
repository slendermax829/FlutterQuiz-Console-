import 'package:flutter_quiz/ConsoleUI.dart';
import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/QuizParser.dart' as QuizParser;
import 'package:flutter_quiz/Quiz.dart';
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

  test("Multiple Choice Question", () {
    MultipleChoice mc = MultipleChoice("Is this a MC?", ["True","False"], 0);

    print(mc.toString());
    
    expect(mc.type.name, "Multiple Choice", reason: 'enum is not MIB');
    expect(mc.checkUserInput('1'),true, reason: 'Answer is \"True\"');
    expect(mc.answer, '1', reason: "Answer is option 1, index = 0");
  });

  test('Fill in the Blank Question', () {
    FillInBlank fb = FillInBlank("This is a ______ question", ["Fill in the Blank"]);

    print(fb.toString());

    expect(fb.type.name, "Fill in the Blank", reason: 'enum is not FIB');
    expect(fb.checkUserInput("fill in the blank"),true, reason: 'The answer is \' Fill in the Blank\'(lowercase counts as well)');
    expect(fb.answer, '(fill in the blank)', reason: 'the getter should return List<String> -> String');
  });

  test('Quiz', () {
    Quiz qz = Quiz(
      'Quiz 01',
      [MultipleChoice("This is a MC?", ['True', 'False'], 0), FillInBlank('This is a _____', ['FIB'])],
    );

    print(qz.name);
    print(qz.quizNum);
    print(qz.numOfQuestions);

    var mc = qz.getQuestion(1);
    var fb = qz.getQuestion(2);
    var unknown = qz.getQuestion(3); // null

    var rand = qz.randQuestions;

    print('${qz.questions}\n');
    print(rand);

    expect(mc?.type.name, 'Multiple Choice', reason: 'Q1. is Multiple Choice');
    expect(fb?.type.name, 'Fill in the Blank', reason: 'Q2. is Fill in the blank');
    expect(unknown?.type.name, null, reason: 'Question does not exist');
  });
}
