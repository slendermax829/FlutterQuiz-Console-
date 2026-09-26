import 'package:flutter_quiz/ConsoleUI.dart';
import 'package:flutter_quiz/Question.dart';
import 'package:flutter_quiz/QuestionPool.dart';
import 'package:flutter_quiz/QuizParser.dart' as QuizParser;
import 'package:flutter_quiz/Quiz.dart';
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

  test('QuizFetch', () async { 
    // Question 4 contains characters that can cause the parser to skip

    Quiz? quiz = await QuizParser.testFetch(1);
    Quiz? quiz4 = await QuizParser.testFetch(4); // Quiz 4 has escape sequences
    Quiz? quiz2 = await QuizParser.testFetch(100); // 100 does not exist

    print(quiz?.name);
    print(quiz?.quizNum);
    print(quiz4?.name ?? 'Quiz 4 not found');
    print(quiz4?.quizNum ?? 'Quiz 4 not found');

    print(quiz2?.name ?? 'Not found');
    print(quiz2?.quizNum ?? 'Not found');

    expect(quiz?.numOfQuestions, 10, reason: "Question 1 contains 10 questions in total");
    expect(quiz4?.quizNum, 4, reason: 'Quiz 4 should be fetched successfully');
    expect(quiz2?.numOfQuestions, null, reason: "Quiz 100 does not exist therfore it should be null");
  });

  test('QuizPool', () async {
    final pool = QuestionPool();
    await pool.populatePool();

    var num = pool.numberOfQuizzes;
    var quizKeys = pool.quizNumbers;

    var questions = pool.getQuestionsFromQuiz(1);

    print(num);
    print(quizKeys);

    expect(quizKeys.contains(4), true, reason: 'Quiz 4 should be present in the pool');
    expect(quizKeys.length, 8, reason: 'There are exactly 8 quizzes so far');
    expect(questions?[0].type.name, 'Multiple Choice', reason: 'Quiz 1 Question 1 is MC type' );
  });
}
