import 'package:flutter/cupertino.dart';
import '../utils/constant.dart';

class AdsCallBack extends ChangeNotifier {
  bool dismiss = false;
  bool failed = false;

  setFailed() {
    failed = true;
    notifyListeners();
  }

  setDismiss() {
    dismiss = true;
    notifyListeners();
  }

  Future<String> openAdsOnMessageEvent() async {
    String finalResult = '';
    if (dismiss) {
      finalResult = Constant.dismiss;
    } else {
      finalResult = Constant.failed;
    }
    return finalResult;
  }
}
