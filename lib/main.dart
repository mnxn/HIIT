import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mhiit/theme.dart';
import 'package:mhiit/hiit.dart';

void main() {
  runApp(MaterialApp(
    title: 'HIIT Timer',
    theme: AppTheme.dark(),
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  HIITTimer timer;

  Color timerColor() {
    switch (timer.current.kind) {
      case IntervalKind.WarmUp:
      case IntervalKind.CoolDown:
        return AppTheme.coolDownColor;
      case IntervalKind.Work:
        return AppTheme.intermediateColor;
      case IntervalKind.Rest:
        return AppTheme.restColor;
      default:
        return AppTheme.defaultColor;
    }
  }

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, value: 0);
    _controller.addListener(() => setState(() {}));

    timer = HIITTimer((double value) {
      if (value > _controller.value) _controller.value = 1;

      _controller.animateTo(value, duration: Duration(seconds: 1));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: timerColor(),
      appBar: AppBar(title: Text(timer.titleText), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(timer.repText, style: Theme.of(context).textTheme.display1),
                      Text(timer.current.remainingText, style: Theme.of(context).textTheme.display4),
                      Text(timer.subtext, style: Theme.of(context).textTheme.display2),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                  child: CircularProgressIndicator(
                    value: _controller.value,
                    backgroundColor: Color.lerp(
                      Theme.of(context).primaryColor,
                      Theme.of(context).accentColor,
                      0.25,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(timer.isRunning ? Icons.pause : Icons.play_arrow),
        shape: StadiumBorder(side: BorderSide(width: 3)),
        tooltip: timer.isRunning ? "Pause" : "Play",
        onPressed: () => setState(timer.playpause),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.settings),
              tooltip: "Settings",
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.replay),
              tooltip: "Restart",
              onPressed: () => setState(timer.restart),
            ),
          ],
        ),
      ),
    );
  }
}
