
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../model/block.dart';
import '../treat/string_included.dart';

class GiftNumber {
  final StringIncluded _stringIncluded = StringIncluded();

  String run(List<Block> textBlocks) {
    final String pattern = r'\d{12}|\d{4}\s\d{4}\s\d{4}';

    for (final block in textBlocks) {
      final String text = block.blockText;

      if (StringIncluded.check(pattern, text)) {
        return text;
      }
    }
    return '';
  }
}
