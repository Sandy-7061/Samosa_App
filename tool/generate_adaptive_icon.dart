import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('assets/images/app_icon.png');
  final bytes = file.readAsBytesSync();
  final original = img.decodeImage(bytes);
  if (original == null) {
    print('Failed to decode image');
    return;
  }

  final targetSize = 1024;
  final canvas = img.Image(width: targetSize, height: targetSize, numChannels: 4);
  // Fill transparent
  img.fill(canvas, color: img.ColorRgba8(0, 0, 0, 0));

  // Scale original to 74% so it stays completely inside safe zone
  final innerSize = (targetSize * 0.74).round();
  final resized = img.copyResize(original, width: innerSize, height: innerSize);

  final offset = ((targetSize - innerSize) / 2).round();
  img.compositeImage(canvas, resized, dstX: offset, dstY: offset);

  File('assets/images/app_icon_foreground.png').writeAsBytesSync(img.encodePng(canvas));
  print('Successfully generated app_icon_foreground.png with safe padding');
}
