import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:single_radio/application/timer/timer_state.dart';

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier({required this.onTimer}) : super(const TimerState());

  /// Called once the countdown reaches zero. Wired to playback pause by the
  /// provider, so the notifier itself stays unaware of the player.
  final VoidCallback onTimer;

  static const _period = Duration(seconds: 1);
  Timer? _timer;

  void setTimer(Duration value) {
    state = state.copyWith(remaining: value, maxTime: value.inSeconds);
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_period, _onTick);
    state = state.copyWith(isRunning: true);
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isRunning: false);
  }

  void _onTick(Timer timer) {
    if (state.remaining <= Duration.zero) {
      onTimer();
      stopTimer();
      return;
    }
    state = state.copyWith(remaining: state.remaining - _period);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
