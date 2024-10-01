import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_timer/ticker.dart';
import 'package:flutter_timer/timer/timer.dart';
import 'package:mocktail/mocktail.dart';

class _MockTicker extends Mock implements Ticker {}

void main() {
  group('TimerBloc', () {
    late Ticker ticker;

    setUp(() {
      ticker = _MockTicker();
      when(() => ticker.tick(ticks: 5)).thenAnswer(
        (_) => Stream<int>.fromIterable([5, 4, 3, 2, 1]),
      );
    });

    test('initial state is TimerInitial(60)', () {
      expect(
        TimerBloc(ticker: ticker).state,
        const Initial(60),
      );
    });

    blocTest<TimerBloc, TimerState>(
      'emits TickerRunInProgress 5 times after timer started',
      build: () => TimerBloc(ticker: ticker),
      act: (bloc) => bloc.add(const Started(duration: 5)),
      expect: () => [
        const RunInProgress(5),
        const RunInProgress(4),
        const RunInProgress(3),
        const RunInProgress(2),
        const RunInProgress(1),
      ],
      verify: (_) => verify(() => ticker.tick(ticks: 5)).called(1),
    );

    blocTest<TimerBloc, TimerState>(
      'emits [TickerRunPause(2)] when ticker is paused at 2',
      build: () => TimerBloc(ticker: ticker),
      seed: () => const RunInProgress(2),
      act: (bloc) => bloc.add(const Paused()),
      expect: () => [const RunPause(2)],
    );

    blocTest<TimerBloc, TimerState>(
      'emits [TickerRunInProgress(5)] when ticker is resumed at 5',
      build: () => TimerBloc(ticker: ticker),
      seed: () => const RunPause(5),
      act: (bloc) => bloc.add(const Resumed()),
      expect: () => [const RunInProgress(5)],
    );

    blocTest<TimerBloc, TimerState>(
      'emits [TickerInitial(60)] when timer is restarted',
      build: () => TimerBloc(ticker: ticker),
      act: (bloc) => bloc.add(const Reset()),
      expect: () => [const Initial(60)],
    );

    blocTest<TimerBloc, TimerState>(
      'emits [TimerRunInProgress(3)] when timer ticks to 3',
      setUp: () {
        when(() => ticker.tick(ticks: 3)).thenAnswer(
          (_) => Stream<int>.value(3),
        );
      },
      build: () => TimerBloc(ticker: ticker),
      act: (bloc) => bloc.add(const Started(duration: 3)),
      expect: () => [const RunInProgress(3)],
    );

    blocTest<TimerBloc, TimerState>(
      'emits [TimerRunInProgress(1), TimerRunComplete()] when timer ticks to 0',
      setUp: () {
        when(() => ticker.tick(ticks: 1)).thenAnswer(
          (_) => Stream<int>.fromIterable([1, 0]),
        );
      },
      build: () => TimerBloc(ticker: ticker),
      act: (bloc) => bloc.add(const Started(duration: 1)),
      expect: () => [const RunInProgress(1), const RunComplete()],
    );
  });
}
