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

class Question 
{
  final String _prompt;
  final QuestionType _type;

  String get prompt => _prompt;
  QuestionType get type => _type;

  Record get typeRecord => (type.name,type.number);

  Question(this._prompt, this._type);

  @override
  String toString() {
    return '''$_prompt\n
    ''';
  }
}