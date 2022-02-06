import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hiit/theme.dart';

String padCenter(int value) {
  String str = value.toString();
  switch (str.length) {
    case 1:
      return "  $str  ";
    case 2:
      return " $str  ";
    default:
      return str;
  }
}

class NumberInput extends StatefulWidget {
  const NumberInput({
    Key? key,
    required this.title,
    required this.label,
    required this.onConfirm,
    required this.value,
    required this.accentColor,
    required this.backgroundColor,
  }) : super(key: key);

  final String title;
  final String label;
  final void Function(int) onConfirm;
  final int value;
  final Color accentColor;
  final Color backgroundColor;

  @override
  NumberInputState createState() => NumberInputState();
}

class NumberInputState extends State<NumberInput> {
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
              padCenter(widget.value),
              textScaleFactor: 1.1,
              style: const TextStyle(fontFamily: "monospace"),
            ),
            style: OutlinedButton.styleFrom(side: BorderSide(color: widget.accentColor, width: 1)),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => NumberPicker(
                title: Text(widget.title, style: TextStyle(color: widget.accentColor)),
                label: widget.label,
                backgroundColor: widget.backgroundColor,
                accentColor: widget.accentColor,
                initialValue: widget.value,
                onConfirm: widget.onConfirm,
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
    required this.label,
    this.initialValue = 0,
    this.backgroundColor = CupertinoColors.white,
    this.accentColor = CupertinoColors.black,
    required this.onConfirm,
  }) : super(key: key);

  final Widget title;
  final String label;
  final int initialValue;
  final ValueChanged<int> onConfirm;
  final Color backgroundColor;
  final Color accentColor;

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

  // Builds a text label with customized scale factor and font weight.
  Widget buildLabel(String text) {
    return Text(
      text,
      textScaleFactor: 0.9,
      style: TextStyle(color: widget.accentColor, fontWeight: FontWeight.w600),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textDirectionFactor = Directionality.of(context) == TextDirection.ltr ? 1 : -1;
    localizations = CupertinoLocalizations.of(context);
  }

  Widget buildValuePicker() {
    double offAxisFraction;
    offAxisFraction = -0.5 * textDirectionFactor;

    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: selectedValue,
      ),
      offAxisFraction: offAxisFraction,
      itemExtent: 32,
      backgroundColor: widget.backgroundColor,
      squeeze: 1.25,
      onSelectedItemChanged: (int index) {
        setState(() => selectedValue = index);
      },
      children: List<Widget>.generate(100, (int value) {
        return Semantics(
          excludeSemantics: true,
          child: Container(
            alignment: Alignment.center,
            padding:
                textDirectionFactor == 1 ? const EdgeInsets.only(right: 330 / 4) : const EdgeInsets.only(left: 330 / 4),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text(
                value.toString(),
                style: TextStyle(color: widget.accentColor, fontFamily: defaultFont()),
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
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.centerRight,
              width: 330 / 4,
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: buildLabel(widget.label),
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
        contentPadding: const EdgeInsets.only(left: 50, right: 50),
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
              widget.onConfirm(selectedValue);
            },
          ),
        ],
        content: SizedBox(
          height: MediaQuery.of(context).size.height / 4,
          child: buildValueColumn(),
        ));
  }
}
