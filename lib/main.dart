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

enum HIITInterval {
  Setup,
  WarmUp,
  Work,
  Rest,
  CoolDown,
  Done,
}

class HomeState extends State<Home> {
  Timer timer;
  bool isRunning = false;

  Duration elapsedTime = Duration();

  int warmUpTime;
  int workTime;
  int restTime;
  int coolDownTime;
  int numberRounds;

  HomeState({
    this.warmUpTime = 120,
    this.workTime = 30,
    this.restTime = 90,
    this.coolDownTime = 120,
    this.numberRounds = 8,
  }) {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (isRunning && currentInterval != HIITInterval.Done) {
        setState(() {
          elapsedTime += Duration(seconds: 1);
        });
      }
    });
  }

  HIITInterval get currentInterval {
    int bodyTime = (numberRounds * (workTime + restTime));

    if (elapsedTime.inSeconds == 0) return HIITInterval.Setup;
    if (elapsedTime.inSeconds >= warmUpTime + bodyTime + coolDownTime) return HIITInterval.Done;

    if (elapsedTime.inSeconds < warmUpTime) return HIITInterval.WarmUp;
    if (elapsedTime.inSeconds >= warmUpTime + bodyTime) return HIITInterval.CoolDown;

    if ((elapsedTime.inSeconds - warmUpTime) % (workTime + restTime) < workTime) {
      return HIITInterval.Work;
    }
    if ((elapsedTime.inSeconds - warmUpTime) % (workTime + restTime) < workTime + restTime) {
      return HIITInterval.Rest;
    }

    return null;
  }

  void playpause() {
    setState(() {
      isRunning = !isRunning;
    });
  }

  void restart() {
    setState(() {
      isRunning = false;
      elapsedTime = Duration();
    });
  }

  Color timerColor() {
    switch (currentInterval) {
      case HIITInterval.WarmUp:
      case HIITInterval.CoolDown:
        return Color.fromRGBO(99, 108, 122, 1);
      case HIITInterval.Work:
        return Color.fromRGBO(231, 72, 86, 1);
      case HIITInterval.Rest:
        return Color.fromRGBO(0, 204, 106, 1);
      default:
        return Color.fromRGBO(45, 51, 59, 1);
    }
  }

  String timerText() {
    switch (currentInterval) {
      case HIITInterval.Setup:
        return "Press Start";
      case HIITInterval.WarmUp:
        return "Warm Up";
      case HIITInterval.Work:
        return "Work";
      case HIITInterval.Rest:
        return "Rest";
      case HIITInterval.CoolDown:
        return "Cool Down";
      case HIITInterval.Done:
        return "Done";
    }
    return null;
  }

  String timeRemaining() {
    String formatTime(Duration duration) {
      String pad(num n) {
        return n.remainder(60).toString().padLeft(2, "0");
      }

      return "${pad(duration.inMinutes)}:${pad(duration.inSeconds)}";
    }

    return formatTime(elapsedTime);
  }

  String totalTime(Duration duration) {
    String pad(num n) {
      return n.remainder(60).toString().padLeft(2, "0");
    }

    return "${pad(duration.inHours)}:${pad(duration.inMinutes)}:${pad(duration.inSeconds)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: timerColor(),
      appBar: AppBar(title: Text("HIIT"), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(timeRemaining(), style: Theme.of(context).textTheme.display4),
          LinearProgressIndicator(value: 0.05),
          Text(timerText(), style: Theme.of(context).textTheme.display3),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: playpause,
        tooltip: isRunning ? "Pause" : "Play",
        child: Icon(isRunning ? Icons.pause : Icons.play_arrow),
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
              onPressed: restart,
            ),
          ],
        ),
      ),
    );
  }
}
