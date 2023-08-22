import 'package:google_ml_kit_example/vision_detector_views/model/block.dart';
import 'package:google_ml_kit_example/vision_detector_views/treat/extract_period.dart';
import 'package:google_ml_kit_example/vision_detector_views/treat/string_included.dart';

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
