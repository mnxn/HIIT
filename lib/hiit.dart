import 'dart:async';
import 'dart:collection';

import 'package:wakelock/wakelock.dart';

enum IntervalKind { setup, warmUp, work, rest, coolDown, done }

class HIITInterval {
  final IntervalKind kind;
  final Duration total;
  Duration remaining;

  HIITInterval(this.kind, this.total) : remaining = total;

  factory HIITInterval.setup() => HIITInterval(IntervalKind.setup, const Duration());
  factory HIITInterval.warmUp(Duration duration) => HIITInterval(IntervalKind.warmUp, duration);
  factory HIITInterval.work(Duration duration) => HIITInterval(IntervalKind.work, duration);
  factory HIITInterval.rest(Duration duration) => HIITInterval(IntervalKind.rest, duration);
  factory HIITInterval.coolDown(Duration duration) => HIITInterval(IntervalKind.coolDown, duration);
  factory HIITInterval.done() => HIITInterval(IntervalKind.done, const Duration());

  double get percent {
    switch (kind) {
      case IntervalKind.warmUp:
      case IntervalKind.work:
      case IntervalKind.rest:
      case IntervalKind.coolDown:
        return (remaining.inSeconds - 1) / total.inSeconds;
      case IntervalKind.setup:
      case IntervalKind.done:
        return 0;
    }
  }

  String get remainingText => "${pad(remaining.inMinutes)}:${pad(remaining.inSeconds)}";
}

class HIITTimer {
  bool isRunning = false;
  late ListQueue<HIITInterval> intervals;
  Duration elapsed = const Duration();
  int elapsedSets = 0;

  Function(double) progressTo;

  Duration warmUpTime;
  Duration workTime;
  Duration restTime;
  Duration coolDownTime;
  int sets;

  HIITTimer(
    this.progressTo, {
    required this.warmUpTime,
    required this.workTime,
    required this.restTime,
    required this.coolDownTime,
    required this.sets,
  }) {
    intervals = setupIntervals();
    Timer.periodic(const Duration(seconds: 1), (t) {
      if (isRunning) {
        if (current.kind == IntervalKind.done) {
          isRunning = false;
          progressTo(1);
          return;
        }

        if (current.kind != IntervalKind.setup) elapsed += const Duration(seconds: 1);
        intervals.first.remaining -= const Duration(seconds: 1);

        while (current.kind != IntervalKind.done && current.remaining.inSeconds <= 0) {
          intervals.removeFirst();
          if (current.kind == IntervalKind.work && current.remaining == current.total) elapsedSets++;
        }

        if (current.kind == IntervalKind.done) isRunning = false;
        progressTo(current.percent);
      }
    });
  }

  ListQueue<HIITInterval> setupIntervals() {
    ListQueue<HIITInterval> queue = ListQueue();
    queue.add(HIITInterval.setup());
    queue.add(HIITInterval.warmUp(warmUpTime));
    for (var i = 0; i < sets; i++) {
      queue.add(HIITInterval.work(workTime));
      queue.add(HIITInterval.rest(restTime));
    }
    queue.add(HIITInterval.coolDown(coolDownTime));
    queue.add(HIITInterval.done());
    return queue;
  }

  void playpause() {
    if (current.kind != IntervalKind.done) isRunning = !isRunning;
    Wakelock.toggle(enable: isRunning);
  }

  void restart() {
    isRunning = false;
    intervals = setupIntervals();
    elapsed = const Duration();
    elapsedSets = 0;
    progressTo(1);
  }

  HIITInterval get current => intervals.first;

  String get titleText {
    var h = pad(elapsed.inHours);
    var m = pad(elapsed.inMinutes);
    var s = pad(elapsed.inSeconds);
    return "$h:$m:$s";
  }

  String get subtext {
    switch (current.kind) {
      case IntervalKind.setup:
        return "Press Start";
      case IntervalKind.warmUp:
        return "Warm Up";
      case IntervalKind.work:
        return "Work";
      case IntervalKind.rest:
        return "Rest";
      case IntervalKind.coolDown:
        return "Cool Down";
      case IntervalKind.done:
        return "Done";
    }
  }

  String get repText => "$elapsedSets/$sets";
}

String pad(int n) {
  return n.remainder(60).toString().padLeft(2, "0");
}

String padMilli(int n) {
  return n.remainder(1000).toString().padLeft(4, "0");
}

class HIITDefault {
  static const int warmup = 120;
  static const int work = 30;
  static const int rest = 90;
  static const int cooldown = 120;
  static const int sets = 8;
}
