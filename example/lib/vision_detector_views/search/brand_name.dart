
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../model/block.dart';
import '../treat/extract_string_after_colon.dart';
import '../treat/string_included.dart';

class BrandName {
  final StringIncluded _stringIncluded = StringIncluded();
  final ExtractStringAfterColon _extractStringAfterColon = ExtractStringAfterColon();

  String run(List<Block> textBlocks) {
    final String pattern = '교환처|사용처';

    for (final block in textBlocks) {
      final String text = block.blockText;

      if (StringIncluded.check(pattern, text)) {
        return ExtractStringAfterColon.extract(text);
      }
    }
    return '';
  }
}