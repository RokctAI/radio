import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_state.freezed.dart';

@freezed
class TimerState with _$TimerState {
  const factory TimerState({
    @Default(Duration.zero) Duration remaining,
    @Default(0) int maxTime,
    @Default(false) bool isRunning,
  }) = _TimerState;

  const TimerState._();
}
