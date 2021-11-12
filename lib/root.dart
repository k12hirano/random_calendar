import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:random_calendar/db.dart';
import 'package:random_calendar/plan.dart';
import 'package:random_calendar/popup.dart';
import 'package:random_calendar/space.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';

//todo　
// カレンダーの下にリストで指定した日の予定一覧表示、
// 指定した日を押した時の処理追加、　
// 予定をアイコンかその他の表示方法でカレンダーのセル場に表示、　

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  Map<DateTime, List> _eventList = {};
  List<Plan> _plans = [];
  final ScrollController _scrollController = ScrollController();
  DateRangePickerController controller = DateRangePickerController();
  var plantext = TextEditingController();
  DateTime _selectedDay;
  DateTime _focusedDay;
  List<DateTime> _dateList = [];
  var _days = [];

  @override
  void initState() {
    _selectedDay = _focusedDay;
    load();
    super.initState();
  }

  @override
  void dispose(){
    controller = DateRangePickerController();
    plantext = TextEditingController();
    super.dispose();
  }

  Future<void> load() async {
    _plans = await DB().getPlans();
    List<dynamic> kari = [];
    for(var i=0;i<_plans.length;i++) {
      if(i+1<_plans.length){
      if (_plans[i].datetime == _plans[i+1].datetime) {
        kari.add(_plans[i]);
      } else {
        kari.add(_plans[i]);
        _eventList[_plans[i].datetime] = kari;
        kari.removeRange(0, kari.length);
      }
    } else {
        kari.add(_plans[i]);
        _eventList[_plans[i].datetime] = kari;
      }
    }
  }

  Future<void> setPlan(Plan plan) async {
    await DB().insertPlan(plan);
  }

  Future<void> setSpace(Space space) async {
    await DB().insertSpace(space);
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final adjustsizeh = MediaQuery.of(context).size.height * 0.0011;


    int currentMonth;
    int getHashCode(DateTime key) {
      return key.day * 1000000 + key.month * 10000 + key.year;
    }

    void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      setState(() {
        _days = args.value;
      });
    }

    Future<void> _pickedDates(BuildContext context, DateRangePickerController controller) async {
      _days = [];
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
                      allowViewNavigation: true,
                      navigationMode: DateRangePickerNavigationMode.snap,
                      // スクロール量、止まる位置 snapは月毎にぴったり止まって切り替わる
                      showNavigationArrow: true,
                      onViewChanged: (DateRangePickerViewChangedArgs args) {
                        var visibleDates = args.visibleDateRange;
                      },
                      onSelectionChanged: _onSelectionChanged,
                      showActionButtons: true,
                      onSubmit: (Object value) {
                        if(_days.length>0){
                        _dateList = _days;
                        for(var i=0;i<_dateList.length;i++){
                          setSpace(Space(datetime: _dateList[i], mode: 1, count: 1));
                        }}else{}
                        Navigator.pop(context);
                        load();
                        print(value.toString());
                      },
                      onCancel: () {
                        _days = [];
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


      Future<void> dialogOn() async {
        var result =  await showDialog(
            context: context,
            builder: (_) {
              return SimpleDialog(
                contentPadding: EdgeInsets.all(0.0),
                titlePadding: EdgeInsets.all(0.0),
                title: Container(
                  color: Colors.lightGreen,
                  height: height*0.5,
                  width: width*0.75,
                  child: Scaffold(
                    body: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                  height: height*0.05,
                                  width: width*0.75*0.8,
                                  child: TextFormField(decoration: InputDecoration(
                                      isDense: true,
                                      hintText: '予定'),
                                      controller: plantext,
                                      style: TextStyle(
                                          fontSize: 20*adjustsizeh,
                                          height: 2.0,
                                          color: Colors.brown
                                      )
                                  )),
                              Container(
                                  height: height*0.07,
                                  child: Text('ここに日付入力、右にカレンダーのアイコンで日付選択可')),
                              Container(
                                  height: height*0.07,
                                  child: Text('ここに時間帯幅入力、未入力でも可')),
                              Container(
                                  height: height*0.07,
                                  child: Text('メモ欄')),
                              Container(
                                  height: height*0.06,
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            height: height*0.06,
                                            width: width*0.28,
                                            child:ElevatedButton(
                                                child: Text('登録', style: TextStyle(color: Colors.yellow[200],fontSize: 15)),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.green[800],
                                                ),
                                                onPressed: () {
                                                  //処理
                                                    setPlan(Plan(title: plantext.text, datetime: DateTime.now(), year: 2021, month: 11, place: 1, memo: 'sapmle'));
                                                  setState(() {
                                                    load();
                                                    Navigator.pop(context);
                                                  });
                                                })),
                                        Container(
                                            height: height*0.06,
                                            width: width*0.28,
                                            child: ElevatedButton(
                                                child: Text('キャンセル',  style: TextStyle(color: Colors.yellow[200], fontSize: 15)),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.lightGreen,
                                                ),
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                }))]
                                  ))
                            ])
                    ),
                  ),
                ),
              );
            });
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
                  onPressed: () {
                   // final DateTime pickedDates = await _pickedDates(
                    //    context, controller);
                    _pickedDates(context, controller);
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
                        if(!isSameDay(_selectedDay, selectedDay)){
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      }},
                      onDayLongPressed: (selectedDay, focusedDay){
                        setState(() {
                          dialogOn();
                        });
                      },
                      eventLoader: _getEventForDay,
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                         currentMonth= focusedDay.month;
                      },

                    )),
                Container(
                    height: height*0.1,
                    child: ListView(
                      children: _getEventForDay(_selectedDay).map((event) =>
                          ListTile(
                        title:
                        Text(event.title.toString()),
                      )).toList(),
                    ))
              ],
            ),
          )
      );
    }
}