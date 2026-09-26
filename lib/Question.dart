enum QuestionType
{
  MC('Multiple Choice', 1), // Multiple Choice
  FIB('Fill in the Blank',2); // Fill in Blank

  final String _name;
  final int _number;

  String get name => this._name;
  int get number => this._number;

  const QuestionType(this._name, this._number);

  String toString()
  {
    return '$_name, $_number';
  }
}

abstract class Question 
{
  final String _prompt;
  final QuestionType _type;

  String get prompt => _prompt;
  QuestionType get type => _type;

  Record get typeRecord => (type.name,type.number);

  String get answer; // abstract

  Question(this._prompt, this._type);

  factory Question.fromJson(Map<String,dynamic> jsonData)
  {
    String prompt = jsonData['stem'];

    switch(jsonData['type'])
    {
      case 1:
        List<String> options = List<String>.from(jsonData['options'] as List<dynamic>);
        int answer = jsonData['answer'];

        return MultipleChoice(prompt, options, answer);

      case 2:
        List<String> answer = List<String>.from(jsonData['answer'] as List<dynamic>);

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

  
  bool checkUserInput(String? userInput);
}

class FillInBlank extends Question
{
  final List<String> _answers;

  String get answer => _answers.map((a)=> a.toLowerCase()).toString();

  FillInBlank(String prompt, this._answers)
  :super(prompt, QuestionType.FIB);

  @override
  String toString() {
    return '''Fill in the Blank!\n
$_prompt\n 
    ''';
  }

  bool checkUserInput(String? userInput)
  {
    if(userInput == null)
    {
      return false;
    }

    var toBeChecked = _answers.map((a)=> a.toLowerCase()).toList();

    return toBeChecked.contains(userInput);
  }
}

class MultipleChoice extends Question
{
  final List<String> _options;
  final int _answerIndex;

  String get answer => (_answerIndex + 1).toString();

  MultipleChoice(String prompt, this._options, this._answerIndex)
  :super(prompt,QuestionType.MC);

  @override
  String toString() {
    var questionChoices = _options.asMap().entries.map((o)=> '${o.key + 1}. ${o.value}').join('\n');
    return '''Multiple Choice\n
$_prompt\n
$questionChoices\n
    ''';
  }

  bool checkUserInput(String? userInput)
  {
    if(userInput == null)
    {
      return false;
    }

    var parsedInt = int.tryParse(userInput);

    return (parsedInt !- 1) == _answerIndex;
  }
}