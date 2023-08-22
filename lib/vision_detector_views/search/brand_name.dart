import 'package:google_ml_kit_example/vision_detector_views/model/block.dart';
import 'package:google_ml_kit_example/vision_detector_views/treat/extract_string_after_colon.dart';
import 'package:google_ml_kit_example/vision_detector_views/treat/string_included.dart';

class BrandName {
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
