import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:random_calendar/popup.dart';
import 'package:table_calendar/table_calendar.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final adjustsizeh = MediaQuery.of(context).size.height * 0.0011;
    DateTime _selectedDay;
    DateTime _focusedDay;
    Map<DateTime, List> _eventList = {};
    int getHashCode(DateTime key) {
      return key.day * 1000000 + key.month * 10000 + key.year;
    }

    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventList);

    List _getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    Widget floatingButton(){
      return FloatingActionButton(child: Icon(Icons.list_alt,color: Colors.lightGreen),
          backgroundColor: Colors.lightGreen,
          onPressed: (){Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>Popup(
        )));
      });
    }

    Widget doButton(){
      return
        Container(
            height: height*0.08,
            width: width*0.2,
            child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: (){
              //TODO
            },
            child: Text('予定決定',
                style:TextStyle(fontWeight: FontWeight.bold, color: Colors.lightGreen, fontSize: 18))));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 8,
            centerTitle: true,
            title:Text("ランダムカレンダー",style: TextStyle(color: Colors.white)),
           backgroundColor: Colors.lightGreen,
            actions: [
             doButton()
            ]
        ),
        floatingActionButton: floatingButton(),
            body:Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height:height*0.8,
                        //height: 400,
                        //width: ,
                        child:TableCalendar(
                          focusedDay: DateTime.now(),
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          locale: 'ja_JP',
                          calendarFormat: CalendarFormat.month,
                          calendarStyle: CalendarStyle(),
                          rowHeight: 15,
                          daysOfWeekHeight: 20,
                          headerStyle: HeaderStyle(
                            titleCentered: true,
                            formatButtonVisible: false,
                          ),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay; // update `_focusedDay` here as well
                          });
                        },
                        eventLoader: _getEventForDay,
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                            ))
                    ],
                  ),
            )
    );
  }
}