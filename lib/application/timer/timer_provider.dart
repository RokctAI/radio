import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:single_radio/application/playback/playback_provider.dart';
import 'package:single_radio/application/timer/timer_notifier.dart';
import 'package:single_radio/application/timer/timer_state.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>(
  (ref) => TimerNotifier(
    onTimer: () => ref.read(playbackProvider.notifier).pause(),
  ),
);
