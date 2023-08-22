import 'package:google_ml_kit_example/vision_detector_views/model/block.dart';
import 'package:google_ml_kit_example/vision_detector_views/treat/extract_string_after_colon.dart';
import 'package:google_ml_kit_example/vision_detector_views/treat/string_included.dart';

class ProductName {
  StringIncluded stringIncluded = StringIncluded();
  ExtractStringAfterColon extractStringAfterColon = ExtractStringAfterColon();

  String run(List<Block> textBlocks) {
    String pattern = r'상품명|상품권';

    for (var block in textBlocks) {
      String text = block.blockText;

      if (StringIncluded.check(pattern, text)) {
        print(text);
        return ExtractStringAfterColon.extract(text);
      }
    }
    return textBlocks[0].blockText;
  }
}
