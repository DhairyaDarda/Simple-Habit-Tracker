// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_tracker/util/habit.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data Structure for the data
  List habitList = [
    // ["habitName , habitStarted , timeSpent (sec), timeGoal (min)"]
    ['Exercise', false, 0, 1], // for testing it is set to 1 min
    ['Read', false, 0, 20],
    ['Study', false, 0, 60],
    ['Meditate', false, 0, 10],
    //['', false , 0 , 30],
  ];

  void habitStared(int index) {
    //Note Start Time
    var startTime = DateTime.now();

    // Time already Passed
    var elapsedTime = habitList[index][2];

    // habit started or paused
    setState(() {
      habitList[index][1] = !habitList[index][1];
    });

    if (habitList[index][1]) {
      // Timer
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          //check when it is stopped
          if (!habitList[index][1]) {
            timer.cancel();
          }

          // Calculate the time Elapsed
          var currentTime = DateTime.now();
          habitList[index][2] = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });
      });
    }
  }

  void settingsOpened(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Settings for " + habitList[index][0]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          "Habit Tracker", //"Small Steps Everyday",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey[850],
      ),
      body: ListView.builder(
          itemCount: habitList.length,
          itemBuilder: (context, index) {
            return Habit(
                habitName: habitList[index][0],
                onTap: () {
                  habitStared(index);
                },
                settingsTapped: () {
                  settingsOpened(index);
                },
                timeSpent: habitList[index][2],
                timeGoal: habitList[index][3],
                habitStarted: habitList[index][1]);
          }),
    );
  }
}
