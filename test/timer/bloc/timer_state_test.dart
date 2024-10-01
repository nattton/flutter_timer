import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_timer/timer/timer.dart';

void main() {
  group('TimerState', () {
    group('Initial', () {
      test('supports value comparison', () {
        expect(
          const Initial(60),
          const Initial(60),
        );
      });
    });
    group('TimerRunPause', () {
      test('supports value comparison', () {
        expect(
          const RunPause(60),
          const RunPause(60),
        );
      });
    });
    group('RunInProgress', () {
      test('supports value comparison', () {
        expect(
          const RunInProgress(60),
          const RunInProgress(60),
        );
      });
    });
    group('RunComplete', () {
      test('supports value comparison', () {
        expect(
          const RunComplete(),
          const RunComplete(),
        );
      });
    });
  });
}
