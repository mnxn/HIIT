import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiit/single_route_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_strategy/url_strategy.dart';

import 'package:hiit/hiit.dart';
import 'package:hiit/theme.dart' as theme;
import 'package:hiit/themed_timerpicker.dart';
import 'package:hiit/themed_numberpicker.dart';

late SharedPreferences preferences;

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  preferences = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runSingleRouteApp(
    title: 'HIIT Timer',
    theme: theme.light(),
    darkTheme: theme.dark(),
    themeMode: ThemeMode.system,
    home: const Home(),
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController controller;

  late HIITTimer timer;
  late bool useElapsedTitle;

  Color timerColor() {
    switch (timer.current.kind) {
      case IntervalKind.warmUp:
      case IntervalKind.coolDown:
        return theme.coolDownColor;
      case IntervalKind.work:
        return theme.workColor;
      case IntervalKind.rest:
        return theme.restColor;
      default:
        return theme.defaultColor;
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
    controller = AnimationController(vsync: this, value: 1);
    controller.addListener(() => setState(() {}));

    timer = HIITTimer(
      (double value) {
        if (value > controller.value) controller.value = 1;

        controller.animateTo(value, duration: const Duration(seconds: 1));
        setState(() {});
      },
      warmUpTime: Duration(seconds: preferences.getInt("warmup") ?? HIITDefault.warmup),
      workTime: Duration(seconds: preferences.getInt("work") ?? HIITDefault.work),
      restTime: Duration(seconds: preferences.getInt("rest") ?? HIITDefault.rest),
      coolDownTime: Duration(seconds: preferences.getInt("cooldown") ?? HIITDefault.cooldown),
      sets: preferences.getInt("sets") ?? HIITDefault.sets,
    );

    useElapsedTitle = preferences.getBool("elapsed") ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: timerColor(),
      appBar: AppBar(
        title: InkWell(
          child: Text(useElapsedTitle ? timer.elapsedText : timer.remainingText),
          onTap: () {
            _do(preferences.setBool("elapsed", !useElapsedTitle));
            useElapsedTitle = !useElapsedTitle;
          },
          borderRadius: BorderRadius.circular(7),
        ),
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
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                  width: MediaQuery.of(context).size.shortestSide * 0.85,
                  height: MediaQuery.of(context).size.shortestSide * 0.85,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(timer.repText, style: Theme.of(context).textTheme.headline3),
                      Text(timer.current.remainingText, style: Theme.of(context).textTheme.headline1),
                      Text(timer.subtext, style: Theme.of(context).textTheme.headline3),
                    ],
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.shortestSide * 0.8,
                  height: MediaQuery.of(context).size.shortestSide * 0.8,
                  child: CircularProgressIndicator(
                    value: controller.value,
                    backgroundColor: Color.lerp(
                      Theme.of(context).primaryColor,
                      Theme.of(context).colorScheme.secondary,
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
        foregroundColor: Theme.of(context).primaryColor,
        shape: StadiumBorder(side: BorderSide(color: Theme.of(context).primaryColor, width: 3)),
        tooltip: timer.isRunning ? "Pause" : "Play",
        onPressed: () => setState(timer.playpause),
      ),
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.125,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings),
                      tooltip: "Settings",
                      onPressed: () {
                        scaffoldKey.currentState?.openDrawer();
                        timer.isRunning = false;
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay),
                      tooltip: "Restart",
                      onPressed: () => setState(timer.restart),
                    ),
                  ],
                ),
              ],
            ),
          )),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border(right: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2)),
          ),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Container(
                color: Theme.of(context).colorScheme.secondary,
                padding: const EdgeInsets.all(25),
                child: ListTile(
                  leading: Icon(Icons.settings, color: Theme.of(context).primaryColor),
                  dense: true,
                  title: Text(
                    'Settings',
                    textScaleFactor: 1.5,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              TimerInput(
                title: "Warm-Up Time",
                value: Duration(seconds: preferences.getInt("warmup") ?? HIITDefault.warmup),
                onConfirm: (duration) {
                  _do(preferences.setInt("warmup", duration.inSeconds));
                  timer.warmUpTime = duration;
                  timer.restart();
                },
              ),
              TimerInput(
                title: "Work Time",
                value: Duration(seconds: preferences.getInt("work") ?? HIITDefault.work),
                onConfirm: (duration) {
                  _do(preferences.setInt("work", duration.inSeconds));
                  timer.workTime = duration;
                  timer.restart();
                },
              ),
              TimerInput(
                title: "Rest Time",
                value: Duration(seconds: preferences.getInt("rest") ?? HIITDefault.rest),
                onConfirm: (duration) {
                  _do(preferences.setInt("rest", duration.inSeconds));
                  timer.restTime = duration;
                  timer.restart();
                },
              ),
              TimerInput(
                title: "Cool-Down Time",
                value: Duration(seconds: preferences.getInt("cooldown") ?? HIITDefault.cooldown),
                onConfirm: (duration) {
                  _do(preferences.setInt("cooldown", duration.inSeconds));
                  timer.coolDownTime = duration;
                  timer.restart();
                },
              ),
              NumberInput(
                title: "Number of Sets",
                singleLabel: "set",
                pluralLabel: "sets",
                value: preferences.getInt("sets") ?? HIITDefault.sets,
                onConfirm: (value) {
                  _do(preferences.setInt("sets", value));
                  timer.sets = value;
                  timer.restart();
                },
              ),
              Divider(color: Theme.of(context).colorScheme.secondary),
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1)),
                  child: const Text("Default Settings"),
                  onPressed: () {
                    _do(preferences.setInt("warmup", HIITDefault.warmup));
                    _do(preferences.setInt("work", HIITDefault.work));
                    _do(preferences.setInt("rest", HIITDefault.rest));
                    _do(preferences.setInt("cooldown", HIITDefault.cooldown));
                    _do(preferences.setInt("sets", HIITDefault.sets));
                    timer.warmUpTime = const Duration(seconds: HIITDefault.warmup);
                    timer.workTime = const Duration(seconds: HIITDefault.work);
                    timer.restTime = const Duration(seconds: HIITDefault.rest);
                    timer.coolDownTime = const Duration(seconds: HIITDefault.cooldown);
                    timer.sets = HIITDefault.sets;
                    timer.restart();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
