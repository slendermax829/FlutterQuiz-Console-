import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:dart_console/dart_console.dart';

/// Mixin class for input, screen control, and colored output.
mixin QuizUI {
  /// Checkmark symbol used in results displays.
  final String CHECKMARK = '\u2713';

  /// Console object to use for clearing screen internally
  final _console = Console();

  final _redPen = AnsiPen()..red();
  final _greenPen = AnsiPen()..green();
  final _bluePen = AnsiPen()..blue();
  final _yellowPen = AnsiPen()..yellow();

  /// Reads user input from the terminal.
  String? userInput() {
    stdout.write('>> ');
    return stdin.readLineSync()?.trim().toLowerCase();
  }

  /// Clears the console/terminal.
  void clearScreen() {
    _console.clearScreen();
    _console.resetCursorPosition();
  }

  /// Writes a string using the red output style.
  void redPrint(String s) {
    try {
      stdout.write(_redPen(s));
    } catch (e) {
      stdout.write(s);
    }
  }

  /// Writes a line using the red output style.
  void redPrintln(String s) {
    try {
      stdout.writeln(_redPen(s));
    } catch (e) {
      stdout.writeln(s);
    }
  }

  /// Writes a string using the green output style.
  void greenPrint(String s) {
    try {
      stdout.write(_greenPen(s));
    } catch (e) {
      stdout.write(s);
    }
  }

  /// Writes a line using the green output style.
  void greenPrintln(String s) {
    try {
      stdout.writeln(_greenPen(s));
    } catch (e) {
      stdout.writeln(s);
    }
  }

  /// Writes a string using the blue output style.
  void bluePrint(String s) {
    try {
      stdout.write(_bluePen(s));
    } catch (e) {
      stdout.write(s);
    }
  }

  /// Writes a line using the blue output style.
  void bluePrintln(String s) {
    try {
      stdout.writeln(_bluePen(s));
    } catch (e) {
      stdout.writeln(s);
    }
  }

  /// Writes a string using the yellow output style.
  void yellowPrint(String s) {
    try {
      stdout.write(_yellowPen(s));
    } catch (e) {
      stdout.write(s);
    }
  }

  /// Writes a line using the yellow output style.
  void yellowPrintln(String s) {
    try {
      stdout.writeln(_yellowPen(s));
    } catch (e) {
      stdout.writeln(s);
    }
  }

  /// Writes a string using a custom RGB color when supported.
  /// 
  /// [r],[g],[b] are set to 255 by default
  void customPrint({required String s, int r = 255, int g = 255, int b = 255}) {
    try {
      num red = r <= 255 ? (r / 255) : 1.0;
      num green = g <= 255 ? (g / 255) : 1.0;
      num blue = b <= 255 ? (b / 255) : 1.0;

      var customPen = AnsiPen()..rgb(r: red, g: green, b: blue);
      stdout.write(customPen(s));
    } catch (e) {
      stdout.write(s);
    }
  }

  /// Writes a line using a custom RGB color when supported.
  ///
  /// [r],[g],[b] are set to 255 by default
  void customPrintln({
    required String s,
    int r = 255,
    int g = 255,
    int b = 255,
  }) {
    try {
      num red = r <= 255 ? (r / 255) : 1.0;
      num green = g <= 255 ? (g / 255) : 1.0;
      num blue = b <= 255 ? (b / 255) : 1.0;

      var customPen = AnsiPen()..rgb(r: red, g: green, b: blue);
      stdout.writeln(customPen(s));
    } catch (e) {
      stdout.writeln(s);
    }
  }
}
