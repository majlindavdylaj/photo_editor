import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class AppImageProvider extends ChangeNotifier {

  Uint8List? currentImage;

  changeImage(File image){
    currentImage = image.readAsBytesSync();
    notifyListeners();
  }

}