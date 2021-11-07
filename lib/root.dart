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
      return IconButton(icon: Icon(Icons.add,color: Colors.white,), onPressed: (){Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>Popup(
        )),
      );
      });
    }

    Widget doButton(){
      return
        Container( child:ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
            ),
            onPressed: (){
              //TODO
            },
            child: Text('予定決定',
                style:TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 20))));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 8,
            centerTitle: true,
            title:Text("ランダムカレンダー",style: TextStyle(color: Colors.white)),
           // backgroundColor: Colors.brown[800],
            actions: [
             doButton()
            ]
        ),
        floatingActionButton: floatingButton(),
            body:Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TableCalendar(
                          focusedDay: DateTime.now(),
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          locale: 'ja_JP',
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
                            )
                    ],
                  ),
            )
    );
  }
}