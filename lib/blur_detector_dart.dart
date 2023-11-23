import 'dart:io';
import 'dart:math';
import 'package:image/image.dart';

readImageFile(filename) async {
  // File file = File(filename);
  var image = decodeImage(File(filename).readAsBytesSync())!;
  image = copyResize(image, width: 200, height: 200);
  //int C = image.getPixel(0, 0);

  //print(C);

  //print(image.data[0]);

  var f1 = image.data?.getBytes(order: ChannelOrder.argb).map((element) {
    return intToArgb(element);
  }).toList();
  var kernal = [0, 1, 0, 1, -4, 1, 0, 1, 0];
  return conv2dFour(f1, kernal, image);

  // for (int yx = 0, y = 0, x = 0; yx < image.height * image.width; yx++) {
  //   int index = y * image.width + x;
  //   //image.getPixel(x, y);
  //   int g = f1[index];
  //   image.setPixel(x, y, Color.fromRgba(g, g, g, g));

  //   if (++x == image.width) {
  //     x = 0;
  //     ++y;
  //   }
  // }

  // File m1 = File("asset/test.png");

  //var lint = encodeNamedImage(image, "asset/test.png");
  //m1.writeAsBytesSync(lint!);
  //print(f1);
  //print(image.data[0]);

//  int_to_argb(C);
}

readImageFile_({filename, width = 200, height = 200}) async {
  // File file = File(filename);
  var image = decodeImage(File(filename).readAsBytesSync())!;
  image = copyResize(image, width: width, height: height);
  var f1 = image.data?.getBytes(order: ChannelOrder.argb).map((element) {
    return intToArgb(element);
  }).toList();
  var kernal = [0, 1, 0, 1, -4, 1, 0, 1, 0];
  return conv2dFour(f1, kernal, image);
}

int intToArgb(int argb) {
  var max = pow(16, 8) - 1;
  if (argb < 0 || argb > max) {
    print("argb data should be between 0 and max value");
  }

  int a = ((argb & 0xFF000000) >> 24);
  int b = ((argb & 0x00FF0000) >> 16);
  int g = ((argb & 0x0000FF00) >> 8);
  int r = ((argb & 0x000000FF));

  //print(max);
  //print("Alpha ${a},Red ${r},Green ${g},Blue ${b}");

  return averageGrey(a, r, g, b);
}

int averageGrey(int alpha, int red, int green, int blue) {
  return ((alpha + red + green + blue) / 4).round();
}

conv2dFour(List<int>? input, List kernal, Image image) {
  int output3 = 0;
  List<int> vars = [];
  for (int j = 0; j < image.height; j++) {
    for (int i = 0; i < image.width; i++) {
      output3 = 0;
      for (int n = 0; n < 3; n++) {
        for (int m = 0; m < 3; m++) {
          try {
            int kernalIndex = n * 3 + m;
            int imageIndex = (j - n) * image.width + (i - m);
            int x = input![imageIndex];
            int h = kernal[kernalIndex];
            output3 += (x * h);
            //   print(
            //       "x = $i, y= $j,image = ${input[imageIndex]},  Kernal value = ${kernal[kernalIndex]},O = ${output3},m =$m,n=$n");
            //
          } catch (e) {}
        }
      }
      vars.add(output3);
      // image.setPixel(i, j, Color.fromRgba(output3.toInt(), output3.toInt(), output3.toInt(), output3.toInt()));
      image.setPixelRgba(i, j, output3.toInt(), output3.toInt(), output3.toInt(), output3.toInt());
      //    print("${output3}========");
    }
  }
  return variance(vars, image);
}

variance(List<int> li, Image image) {
  //print("width = ${image.width} , Height = ${image.height}");
  int vai = 0;
  for (int yx = 0, y = 0, x = 0; yx < image.height * image.width; yx++) {
    int index = y * image.width + x;
    vai += li[index];

    if (++x == image.width) {
      x = 0;
      ++y;
    }
  }

  var xMean = vai / (image.height * image.width);

  List<double> xx = li.map((e) {
    double o = (e - xMean);
    if (o < 0) {
      o = -1 * o;
    }
    double d = pow(o, 2) * 1.0;

    return d;
  }).toList();

  double vaid = 0.0;
  for (int yx = 0, y = 0, x = 0; yx < image.height * image.width; yx++) {
    int index = y * image.width + x;
    vaid += xx[index];

    if (++x == image.width) {
      x = 0;
      ++y;
    }
  }
  var xdVariance = vaid / (image.height * image.width);
  //print("vaid => ${xd_variance}, vai => $x_mean");
  return [xdVariance, xMean];
}

conv2d(List input, List kernal, Image image) {
  for (int mnij = 0, m = 0, n = 0, i = 0, j = 0; mnij < input.length; mnij++) {
    var imageIndex = j * image.width + i;
    var kernalIndex = n * 3 + m;
    var output = input[imageIndex] * kernal[kernalIndex];
    if (output < 0) {
      output = 0;
    }
    if (output > 255) {
      output = 255;
    }
    // image.setPixel(i, j, Color.fromRgba(output, output, output, output));
    image.setPixelRgba(i, j, output, output, output, output);
    print("image Index = $imageIndex, x = $i,y = $j, kernal Index = $kernalIndex, m = $m, n = $n, output = $output");

    //var data = image.getPixel(i, j);

    if (++m == 3) {
      m = 0;
      ++n;
    }
    if (n >= 3) {
      n = 0;
    }
    //n = 0;

    if (++i == image.width) {
      i = 0;
      ++j;
    }
  }
}

//np.mean(np.abs(x-x.mean())*np.abs(x-x.mean()))
