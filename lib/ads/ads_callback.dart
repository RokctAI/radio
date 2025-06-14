import 'package:flutter/cupertino.dart';
import '../utils/Constant.dart';

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
      finalResult = Constant.DISMISS;
    } else {
      finalResult = Constant.FAILED;
    }
    return finalResult;
  }
}
