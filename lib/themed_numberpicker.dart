import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hiit/theme.dart';

class NumberInput extends StatefulWidget {
  const NumberInput({
    Key? key,
    required this.title,
    required this.singleLabel,
    required this.pluralLabel,
    required this.onConfirm,
    required this.value,
  }) : super(key: key);

  final String title;
  final String singleLabel;
  final String pluralLabel;
  final void Function(int) onConfirm;
  final int value;

  @override
  NumberInputState createState() => NumberInputState();
}

class NumberInputState extends State<NumberInput> {
  @override
  Widget build(BuildContext context) {
    var c = context;
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
          child: SizedBox(
            width: 80,
            child: OutlinedButton(
              style:
                  OutlinedButton.styleFrom(side: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1)),
              onPressed: () {
                HapticFeedback.lightImpact();
                showDialog(
                  context: context,
                  builder: (context) {
                    return Theme(
                      data: Theme.of(c),
                      child: NumberPicker(
                        title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                        singleLabel: widget.singleLabel,
                        pluralLabel: widget.pluralLabel,
                        initialValue: widget.value,
                        onConfirm: widget.onConfirm,
                      ),
                    );
                  },
                );
              },
              child: Text(
                widget.value.toString(),
                textScaleFactor: 1.1,
                style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NumberPicker extends StatefulWidget {
  const NumberPicker({
    Key? key,
    required this.title,
    required this.singleLabel,
    required this.pluralLabel,
    this.initialValue = 0,
    required this.onConfirm,
  }) : super(key: key);

  final Widget title;
  final String singleLabel;
  final String pluralLabel;
  final int initialValue;
  final ValueChanged<int> onConfirm;

  @override
  State<StatefulWidget> createState() => NumberPickerState();
}

class NumberPickerState extends State<NumberPicker> {
  late int textDirectionFactor;
  late CupertinoLocalizations localizations;

  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textDirectionFactor = Directionality.of(context) == TextDirection.ltr ? 1 : -1;
    localizations = CupertinoLocalizations.of(context);
  }

  Widget buildValuePicker() {
    double offAxisFraction = -0.5 * textDirectionFactor;

    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: selectedValue,
      ),
      offAxisFraction: offAxisFraction,
      itemExtent: 32,
      squeeze: 1.25,
      onSelectedItemChanged: (int index) {
        setState(() => selectedValue = index);
      },
      children: List<Widget>.generate(100, (int value) {
        return Semantics(
          excludeSemantics: true,
          child: Container(
            alignment: Alignment.centerRight,
            padding:
                textDirectionFactor == 1 ? const EdgeInsets.only(right: 330 / 4) : const EdgeInsets.only(left: 330 / 4),
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text(
                value.toString(),
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildValueColumn() {
    return Stack(
      children: [
        buildValuePicker(),
        IgnorePointer(
          child: Container(
            alignment: Alignment.centerRight,
            child: Container(
              alignment: Alignment.center,
              width: 330 / 4,
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text(
                selectedValue == 1 ? widget.singleLabel : widget.pluralLabel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
        borderRadius: BorderRadius.circular(7),
      ),
      contentPadding: const EdgeInsets.only(left: 50, right: 50),
      actions: [
        TextButton(
          child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("Confirm", style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
            widget.onConfirm(selectedValue);
          },
        ),
      ],
      content: SizedBox(
        width: MediaQuery.of(context).size.shortestSide * 0.2,
        height: MediaQuery.of(context).size.shortestSide * 0.6,
        child: buildValueColumn(),
      ),
    );
  }
}
