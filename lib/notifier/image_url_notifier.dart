import 'package:flutter/material.dart';

import '../utils/app_layout.dart';

class ImageUrlNotifier extends ChangeNotifier {
  String _imageUrl = '';
  Image _image = Image.asset(
    'assets/images/back_blur_img.webp',
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

  void setImage(Image url) {
    _image = url;
    notifyListeners();
  }
}
