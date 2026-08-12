import 'dart:developer';

import 'package:flutter/material.dart';

import '../utils/app_layout.dart';

class ImageUrlNotifier extends ChangeNotifier {
  String _imageUrl = '';
  Image _image = Image.asset(
    'assets/images/back_blur_img.jpg',
    height: AppLayout.getScreenHeight(),
    width: AppLayout.getScreenWidth(),
    fit: BoxFit.fill,
  );

  String get imageUrl => _imageUrl;
  Image get image => _image;

  void setImageUrl(String url) {
    _imageUrl = url;
    notifyListeners();
  }

  bool callOnce = false;
  Future<void> setImage(Image url) async{
    if (_image.image is MemoryImage && url.image is MemoryImage) {
      final existingBytes = (_image.image as MemoryImage).bytes;
      final newBytes = (url.image as MemoryImage).bytes;
      if (existingBytes == newBytes) {
        callOnce = false;
      }else{
        callOnce = true;
        _image = url;
        log('Updated image: $_image');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    }
  }

}
