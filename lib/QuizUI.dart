import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:dart_console/dart_console.dart';
import 'package:flutter_quiz/ConsoleUI.dart';

mixin QuizUI
{
  final _console = Console();

  final _redPen = AnsiPen()..red();
  final _greenPen = AnsiPen()..green();
  final _bluePen = AnsiPen()..blue();
  final _yellowPen = AnsiPen()..yellow();

  void clearScreen()
  {
    _console.clearScreen();
    _console.resetCursorPosition();
  }

  void redPrint(String s){
    try{
      stdout.write(_redPen(s));
    }catch(e){
      stdout.write(s);
    }
  }

  void redPrintln(String s){
    try{
      stdout.writeln(_redPen(s));
    }catch(e){
      stdout.writeln(s);
    }
  }

  void greenPrint(String s){
    try{
      stdout.write(_greenPen(s));
    }catch(e){
      stdout.write(s);
    }
  }

  void greenPrintln(String s){
    try{
      stdout.writeln(_greenPen(s));
    }catch(e){
      stdout.writeln(s);
    }
  }

  void bluePrint(String s){
    try{
      stdout.write(_bluePen(s));
    }catch(e){
      stdout.write(s);
    }
  }

  void bluePrintln(String s){
    try{
      stdout.writeln(_bluePen(s));
    }catch(e){
      stdout.writeln(s);
    }
  }

  void yellowPrint(String s){
    try{
      stdout.write(_yellowPen(s));
    }catch(e){
      stdout.write(s);
    }
  }

  void yellowPrintln(String s){
    try{
      stdout.writeln(_yellowPen(s));
    }catch(e){
      stdout.writeln(s);
    }
  }

  void customPrint({required String s, int r = 255, int g = 255, int b = 255}){
    try{
      num red = r <= 255 ? (r/255) : 1.0;
      num green = g <= 255 ? (g / 255) : 1.0;
      num blue = b <= 255 ? (b/ 255) : 1.0;

      var customPen = AnsiPen()..rgb(r: red, g: green, b: blue);
      stdout.write(customPen(s));
    }catch(e){
      stdout.write(s);
    }
  }

  void customPrintln({required String s, int r = 255, int g = 255, int b = 255}){
    try{
      num red = r <= 255 ? (r/255) : 1.0;
      num green = g <= 255 ? (g / 255) : 1.0;
      num blue = b <= 255 ? (b/ 255) : 1.0;

      var customPen = AnsiPen()..rgb(r: red, g: green, b: blue);
      stdout.writeln(customPen(s));
    }catch(e){
      stdout.writeln(s);
    }
  }
}