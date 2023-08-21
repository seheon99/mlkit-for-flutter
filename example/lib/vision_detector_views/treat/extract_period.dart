import 'extract_string_after_colon.dart';
import 'remove_special_char.dart';
import 'string_included.dart';

class ExtractPeriod {
  final StringIncluded stringIncluded = StringIncluded();
  final ExtractStringAfterColon extractStringAfterColon =
      ExtractStringAfterColon();
  final RemoveSpecialChar removeSpecialCharacters =
      RemoveSpecialChar();

  String run(String text) {
    String result = text;

    if (StringIncluded.check(":", text)) {
      result = ExtractStringAfterColon.extract(text);
    }

    if (StringIncluded.check("까지", result)) {
      result = removeUntil("까지", result);
    }

    result = removeSpecialCharacters.run(result);

    result = convertDate(result);

    return result;
  }

  static String convertDate(String input) {
    final RegExp pattern =
        RegExp(r"(\d{4})년\s(\d{1,2})월\s(\d{1,2})일\s");
    final Match? match = pattern.firstMatch(input);

    if (match != null) {
      final String? year = match.group(1);
      final String? month = match.group(2);
      final String? day = match.group(3);

    if (year != null && month != null && day != null) {
    return '$year.${padZero(month)}.$day';
    }
    }

    return input;
  }

  static String padZero(String value) {
    return value.length < 2 ? "0$value" : value;
  }

  static String removeUntil(String target, String text) {
    final int endIndex = text.indexOf(target);

    if (endIndex != -1) {
      return text.substring(0, endIndex);
    }

    return text;
  }
}