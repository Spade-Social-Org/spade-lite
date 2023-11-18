import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:spade_lite/resources/resources.dart';

void main() {
  test('spider_svg_assets assets test', () {
    expect(File(SpiderSvgAssets.bookmark).existsSync(), isTrue);
    expect(File(SpiderSvgAssets.discard).existsSync(), isTrue);
    expect(File(SpiderSvgAssets.heart).existsSync(), isTrue);
    expect(File(SpiderSvgAssets.heartOutlined).existsSync(), isTrue);
    expect(File(SpiderSvgAssets.locationArrow).existsSync(), isTrue);
    expect(File(SpiderSvgAssets.message).existsSync(), isTrue);
    expect(File(SpiderSvgAssets.next).existsSync(), isTrue);
    expect(File(SpiderSvgAssets.send).existsSync(), isTrue);
    expect(File(SpiderSvgAssets.storyPlus).existsSync(), isTrue);
    expect(File(SpiderSvgAssets.swipeLeft).existsSync(), isTrue);
    expect(File(SpiderSvgAssets.swipeRight).existsSync(), isTrue);
    expect(File(SpiderSvgAssets.upload).existsSync(), isTrue);
  });
}
