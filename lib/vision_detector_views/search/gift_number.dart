import 'package:google_ml_kit_example/vision_detector_views/model/block.dart';
import 'package:google_ml_kit_example/vision_detector_views/treat/string_included.dart';

class GiftNumber {
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
