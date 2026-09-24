import 'package:flutter_quiz/QuizParser.dart' as QuizParser;
import 'package:ansicolor/ansicolor.dart';
import 'dart:io';

class UI 
{
  final _redPen = AnsiPen()..red();
  final _greenPen = AnsiPen()..green();
  final _bluePen = AnsiPen()..blue();

  late final void Function(String s) redPrint;
  late final void Function(String s) bluePrint;
  late final void Function(String s) greenPrint;

  UI()
  {
    _validateUrl();

    redPrint = (s) {try{print(_redPen(s));}catch(e){print(s);}};
    bluePrint = (s) {try{print(_bluePen(s));}catch(e){print(s);}};
    greenPrint = (s) {try{print(_greenPen(s));}catch(e){print(s);}};

  }

  Future<void> _validateUrl() async
  {
    final bool response = await QuizParser.validateURL();
    if(!response)
    {
      throw 'API not Found';
    }
  }
}