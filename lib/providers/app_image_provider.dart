import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class AppImageProvider extends ChangeNotifier {

  List<Uint8List> _images = [];
  int _index = 0;

  bool canUndo = false;
  bool canRedo = false;

  changeImageFile(File image){
    _add(image.readAsBytesSync());
  }

  changeImage(Uint8List image){
    _add(image);
  }

  Uint8List? get currentImage{
    return _images[_index];
  }

  _add(Uint8List image){
    if(_images.isEmpty){
      _images.add(image);
    } else {
      int removeUntil = (_images.length-1) - _index;
      _images.length = _images.length - removeUntil;
      _images.add(image);
      _index++;
    }
    _undoRedo();
    notifyListeners();
  }

  undo(){
    if(_index > 0){
      _index--;
    }
    _undoRedo();
    notifyListeners();
  }

  redo(){
    if(_index < _images.length-1){
      _index++;
    }
    _undoRedo();
    notifyListeners();
  }

  _undoRedo(){
    canUndo = (_index != 0) ? true : false;
    canRedo = (_index < _images.length-1) ? true : false;
  }

}