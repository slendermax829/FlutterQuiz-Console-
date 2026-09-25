import 'package:flutter_quiz/QuizParser.dart' as QuizParser;
import 'package:ansicolor/ansicolor.dart';
import 'package:dart_console/dart_console.dart';
import 'dart:io';

abstract class UI 
{
  final _console = Console();

  final _redPen = AnsiPen()..red();
  final _greenPen = AnsiPen()..green();
  final _bluePen = AnsiPen()..blue();

  late final void Function() clearScreen; // function to clear screen

  late final void Function(String s) redPrint; // print red text
  late final void Function(String s) bluePrint; // print green text
  late final void Function(String s) greenPrint; // print blue text

  UI()
  {
    _validateUrl(); // always check first

    clearScreen = () {
      try{
      _console.clearScreen();
      _console.resetCursorPosition();
      }catch(e){
        return;
      }
    };

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

  void quit()
  {
    this.clearScreen();
    this.bluePrint('Bye have a Nice Day! :^)');
    sleep(Duration(seconds: 3));
    this.clearScreen();
  }
}