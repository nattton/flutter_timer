import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer/ticker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_bloc.freezed.dart';
part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker ticker;
  static const int _duration = 60;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required this.ticker}) : super(const Initial(_duration)) {
    on<Started>(_onStarted);
    on<Paused>(_onPaused);
    on<Resumed>(_onResumed);
    on<Reset>(_onReset);
    on<_Ticked>(_onTicked);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onStarted(Started event, Emitter<TimerState> emit) {
    emit(RunInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(_Ticked(duration: duration)));
  }

  FutureOr<void> _onPaused(Paused event, Emitter<TimerState> emit) {
    state.whenOrNull(
      runInProgress: (duration) {
        _tickerSubscription?.pause();
        emit(RunPause(duration));
      },
    );
  }

  FutureOr<void> _onResumed(Resumed event, Emitter<TimerState> emit) {
    state.whenOrNull(
      runPause: (duration) {
        _tickerSubscription?.resume();
        emit(RunInProgress(duration));
      },
    );
  }

  FutureOr<void> _onReset(Reset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const Initial(_duration));
  }

  FutureOr<void> _onTicked(_Ticked event, Emitter<TimerState> emit) {
    emit(event.duration > 0
        ? RunInProgress(event.duration)
        : const RunComplete());
  }
}
