import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:random_calendar/popup.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
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
    final ScrollController _scrollController = ScrollController();
    final DateRangePickerController controller = DateRangePickerController();
    DateTime _selectedDay;
    DateTime _focusedDay;
    int currentMonth;
    Map<DateTime, List> _eventList = {};
    int getHashCode(DateTime key) {
      return key.day * 1000000 + key.month * 10000 + key.year;
    }

    Future<DateTime> _pickedDates(BuildContext context, DateRangePickerController controller) async {
      await showDialog(
          context: context,
          builder: (_) {
            return SimpleDialog(
              contentPadding: EdgeInsets.all(0.0),
              titlePadding: EdgeInsets.all(0.0),
              title: Container(
                height: 400,
                child: Scaffold(
                  body: Container(
                    child: SfDateRangePicker(
                      controller: controller,
                      view: DateRangePickerView.month,
                      // monthViewSettings: DateRangePickerMonthViewSettings(
                      //   specialDates: _specialDates, firstDayOfWeek: 1),
                      // cellBuilder: cellBuilder, // デザインを変更したい場合。詳細はページ下部へ
                      //  initialSelectedDate: DateTime(2021,10,1),
                      // multiRange 複数連日 などバリエーション豊かに選択範囲が設定できます！
                      selectionMode: DateRangePickerSelectionMode.multiple,
                      // 1日のみ
                      allowViewNavigation: true,
                      navigationMode: DateRangePickerNavigationMode.snap,
                      // スクロール量、止まる位置 snapは月毎にぴったり止まって切り替わる
                      showNavigationArrow: true,
                      onViewChanged: (DateRangePickerViewChangedArgs args) {
                        var visibleDates = args.visibleDateRange;
                      },
                      showActionButtons: true,
                      // 下のボタンを表示したい時
                      onSubmit: (Object value) {
                        Navigator.pop(context);
                        return value;
                      },
                      onCancel: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            );
          });}

      final _events = LinkedHashMap<DateTime, List>(
        equals: isSameDay,
        hashCode: getHashCode,
      )
        ..addAll(_eventList);

      List _getEventForDay(DateTime day) {
        return _events[day] ?? [];
      }

      Widget floatingButton() {
        return FloatingActionButton(
            child: Icon(Icons.list_alt, color: Colors.white),
            backgroundColor: Colors.lightGreen,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      Popup(
                      )));
            });
      }

      Widget doButton() {
        return
          Container(
              height: height * 0.06,
              width: width * 0.2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  onPressed: () async {
                    final DateTime pickedDates = await _pickedDates(
                        context, controller);
                    if (controller.selectedDate != null) {}
                  },
                  child: Text('穴埋め',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.lightGreen,
                          fontSize: 15))));
      }

      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              elevation: 8,
              centerTitle: true,
              title: Text("ランダムカレンダー", style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.lightGreen,
              actions: [
                Padding(padding: EdgeInsets.all(6),
                    child: doButton())
              ]
          ),
          floatingActionButton: floatingButton(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: height * 0.8,
                    //height: 400,
                    //width: ,
                    child: TableCalendar(
                      focusedDay: DateTime.now(),
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      locale: 'ja_JP',
                      calendarFormat: CalendarFormat.month,
                      //calendarStyle: CalendarStyle(),
                      rowHeight: 90,
                      daysOfWeekHeight: 30,
                      //calendarBuilders: CalendarBuilders(markerBuilder: MarkerBuilder(context, ,)),
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
                          _focusedDay =
                              focusedDay; // update `_focusedDay` here as well
                        });
                      },
                      eventLoader: _getEventForDay,
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                         currentMonth= focusedDay.month;
                      },

                    ))
              ],
            ),
          )
      );
    }
}