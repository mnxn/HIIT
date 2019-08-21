import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mhiit/theme.dart';
import 'package:mhiit/hiit.dart';
import 'package:mhiit/themed_timerpicker.dart';
import 'package:mhiit/themed_numberpicker.dart';

SharedPreferences preferences;

void main() async {
  preferences = await SharedPreferences.getInstance();
  runApp(MaterialApp(title: 'HIIT Timer', home: Home()));
}

class Default {
  static final bool darkmode = false;
  static final int warmup = 120;
  static final int work = 30;
  static final int rest = 90;
  static final int cooldown = 120;
  static final int sets = 8;
}

ThemeData theme() {
  return (preferences.getBool("darkmode") ?? Default.darkmode) ? AppTheme.dark() : AppTheme.light();
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  HIITTimer timer;
  AnimationController _controller;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Color timerColor() {
    switch (timer.current.kind) {
      case IntervalKind.WarmUp:
      case IntervalKind.CoolDown:
        return AppTheme.coolDownColor;
      case IntervalKind.Work:
        return AppTheme.workColor;
      case IntervalKind.Rest:
        return AppTheme.restColor;
      default:
        return AppTheme.defaultColor;
    }
  }

  void _do<T>(Future<T> future) {
    setState(() {
      future.then((_) {});
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, value: 1);
    _controller.addListener(() => setState(() {}));

    timer = HIITTimer(
      (double value) {
        if (value > _controller.value) _controller.value = 1;

        _controller.animateTo(value, duration: Duration(seconds: 1));
        setState(() {});
      },
      warmUpTime: Duration(seconds: preferences.getInt("warmup") ?? Default.warmup),
      workTime: Duration(seconds: preferences.getInt("work") ?? Default.work),
      restTime: Duration(seconds: preferences.getInt("rest") ?? Default.rest),
      coolDownTime: Duration(seconds: preferences.getInt("cooldown") ?? Default.cooldown),
      sets: preferences.getInt("sets") ?? 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: timerColor(),
        appBar: AppBar(
          title: Text(timer.titleText),
          centerTitle: true,
          leading: Container(), // hide drawer hamburger menu
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(color: theme().primaryColor, shape: BoxShape.circle),
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.width * 0.85,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(timer.repText, style: theme().textTheme.display2),
                        Text(timer.current.remainingText, style: theme().textTheme.display4),
                        Text(timer.subtext, style: theme().textTheme.display2),
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
                        theme().primaryColor,
                        theme().accentColor,
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
          shape: StadiumBorder(side: BorderSide(color: theme().primaryColor, width: 3)),
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
                onPressed: () {
                  scaffoldKey.currentState.openDrawer();
                  timer.isRunning = false;
                },
              ),
              IconButton(
                icon: Icon(Icons.replay),
                tooltip: "Restart",
                onPressed: () => setState(timer.restart),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              color: theme().primaryColor,
              border: Border(right: BorderSide(color: theme().accentColor, width: 2)),
            ),
            child: ListView(
              children: [
                Container(
                  color: theme().accentColor,
                  padding: EdgeInsets.all(25),
                  child: ListTile(
                    leading: Icon(Icons.settings, color: theme().primaryColor),
                    title: Text('Settings', textScaleFactor: 1.5, style: TextStyle(color: theme().primaryColor)),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.style),
                  title: Text('Theme', textScaleFactor: 1.25),
                ),
                RadioListTile(
                  title: Text("Light Theme"),
                  groupValue: false,
                  value: preferences.getBool("darkmode") ?? Default.darkmode,
                  onChanged: (_) => _do(preferences.setBool("darkmode", false)),
                ),
                RadioListTile(
                  title: Text("Dark Theme"),
                  groupValue: true,
                  value: preferences.getBool("darkmode") ?? Default.darkmode,
                  onChanged: (_) => _do(preferences.setBool("darkmode", true)),
                ),
                Divider(color: theme().accentColor),
                ListTile(
                  leading: Icon(Icons.timer),
                  title: Text('Timer', textScaleFactor: 1.25),
                ),
                TimerInput(
                  context: context,
                  title: "Warm-Up Time",
                  backgroundColor: theme().primaryColor,
                  accentColor: theme().accentColor,
                  value: Duration(seconds: preferences.getInt("warmup") ?? Default.warmup),
                  onConfirm: (duration) {
                    _do(preferences.setInt("warmup", duration.inSeconds));
                    timer.warmUpTime = duration;
                    timer.restart();
                  },
                ),
                TimerInput(
                  context: context,
                  title: "Work Time",
                  backgroundColor: theme().primaryColor,
                  accentColor: theme().accentColor,
                  value: Duration(seconds: preferences.getInt("work") ?? Default.work),
                  onConfirm: (duration) {
                    _do(preferences.setInt("work", duration.inSeconds));
                    timer.workTime = duration;
                    timer.restart();
                  },
                ),
                TimerInput(
                  context: context,
                  title: "Rest Time",
                  backgroundColor: theme().primaryColor,
                  accentColor: theme().accentColor,
                  value: Duration(seconds: preferences.getInt("rest") ?? Default.rest),
                  onConfirm: (duration) {
                    _do(preferences.setInt("rest", duration.inSeconds));
                    timer.restTime = duration;
                    timer.restart();
                  },
                ),
                TimerInput(
                  context: context,
                  title: "Cool-Down Time",
                  backgroundColor: theme().primaryColor,
                  accentColor: theme().accentColor,
                  value: Duration(seconds: preferences.getInt("cooldown") ?? Default.cooldown),
                  onConfirm: (duration) {
                    _do(preferences.setInt("cooldown", duration.inSeconds));
                    timer.coolDownTime = duration;
                    timer.restart();
                  },
                ),
                NumberInput(
                  context: context,
                  title: "Number of Sets",
                  backgroundColor: theme().primaryColor,
                  accentColor: theme().accentColor,
                  value: preferences.getInt("sets") ?? Default.sets,
                  onConfirm: (value) {
                    _do(preferences.setInt("sets", value));
                    timer.sets = value;
                    timer.restart();
                  },
                ),
                Divider(color: theme().accentColor),
                Center(
                  child: OutlineButton(
                    borderSide: BorderSide(color: theme().accentColor, width: 1),
                    child: Text("Default Settings"),
                    onPressed: () {
                      _do(preferences.setBool("darkmode", Default.darkmode));
                      _do(preferences.setInt("warmup", Default.warmup));
                      _do(preferences.setInt("work", Default.work));
                      _do(preferences.setInt("rest", Default.rest));
                      _do(preferences.setInt("cooldown", Default.cooldown));
                      _do(preferences.setInt("sets", Default.sets));
                      timer.warmUpTime = Duration(seconds: Default.warmup);
                      timer.workTime = Duration(seconds: Default.work);
                      timer.restTime = Duration(seconds: Default.rest);
                      timer.coolDownTime = Duration(seconds: Default.cooldown);
                      timer.sets = Default.sets;
                      timer.restart();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
