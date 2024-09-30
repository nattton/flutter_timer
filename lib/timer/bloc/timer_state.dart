part of 'timer_bloc.dart';

@freezed
class TimerState with _$TimerState {
  const factory TimerState.initial(int duration) = Initial;
  const factory TimerState.runPause(int duration) = RunPause;
  const factory TimerState.runInProgress(int duration) = RunInProgress;
  const factory TimerState.runComplete() = RunComplete;
}
