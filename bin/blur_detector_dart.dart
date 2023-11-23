import 'package:blur_detector/blur_detector_dart.dart';

Future<void> main(List<String> arguments) async {
  var list = [
    "asset/blur_300.png",
    "asset/100%.jpg",
    "asset/98%.jpg",
    "asset/0%.jpg",
    "asset/84%.jpg",
    "asset/men_small_500.png"
  ];

  for (var i in list) {
    var variance = await readImageFile(i);
    print(variance);
  }
}
