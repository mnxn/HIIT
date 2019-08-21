import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NumberInput extends StatefulWidget {
  NumberInput({
    Key key,
    @required this.context,
    @required this.title,
    @required this.onConfirm,
    @required this.value,
    @required this.accentColor,
    @required this.backgroundColor,
  }) : super(key: key);

  final BuildContext context;
  final String title;
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
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Text(widget.title, textScaleFactor: 1.15),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
          child: OutlineButton(
            child: Text("${widget.value}", textScaleFactor: 1.1, style: TextStyle(fontFamily: "monospace")),
            borderSide: BorderSide(color: widget.accentColor, width: 1),
            onPressed: () => showDialog(
              context: widget.context,
              builder: (context) => NumberPicker(
                title: Text(widget.title, style: TextStyle(color: widget.accentColor)),
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
  NumberPicker({
    @required this.title,
    this.initialValue = 0,
    this.backgroundColor = CupertinoColors.white,
    this.accentColor = CupertinoColors.black,
    @required this.onConfirm,
  });

  final Widget title;
  final int initialValue;
  final ValueChanged<int> onConfirm;
  final Color backgroundColor;
  final Color accentColor;

  @override
  State<StatefulWidget> createState() => NumberPickerState();
}

class NumberPickerState extends State<NumberPicker> {
  int textDirectionFactor;
  CupertinoLocalizations localizations;

  int selectedValue;

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
      style: TextStyle(fontWeight: FontWeight.w600, color: widget.accentColor),
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
                style: TextStyle(color: widget.accentColor),
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
              child: buildLabel("Sets"),
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
        shape: Border.fromBorderSide(BorderSide(color: widget.accentColor, width: 2)),
        contentPadding: EdgeInsets.all(0),
        actions: [
          FlatButton(
            child: Text("Cancel", style: TextStyle(color: widget.accentColor)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("Confirm", style: TextStyle(color: widget.accentColor)),
            onPressed: () {
              Navigator.pop(context);
              widget.onConfirm(selectedValue);
            },
          ),
        ],
        content: Container(
          height: MediaQuery.of(context).size.height / 4,
          child: Row(
            children: [
              Expanded(child: buildValueColumn()),
            ],
          ),
        ));
  }
}
