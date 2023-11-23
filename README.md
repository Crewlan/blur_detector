# blur_detector_dart
Perform Blur Detection using Laplacian Filter , need to set threshold to find blur or not.

```dart 
import 'package:initial_image_process/initial_image_process.dart';

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
    var variance = await read_image_file(i);
    print(variance);
  }
}
```