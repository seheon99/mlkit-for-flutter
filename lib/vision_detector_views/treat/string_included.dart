import 'dart:core';

class StringIncluded {
  static bool check(String pattern, String text) {
    return RegExp(pattern).hasMatch(text);
  }
}