import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:buddiesgram/widgets/HeaderWidget.dart';

class TimeLinePage extends StatefulWidget {
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true ),
      body: Text('hello', style: TextStyle(color: Colors.white),),
    );

  }
}
