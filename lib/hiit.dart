import 'dart:async';
import 'dart:collection';

enum IntervalKind { Setup, WarmUp, Work, Rest, CoolDown, Done }

class HIITInterval {
  final IntervalKind kind;
  final Duration total;
  Duration remaining;

  HIITInterval(this.kind, int duration)
      : total = Duration(seconds: duration),
        remaining = Duration(seconds: duration);

  factory HIITInterval.setup() => HIITInterval(IntervalKind.Setup, 0);
  factory HIITInterval.warmUp(int duration) => HIITInterval(IntervalKind.WarmUp, duration);
  factory HIITInterval.work(int duration) => HIITInterval(IntervalKind.Work, duration);
  factory HIITInterval.rest(int duration) => HIITInterval(IntervalKind.Rest, duration);
  factory HIITInterval.coolDown(int duration) => HIITInterval(IntervalKind.CoolDown, duration);
  factory HIITInterval.done() => HIITInterval(IntervalKind.Done, 0);

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
  int currentRep = 1;

  Function(double) progressTo;

  int warmUpTime;
  int workTime;
  int restTime;
  int coolDownTime;
  int totalReps;

  HIITTimer(
    this.progressTo, {
    this.warmUpTime = 120,
    this.workTime = 30,
    this.restTime = 90,
    this.coolDownTime = 120,
    this.totalReps = 8,
  }) {
    setupIntervals();
    Timer.periodic(Duration(seconds: 1), (t) {
      if (isRunning) {
        if (current.kind == IntervalKind.Done) {
          isRunning = false;
          progressTo(1);
          return;
        }

        if (current.kind == IntervalKind.Rest && current.remaining.inSeconds == 1) currentRep++;

        elapsed += Duration(seconds: 1);
        intervals.first.remaining -= Duration(seconds: 1);
        if (intervals.first.remaining.inSeconds <= 0) intervals.removeFirst();
        if (current.kind == IntervalKind.Done) isRunning = false;

        progressTo(current.percent);
      }
    });
  }

  void setupIntervals() {
    intervals = ListQueue();
    intervals.add(HIITInterval.setup());
    intervals.add(HIITInterval.warmUp(warmUpTime));
    for (var i = 0; i < totalReps; i++) {
      intervals.add(HIITInterval.work(workTime));
      intervals.add(HIITInterval.rest(restTime));
    }
    intervals.add(HIITInterval.coolDown(coolDownTime));
    intervals.add(HIITInterval.done());
  }

  void playpause() {
    if (current.kind != IntervalKind.Done) isRunning = !isRunning;
  }

  void restart() {
    isRunning = false;
    setupIntervals();
    elapsed = Duration();
    currentRep = 1;
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

  String get repText {
    switch (current.kind) {
      case IntervalKind.Work:
      case IntervalKind.Rest:
        return "$currentRep/$totalReps";
      default:
        return "";
    }
  }
}

String pad(int n) {
  return n.remainder(60).toString().padLeft(2, "0");
}

String padMilli(int n) {
  return n.remainder(1000).toString().padLeft(4, "0");
}
