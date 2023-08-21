import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../model/block.dart';
import '../treat/extract_period.dart';
import '../treat/string_included.dart';

class Period {
  final ExtractPeriod _extractPeriod = ExtractPeriod();

  String? run(List<Block> textBlocks) {
    final String pattern = r'\d{4}\.\d{2}\.\d{2}\n|까지|유효기간|사용기간';

    for (final block in textBlocks) {
      final String text = block.blockText;

      if (StringIncluded.check(pattern, text)) {
        print(text);
        final String result = _extractPeriod.run(text);
        return result;
      }
    }
    return '';
  }
}

