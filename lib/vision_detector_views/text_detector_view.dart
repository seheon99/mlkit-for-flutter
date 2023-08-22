import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'detector_view.dart';
import 'model/block.dart';
import 'model/block_frame.dart';
import 'painters/text_detector_painter_by_line.dart';
import 'publisher/giftishow.dart';
import 'publisher/kakao.dart';
import 'search/brand_name.dart';
import 'search/gift_number.dart';
import 'search/period.dart';
import 'search/product_name.dart';
import 'treat/extract_period.dart';
import 'treat/remove_special_char.dart';
import 'treat/string_included.dart';

class TextRecognizerView extends StatefulWidget {
  @override
  State<TextRecognizerView> createState() => _TextRecognizerViewState();

  final StringIncluded stringIncluded = StringIncluded();
  final ExtractPeriod extractPeriod = ExtractPeriod();
}

class _TextRecognizerViewState extends State<TextRecognizerView> {
  var _script = TextRecognitionScript.korean;
  var _textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        DetectorView(
          title: 'Text Detector',
          customPaint: _customPaint,
          text: _text,
          onImage: _processImage,
          initialCameraLensDirection: _cameraLensDirection,
          onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
        ),
        Positioned(
            top: 30,
            left: 100,
            right: 100,
            child: Row(
              children: [
                Spacer(),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: _buildDropdown(),
                    )),
                Spacer(),
              ],
            )),
        // Positioned(
        //   bottom: 30,
        //   left: 30,
        //   right: 30,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     children: [
        //       Text('Product Name: $_productName'),
        //       Text('Brand Name: $_brandName'),
        //       Text('Period: $_period'),
        //       Text('Gift Number: $_giftNumber'),
        //     ],
        //   ),
        // ),
      ]),
    );
  }


  Widget _buildDropdown() => DropdownButton<TextRecognitionScript>(
        value: _script,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.blue),
        underline: Container(
          height: 2,
          color: Colors.blue,
        ),
        onChanged: (TextRecognitionScript? script) {
          if (script != null) {
            setState(() {
              _script = script;
              _textRecognizer.close();
              _textRecognizer = TextRecognizer(script: _script);
            });
          }
        },
        items: TextRecognitionScript.values
            .map<DropdownMenuItem<TextRecognitionScript>>((script) {
          return DropdownMenuItem<TextRecognitionScript>(
            value: script,
            child: Text(script.name),
          );
        }).toList(),
      );

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = TextRecognizerPainter(
        recognizedText,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'Recognized text:\n\n${recognizedText.text}';
      processTextRecognitionToText(recognizedText);
    
      // TODO: set _customPaint to draw boundingRect on top of image

      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
void processTextRecognitionToText(RecognizedText texts) {
  // mTextView.text = "";
  // mTextView.textColor = Colors.black;
  List<Block> blockList = [];

  Kakao kakaoGift = Kakao();
  Giftishow giftishowGift = Giftishow();

  ProductName searchProductName = ProductName();
  BrandName searchBrandName = BrandName();
  Period searchPeriod = Period();
  GiftNumber searchGiftNumber = GiftNumber();

  RemoveSpecialChar removeSpecialCharacters = RemoveSpecialChar();
  
  var jsonArray = [];

  int blockCounter = 0;

  for (var block in texts.blocks) {
    for (var line in block.lines) {

      String lineText = removeSpecialCharacters.run(line.text);
      Rect lineFrame = line.boundingBox;

      BlockFrame blockFrame = BlockFrame(
          lineFrame.top.round(), lineFrame.bottom.round(), lineFrame.left.round(), lineFrame.right.round());
  
      Block blockItem = Block(lineText, blockFrame);

      blockList.add(blockItem);
      print('before-kakao ${blockItem.blockText}, ${blockItem.blockFrame.top}, ${blockItem.blockFrame.bottom}, ${blockItem.blockFrame.left}, ${blockItem.blockFrame.right}');

    }
  }

  if (isKakao(blockList)) {
    List<Block> kakaoBlocks = kakaoGift.run(blockList);
  
    for(var block in kakaoBlocks) {
      print('after-kakao ${block.blockText}, ${block.blockFrame.top}');
    }
    String productName = searchProductName.run(kakaoBlocks);
    String brandName = searchBrandName.run(kakaoBlocks);
    String? period = searchPeriod.run(kakaoBlocks);
    String giftNumber = searchGiftNumber.run(kakaoBlocks);

    print('productName $productName');
    print('brandName $brandName');
    print('period $period');
    print('giftNumber $giftNumber');

    // jsonArray = saveStringToJsonArray(productName, brandName, period, giftNumber);
  } else if (isGiftishow(blockList)) {
    print('isGiftishow Yes');
    List<Block> giftishowBlocks = giftishowGift.run(blockList);

    String productName = searchProductName.run(giftishowBlocks);
    String brandName = searchBrandName.run(giftishowBlocks);
    String? period = searchPeriod.run(giftishowBlocks);
    String giftNumber = searchGiftNumber.run(giftishowBlocks);

    print('productName $productName');
    print('brandName $brandName');
    print('period $period');
    print('giftNumber $giftNumber');

    // jsonArray = saveStringToJsonArray(productName, brandName, period, giftNumber);
  } else {
    print('Others Yes');
    List<Block> filteredBlocks = giftishowGift.checkBlockSize(blockList);
    List<Block> resultBlocks = giftishowGift.mergeTextBlocksGiftishow(filteredBlocks);

    String productName = searchProductName.run(resultBlocks);
    String brandName = searchBrandName.run(resultBlocks);
    String? period = searchPeriod.run(resultBlocks);
    String giftNumber = searchGiftNumber.run(resultBlocks);

    print('productName $productName');
    print('brandName $brandName');
    print('period $period');
    print('giftNumber $giftNumber');

    // jsonArray = saveStringToJsonArray(productName, brandName, period, giftNumber);
  }

  // // One image corresponds to one JSON
  // var imageJson = {};
  // try {
  //   imageJson['imageId'] = textViewCounter;
  //   imageJson['textBlocks'] = jsonArray;
  // } catch (e) {
  //   print(e);
  // }
  // // Save the JSON object to a file
  // saveJsonToFile(imageJson);
  // // Increment the image counter
  // textViewCounter++;
}

bool isGiftishow(List<Block> textBlocks) {
  String pattern1 = "giftishow";
  String pattern2 = "기프티쇼";
  for (var block in textBlocks) {
    String blockText = block.blockText;

    if (StringIncluded.check(pattern1, blockText.toLowerCase())) {
      print("isGiftishow: yes");
      return true;
    } else if (StringIncluded.check(pattern2, blockText.toLowerCase())) {
      print("isGiftishow: yes");
      return true;
    }
  }
  return false;
}

bool isKakao(List<Block> textBlocks) {
  String pattern = "kakao";
  for (var block in textBlocks) {
    String blockText = block.blockText;
    if (StringIncluded.check(pattern, blockText.toLowerCase())) {
      print("isKakao: yes");
      return true;
    }
  }
  return false;
}

