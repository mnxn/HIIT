import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';

enum IntervalKind { Setup, WarmUp, Work, Rest, CoolDown, Done }

class HIITInterval {
  final IntervalKind kind;
  final Duration total;
  Duration remaining;

  HIITInterval(this.kind, Duration duration)
      : total = duration,
        remaining = duration;

  factory HIITInterval.setup() => HIITInterval(IntervalKind.Setup, Duration());
  factory HIITInterval.warmUp(Duration duration) => HIITInterval(IntervalKind.WarmUp, duration);
  factory HIITInterval.work(Duration duration) => HIITInterval(IntervalKind.Work, duration);
  factory HIITInterval.rest(Duration duration) => HIITInterval(IntervalKind.Rest, duration);
  factory HIITInterval.coolDown(Duration duration) => HIITInterval(IntervalKind.CoolDown, duration);
  factory HIITInterval.done() => HIITInterval(IntervalKind.Done, Duration());

  double get percent {
    switch (kind) {
      case IntervalKind.WarmUp:
      case IntervalKind.Work:
      case IntervalKind.Rest:
      case IntervalKind.CoolDown:
        return (remaining.inSeconds - 1) / total.inSeconds;
      default:
        return 0;
    }
  }

  String get remainingText => "${pad(remaining.inMinutes)}:${pad(remaining.inSeconds)}";
}

class HIITTimer {
  bool isRunning = false;
  ListQueue<HIITInterval> intervals;
  Duration elapsed = Duration();
  int elapsedSets = 0;

  Function(double) progressTo;

  Duration warmUpTime;
  Duration workTime;
  Duration restTime;
  Duration coolDownTime;
  int sets;

  HIITTimer(
    this.progressTo, {
    @required this.warmUpTime,
    @required this.workTime,
    @required this.restTime,
    @required this.coolDownTime,
    @required this.sets,
  }) {
    intervals = setupIntervals();
    Timer.periodic(Duration(seconds: 1), (t) {
      if (isRunning) {
        if (current.kind == IntervalKind.Done) {
          isRunning = false;
          progressTo(1);
          return;
        }

        if (current.kind != IntervalKind.Setup) elapsed += Duration(seconds: 1);
        intervals.first.remaining -= Duration(seconds: 1);

        while (current.kind != IntervalKind.Done && current.remaining.inSeconds <= 0) {
          intervals.removeFirst();
          if (current.kind == IntervalKind.Work && current.remaining == current.total) elapsedSets++;
        }

        if (current.kind == IntervalKind.Done) isRunning = false;
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
    if (current.kind != IntervalKind.Done) isRunning = !isRunning;
  }

  void restart() {
    isRunning = false;
    intervals = setupIntervals();
    elapsed = Duration();
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
      case IntervalKind.Setup:
        return "Press Start";
      case IntervalKind.WarmUp:
        return "Warm Up";
      case IntervalKind.Work:
        return "Work";
      case IntervalKind.Rest:
        return "Rest";
      case IntervalKind.CoolDown:
        return "Cool Down";
      case IntervalKind.Done:
        return "Done";
      default:
        return null;
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
