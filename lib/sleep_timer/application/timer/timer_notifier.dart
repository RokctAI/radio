import 'dart:async';
import 'package:flutter/material.dart';

class TimerNotifier with ChangeNotifier {
  TimerNotifier({
    required this.onTimer,
  });

  final VoidCallback onTimer;

  Timer? timer;
  Duration timerDuration = const Duration(hours: 0, minutes: 0);
  final timerPeriod = const Duration(seconds: 1);
  int maxTime = 0;

  void setTimer(Duration value) {
    timerDuration = value;
    maxTime = value.inSeconds;
    notifyListeners();
  }

  void startTimer() {
    timer = Timer.periodic(timerPeriod, onTick);
    notifyListeners();
  }

  void stopTimer() {
    timer?.cancel();
    notifyListeners();
  }

  void onTick(Timer timer) {
    if (timerDuration == Duration.zero) {
      onTimer();
      stopTimer();
    } else {
      timerDuration -= timerPeriod;
      notifyListeners();
    }
  }
}
