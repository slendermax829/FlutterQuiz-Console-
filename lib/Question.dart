/// Identifies the supported question format in a quiz.
enum QuestionType 
{
  MC('Multiple Choice', 1), // Multiple Choice
  FIB('Fill in the Blank', 2); // Fill in Blank

  final String _name;
  final int _number;

  /// Human-readable label for the question type.
  String get name => this._name;

  /// Numeric code used by the remote quiz API.
  int get number => this._number;

  /// Creates a question type entry.
  const QuestionType(this._name, this._number);

  /// Method Override version of `toString()` for this class and subclasses in particular.
  /// 
  /// Returns a string of question that is to be displayed.
  @override
  String toString() {
    return '$_name, $_number';
  }
}

/// Base model for a quiz question. Cannot be instantiated by itself
abstract class Question 
{
  final String _prompt;
  final QuestionType _type;

  List<String>? _options;

  /// The text shown to the user.
  String get prompt => _prompt;

  /// The kind of question represented by this instance.
  QuestionType get type => _type;

  /// Available answer options.
  ///
  /// Returns an empty list for question types that do not expose options.
  /// 
  /// Primarily for multiple choice questions
  List<String> get options => _options ?? [];

  /// Canonical answer value for this question.
  String get answer; // abstract

  /// Creates a question with a prompt, type, and optional answer choices.
  Question(this._prompt, this._type, [this._options]);

  /// Builds a concrete question instance from the quiz API payload.
  factory Question.fromJson(Map<String, dynamic> jsonData) {
    String prompt = jsonData['stem'];

    switch (jsonData['type']) {
      case 1:
        List<String> options = List<String>.from(
          jsonData['options'] as List<dynamic>,
        );
        int rawAnswer = jsonData['answer'];
        int answer = rawAnswer >= 1 && rawAnswer <= options.length
            ? rawAnswer - 1
            : rawAnswer;

        return MultipleChoice(prompt, options, answer);

      case 2:
        List<String> answer = List<String>.from(
          jsonData['answer'] as List<dynamic>,
        );

        return FillInBlank(prompt, answer);

      default:
        throw "Invalid Question";
    }
  }

  @override
  String toString() {
    return '''$_prompt\n
    ''';
  }

  /// Returns `true` when the provided user input matches the answer.
  /// 
  /// Otherwise `false`.
  bool checkUserInput(String? userInput);
}

/// A Fill in the blank question.
/// 
/// Can be answered by input from user
class FillInBlank extends Question {
  final List<String> _answers;

  /// Lowercased representation of the accepted answers.
  String get answer => _answers.map((a) => a.toLowerCase()).toString();

  /// Creates a fill-in-the-blank question.
  FillInBlank(String prompt, this._answers) : super(prompt, QuestionType.FIB);

  @override
  String toString() {
    return '''Fill in the Blank!\n
$_prompt\n 
    ''';
  }

  bool checkUserInput(String? userInput) {
    if (userInput == null) {
      return false;
    }

    var toBeChecked = _answers.map((a) => a.toLowerCase()).toList();

    return toBeChecked.contains(userInput.trim().toLowerCase());
  }
}

/// A Multiple Choice Question
/// 
/// A question that is answered by selecting one option.
class MultipleChoice extends Question {
  final int _answerIndex;

  /// One-based answer index expected from the user.
  String get answer => (_answerIndex + 1).toString();

  /// Creates a multiple-choice question.
  MultipleChoice(String prompt, List<String> options, this._answerIndex)
    : super(prompt, QuestionType.MC, options);

  @override
  String toString() {
    var questionChoices = _options
        ?.asMap()
        .entries
        .map((o) => '${o.key + 1}. ${o.value}')
        .join('\n');
    return '''Multiple Choice\n
$_prompt\n
$questionChoices\n
    ''';
  }

  bool checkUserInput(String? userInput) {
    if (userInput == null) {
      return false;
    }

    var parsedInt = int.tryParse(userInput.trim().toLowerCase());

    if (parsedInt == null) {
      return false;
    }

    return (parsedInt - 1) == _answerIndex;
  }
}
