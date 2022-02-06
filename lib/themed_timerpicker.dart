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
    required this.accentColor,
    required this.backgroundColor,
  }) : super(key: key);

  final String title;
  final void Function(Duration) onConfirm;
  final Duration value;
  final Color accentColor;
  final Color backgroundColor;

  @override
  TimerInputState createState() => TimerInputState();
}

class TimerInputState extends State<TimerInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
          child: OutlinedButton(
            child: Text(
              "${pad(widget.value.inMinutes)}:${pad(widget.value.inSeconds)}",
              textScaleFactor: 1.1,
              style: const TextStyle(fontFamily: "monospace"),
            ),
            style: OutlinedButton.styleFrom(side: BorderSide(color: widget.accentColor, width: 1)),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ThemedTimerPicker(
                title: Text(widget.title, style: TextStyle(color: widget.accentColor)),
                backgroundColor: widget.backgroundColor,
                accentColor: widget.accentColor,
                initialTimerDuration: widget.value,
                onConfirm: widget.onConfirm,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ThemedTimerPicker extends StatefulWidget {
  const ThemedTimerPicker({
    Key? key,
    required this.title,
    this.initialTimerDuration = Duration.zero,
    this.backgroundColor = CupertinoColors.white,
    this.accentColor = CupertinoColors.black,
    required this.onConfirm,
  }) : super(key: key);

  final Widget title;
  final Duration initialTimerDuration;
  final ValueChanged<Duration> onConfirm;
  final Color backgroundColor;
  final Color accentColor;

  @override
  State<StatefulWidget> createState() => ThemedTimerPickerState();
}

class ThemedTimerPickerState extends State<ThemedTimerPicker> {
  late int textDirectionFactor;
  late CupertinoLocalizations localizations;

  late int selectedMinute;
  late int selectedSecond;

  @override
  void initState() {
    super.initState();
    selectedMinute = widget.initialTimerDuration.inMinutes % 60;
    selectedSecond = widget.initialTimerDuration.inSeconds % 60;
  }

  // Builds a text label with customized scale factor and font weight.
  Widget buildLabel(String? text) {
    return Text(
      text ?? "",
      textScaleFactor: 0.9,
      style: TextStyle(fontWeight: FontWeight.w600, color: widget.accentColor),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textDirectionFactor = Directionality.of(context) == TextDirection.ltr ? 1 : -1;
    localizations = CupertinoLocalizations.of(context);
  }

  Widget buildMinutePicker() {
    double offAxisFraction = -0.5 * textDirectionFactor;

    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: selectedMinute,
      ),
      offAxisFraction: offAxisFraction,
      itemExtent: 32,
      backgroundColor: widget.backgroundColor,
      squeeze: 1.25,
      onSelectedItemChanged: (int index) {
        setState(() => selectedMinute = index);
      },
      children: List<Widget>.generate(60, (int index) {
        final int minute = index;

        final String semanticsLabel = textDirectionFactor == 1
            ? localizations.timerPickerMinute(minute) + (localizations.timerPickerMinuteLabel(minute) ?? "")
            : (localizations.timerPickerMinuteLabel(minute) ?? "") + localizations.timerPickerMinute(minute);

        return Semantics(
          label: semanticsLabel,
          excludeSemantics: true,
          child: Container(
            alignment: Alignment.centerRight,
            padding:
                textDirectionFactor == 1 ? const EdgeInsets.only(right: 330 / 4) : const EdgeInsets.only(left: 330 / 4),
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text(
                localizations.timerPickerMinute(minute),
                style: TextStyle(color: widget.accentColor, fontFamily: defaultFont()),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildMinuteColumn() {
    return Stack(
      children: [
        buildMinutePicker(),
        IgnorePointer(
          child: Container(
            alignment: Alignment.centerRight,
            child: Container(
              alignment: Alignment.centerLeft,
              width: 330 / 4,
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: buildLabel(localizations.timerPickerMinuteLabel(selectedMinute)),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSecondPicker() {
    double offAxisFraction = -0.5 * textDirectionFactor;

    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: selectedSecond ~/ 5,
      ),
      offAxisFraction: offAxisFraction,
      itemExtent: 32,
      backgroundColor: widget.backgroundColor,
      squeeze: 1.25,
      onSelectedItemChanged: (int index) {
        setState(() => selectedSecond = index * 5);
      },
      children: List<Widget>.generate(12, (int index) {
        final int second = index * 5;

        final String semanticsLabel = textDirectionFactor == 1
            ? localizations.timerPickerSecond(second) + (localizations.timerPickerSecondLabel(second) ?? "")
            : (localizations.timerPickerSecondLabel(second) ?? "") + localizations.timerPickerSecond(second);

        return Semantics(
          label: semanticsLabel,
          excludeSemantics: true,
          child: Container(
            alignment: Alignment.centerRight,
            padding:
                textDirectionFactor == 1 ? const EdgeInsets.only(right: 330 / 4) : const EdgeInsets.only(left: 330 / 4),
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text(
                localizations.timerPickerSecond(second),
                style: TextStyle(color: widget.accentColor, fontFamily: defaultFont()),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildSecondColumn() {
    return Stack(
      children: [
        buildSecondPicker(),
        IgnorePointer(
          child: Container(
            alignment: Alignment.centerRight,
            child: Container(
              alignment: Alignment.centerLeft,
              width: 330 / 4,
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: buildLabel(localizations.timerPickerSecondLabel(selectedSecond)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: widget.title,
        backgroundColor: widget.backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: widget.accentColor, width: 1),
          borderRadius: BorderRadius.circular(7),
        ),
        contentPadding: const EdgeInsets.all(0),
        actions: [
          TextButton(
            child: Text("Cancel", style: TextStyle(color: widget.accentColor)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text("Confirm", style: TextStyle(color: widget.accentColor)),
            onPressed: () {
              Navigator.pop(context);
              widget.onConfirm(Duration(minutes: selectedMinute, seconds: selectedSecond));
            },
          ),
        ],
        content: SizedBox(
          height: MediaQuery.of(context).size.height / 4,
          child: Row(
            children: [
              Expanded(child: buildMinuteColumn()),
              Expanded(child: buildSecondColumn()),
            ],
          ),
        ));
  }
}
