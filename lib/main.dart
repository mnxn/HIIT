import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:mhiit/theme.dart';
import 'package:mhiit/hiit.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences preferences;

bool useDarkThemePref;
int numRepsPref;

void main() async {
  preferences = await SharedPreferences.getInstance();

  useDarkThemePref = await defaultBoolPref("darktheme", false);
  numRepsPref = await defaultIntPref("numreps", 8);

  runApp(MaterialApp(title: 'HIIT Timer', home: Home()));
}

Future<bool> defaultBoolPref(String key, bool defaultVal) async {
  bool val = preferences.getBool(key);
  if (val == null) {
    await preferences.setBool(key, defaultVal);
    return defaultVal;
  }
  return val;
}

Future<int> defaultIntPref(String key, int defaultVal) async {
  int val = preferences.getInt(key);
  if (val == null) {
    await preferences.setInt(key, defaultVal);
    return defaultVal;
  }
  return val;
}

theme() {
  return useDarkThemePref ? AppTheme.dark() : AppTheme.light();
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  HIITTimer timer;
  AnimationController _controller;

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

  void setDarkMode(bool useDarkTheme) {
    setState(() {
      useDarkThemePref = useDarkTheme;
      preferences.setBool("darktheme", useDarkTheme).then((_) {});
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, value: 1);
    _controller.addListener(() => setState(() {}));

    timer = HIITTimer((double value) {
      if (value > _controller.value) _controller.value = 1;

      _controller.animateTo(value, duration: Duration(seconds: 1));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: theme(),
        child: Scaffold(
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
                      decoration: BoxDecoration(color: theme().primaryColor, shape: BoxShape.circle),
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.width * 0.85,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(timer.repText, style: theme().textTheme.display1),
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
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Config(onDarkModeChanged: setDarkMode),
                      ),
                    );
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
        ));
  }
}

class Config extends StatefulWidget {
  final void Function(bool) onDarkModeChanged;

  Config({Key key, this.onDarkModeChanged}) : super(key: key);

  @override
  ConfigState createState() => ConfigState(onDarkModeChanged: onDarkModeChanged);
}

class ConfigState extends State<Config> {
  final void Function(bool) onDarkModeChanged;

  ConfigState({@required this.onDarkModeChanged});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Switch(
        onChanged: onDarkModeChanged,
        value: useDarkThemePref,
      ),
    ]);
  }
}
