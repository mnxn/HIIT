import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mhiit/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HIIT Timer',
      theme: AppTheme.dark(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool running = false;
  Duration timerState;
  Timer timer;

  int warmUpTime;
  int workTime;
  int restTime;
  int coolDownTime;
  int numberRounds;

  Duration totalTime;

  HomeState({
    this.warmUpTime = 120,
    this.workTime = 30,
    this.restTime = 90,
    this.coolDownTime = 120,
    this.numberRounds = 5,
  }) {
    timerState = totalTime = Duration(
      seconds: warmUpTime + (numberRounds * (workTime + restTime)) + restTime,
    );

    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (running) {
        setState(() {
          timerState -= Duration(seconds: 1);
        });
      }
    });
  }

  void play() {
    setState(() {
      running = !running;
    });
  }

  String formatTime(Duration duration) {
    String pad(num n) {
      return n.remainder(60).toString().padLeft(2, "0");
    }

    return "${pad(duration.inMinutes)}:${pad(duration.inSeconds)}";
  }

  String formatTotalTime(Duration duration) {
    String pad(num n) {
      return n.remainder(60).toString().padLeft(2, "0");
    }

    return "${pad(duration.inHours)}:${pad(duration.inMinutes)}:${pad(duration.inSeconds)}";
  }

  Color timerColor() {
    return Color.fromRGBO(231, 72, 86, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: timerColor(),
      appBar: AppBar(title: Text("HIIT"), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(formatTime(timerState), style: Theme.of(context).textTheme.display4),
          LinearProgressIndicator(value: 0.05),
          Text(
            "Work",
            style: Theme.of(context).textTheme.display3,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: play,
        tooltip: running ? "Pause" : "Play",
        child: Icon(running ? Icons.pause : Icons.play_arrow),
        shape: StadiumBorder(side: BorderSide(width: 3)),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              tooltip: "Settings",
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.replay, color: Colors.white),
              tooltip: "Restart",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
