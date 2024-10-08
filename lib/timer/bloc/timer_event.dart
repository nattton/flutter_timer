part of 'timer_bloc.dart';

@freezed
class TimerEvent with _$TimerEvent {
  const factory TimerEvent.started({required int duration}) = Started;
  const factory TimerEvent.paused() = Paused;
  const factory TimerEvent.resumed() = Resumed;
  const factory TimerEvent.reset() = Reset;
  const factory TimerEvent.ticked({required int duration}) = _Ticked;
}
