import 'dart:math';

import 'package:google_ml_kit_example/vision_detector_views/model/block.dart';
import 'package:google_ml_kit_example/vision_detector_views/treat/string_included.dart';

class Giftishow {
  List<Block> run(List<Block> blockList) {
    var blocks = checkBlockSize(blockList);
    var croppedBlocks = cropGiftishow(blocks);
    var mergedBlocks = mergeTextBlocksGiftishow(croppedBlocks);
    return mergedBlocks;
  }

  List<Block> checkBlockSize(List<Block> textBlocks) {
    int size = 25;

    return textBlocks.where((block) {
      return block.blockFrame.right - block.blockFrame.left >= size;
    }).toList();
  }

  List<Block> cropGiftishow(List<Block> textBlocks) {
    int startTop = 635;
    var sortedByTopBlocks = List<Block>.from(textBlocks)
      ..sort((block1, block2) =>
          block2.blockFrame.top.compareTo(block1.blockFrame.top));

    for (var block in sortedByTopBlocks) {
      String text = block.blockText;

      if (StringIncluded.check('기프티쇼', text) ||
          StringIncluded.check('giftishow', text)) {
        startTop = block.blockFrame.bottom;
        break;
      }
    }

    return textBlocks.where((block) {
      return block.blockFrame.top >= startTop;
    }).toList();
  }

  List<Block> mergeTextBlocksGiftishow(List<Block> textBlocks) {
    var sortedByTopBlocks = List<Block>.from(textBlocks)
      ..sort((block1, block2) =>
          block1.blockFrame.left.compareTo(block2.blockFrame.left));

    var mergedBlocks = <Block>[];

    for (var cur in sortedByTopBlocks) {
      for (var block in sortedByTopBlocks) {
        String pattern = RegExp.escape(cur.blockText);
        if (!StringIncluded.check(pattern, block.blockText)) {
          if ((block.blockFrame.top - cur.blockFrame.top).abs() <= 10) {
            cur.blockText += ' ${block.blockText}';
            cur.blockFrame = cur.blockFrame.copyWith(
              top: min(block.blockFrame.top, cur.blockFrame.top),
              bottom: max(block.blockFrame.bottom, cur.blockFrame.bottom),
              left: min(block.blockFrame.left, cur.blockFrame.left),
              right: max(block.blockFrame.right, cur.blockFrame.right),
            );
          } else {
            if (!mergedBlocks.contains(cur)) {
              mergedBlocks.add(cur);
            }
          }
        }
      }
    }

    return mergedBlocks;
  }
}
