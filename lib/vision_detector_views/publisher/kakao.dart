import 'dart:math';

import 'package:google_ml_kit_example/vision_detector_views/model/block.dart';
import 'package:google_ml_kit_example/vision_detector_views/treat/string_included.dart';

class Kakao {
  final StringIncluded stringIncluded = StringIncluded();
  final String tag = 'kakaoGift';

  List<Block> run(List<Block> blockList) {
    List<Block> blocks = checkBlockSize(blockList);
    List<Block> croppedBlocks = cropKakao(blocks);
    List<Block> mergedBlocks = mergeTextBlocksKakao(croppedBlocks);
    return mergedBlocks;
  }

  List<Block> cropKakao(List<Block> textBlocks) {
    int startTop = 800;
    List<Block> filteredBlocks = [];

    for (Block block in textBlocks) {
      if (block.blockFrame.top >= startTop) {
        filteredBlocks.add(block);
      }
    }
    return filteredBlocks;
  }

  List<Block> checkBlockSize(List<Block> textBlocks) {
    int size = 25;
    List<Block> filteredBlocks = [];
    for (Block block in textBlocks) {
      if ((block.blockFrame.right - block.blockFrame.left).abs() >= size) {
        filteredBlocks.add(block);
      }
    }
    return filteredBlocks;
  }

  List<Block> mergeTextBlocksKakao(List<Block> textBlocks) {
    int marginLeft = 5;
    int marginBetweenTopBottom = 20;
    int nameBottom = 1100;
    int nameLeft = 300;
    int marginSameTop = 5;
    List<Block> mergedBlocks = [];

    List<Block> sortedByTopBlocks =
        textBlocks.where((block) => block.blockFrame.left <= nameLeft).toList();
    sortedByTopBlocks
        .sort((a, b) => a.blockFrame.top.compareTo(b.blockFrame.top));

    List<Block> sortedByLeftBarcodeBelow = textBlocks
        .where((block) => block.blockFrame.bottom >= nameBottom)
        .toList();
    sortedByLeftBarcodeBelow
        .sort((a, b) => a.blockFrame.left.compareTo(b.blockFrame.left));

    Block name = sortedByTopBlocks[0];

    for (int i = 1; i < sortedByTopBlocks.length; i++) {
      Block block = sortedByTopBlocks[i];
      if ((block.blockFrame.left - name.blockFrame.left).abs() <= marginLeft &&
          block.blockFrame.bottom <= nameBottom &&
          (block.blockFrame.top - name.blockFrame.bottom).abs() <=
              marginBetweenTopBottom) {
        name.blockText += " " + block.blockText;
        name.blockFrame = name.blockFrame.copyWith(
          top: min(block.blockFrame.top, name.blockFrame.top),
          bottom: max(block.blockFrame.bottom, name.blockFrame.bottom),
          left: min(block.blockFrame.left, name.blockFrame.left),
          right: max(block.blockFrame.right, name.blockFrame.right),
        );
      }
    }
    mergedBlocks.add(name);

    for (Block cur in sortedByLeftBarcodeBelow) {
      for (Block block in sortedByLeftBarcodeBelow) {
        String pattern = RegExp.escape(cur.blockText);
        if (!StringIncluded.check(pattern, block.blockText)) {
          if ((block.blockFrame.top - cur.blockFrame.top).abs() <=
              marginSameTop) {
            cur.blockText += " " + block.blockText;
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
