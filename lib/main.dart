import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:random_calendar/root.dart';

void main() => initializeDateFormatting().then((_) =>runApp(MyApp()));

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'random calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: Root(),
    );
  }
}