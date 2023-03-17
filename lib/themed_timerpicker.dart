import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hiit/theme.dart';

String pad(int n) {
  return n.remainder(60).toString().padLeft(2, "0");
}

class TimerInput extends StatefulWidget {
  const TimerInput({
    Key? key,
    required this.title,
    required this.onConfirm,
    required this.value,
  }) : super(key: key);

  final String title;
  final void Function(Duration) onConfirm;
  final Duration value;

  @override
  TimerInputState createState() => TimerInputState();
}

class TimerInputState extends State<TimerInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Text(widget.title, textScaleFactor: 1.15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
            child: SizedBox(
              width: 80,
              child: OutlinedButton(
                child: Text(
                  "${pad(widget.value.inMinutes)}:${pad(widget.value.inSeconds)}",
                  textScaleFactor: 1.1,
                  style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
                ),
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1)),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ThemedTimerPicker(
                    title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                    initialTimerDuration: widget.value,
                    onConfirm: widget.onConfirm,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThemedTimerPicker extends StatefulWidget {
  const ThemedTimerPicker({
    Key? key,
    required this.title,
    this.initialTimerDuration = Duration.zero,
    required this.onConfirm,
  }) : super(key: key);

  final Widget title;
  final Duration initialTimerDuration;
  final ValueChanged<Duration> onConfirm;

  @override
  State<StatefulWidget> createState() => ThemedTimerPickerState();
}

class ThemedTimerPickerState extends State<ThemedTimerPicker> {
  late Duration currentDuration;

  @override
  void initState() {
    super.initState();
    currentDuration = widget.initialTimerDuration;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
        borderRadius: BorderRadius.circular(7),
      ),
      contentPadding: const EdgeInsets.all(0),
      actions: [
        TextButton(
          child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("Confirm", style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          onPressed: () {
            Navigator.pop(context);
            widget.onConfirm(currentDuration);
          },
        ),
      ],
      content: SizedBox(
        width: MediaQuery.of(context).size.shortestSide * 0.5,
        height: MediaQuery.of(context).size.shortestSide * 0.6,
        child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                pickerTextStyle:
                    CupertinoTheme.of(context).textTheme.pickerTextStyle.copyWith(fontFamily: defaultFont()),
              ),
            ),
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.ms,
              minuteInterval: 1,
              secondInterval: 5,
              initialTimerDuration: widget.initialTimerDuration,
              onTimerDurationChanged: (Duration d) {
                currentDuration = d;
              },
            )),
      ),
    );
  }
}
