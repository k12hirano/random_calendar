import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:random_calendar/db.dart';
import 'package:random_calendar/event.dart';
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
  DateRangePickerController forcalendar = DateRangePickerController();
  var plantext = TextEditingController();
  var memotext = TextEditingController();
  var _timecontroller = TextEditingController();
  DateTime _selectedDay;
  DateTime _focusedDay;
  List<DateTime> _dateList = [];
  List<DateTime> _singleday = [];
  var _days = [];
  var _dates = [];
  bool han = false;
  bool ichi = false;
  bool tan = false;
  var _initial = TimeOfDay(hour: 0, minute: 0);
  DateTime _inputdate;
  List _planlist = [];
  List<dynamic> _projects = [];
  List<Event> _todoList=[];

  @override
  void initState() {
    _selectedDay = _focusedDay;
    load();
    print('calendar');
    super.initState();
  }

  _RootState(){
    //load();
    print('LOAD');
  }

  @override
  void dispose(){
    controller = DateRangePickerController();
    plantext = TextEditingController();
    memotext = TextEditingController();
    _timecontroller = TextEditingController();
    super.dispose();
  }

  Future<void> load() async {
    _projects = await DB().getPlan();
    setState(() {
      for(var i=0;i<_projects.length;i++){
        var kari = _projects[i];
        _eventList[kari[0].datetime] = kari;
      }

    });

   /* _plans = await DB().getPlans();
    setState(() {
      List<dynamic> kari = [];
      _eventList.clear();
      for(var i=0;i<_plans.length;i++) {
        if(i+1<_plans.length){
          if (_plans[i].datetime.year == _plans[i+1].datetime.year &&
              _plans[i].datetime.month == _plans[i+1].datetime.month &&
              _plans[i].datetime.day == _plans[i+1].datetime.day) {
            kari.add(_plans[i]);
            print(_plans[i].title);
          } else {
            kari.add(_plans[i]);
            print(_plans[i].title);
            _eventList[_plans[i].datetime] = kari;
            print('1');
            print(_plans[i].datetime.toString());
            print(_eventList);
            kari.removeRange(0, kari.length);
          }
        } else {
          print(kari);
          kari.add(_plans[i]);
          print(_plans[i].title);
          print(_plans[i].datetime.toString());
          print(kari);
          print(_eventList);
          print(DateTime(_plans[i].datetime.year, _plans[i].datetime.month, _plans[i].datetime.day));
          _eventList[DateTime(_plans[i].datetime.year, _plans[i].datetime.month, _plans[i].datetime.day)] = kari;
          print('2');
          print(_eventList);
        }
      }
    });
    //_eventList.clear();
    //_eventList={DateTime(2021,11,24): [Plan(id:1, title:'A', datetime:DateTime(2021,11,24),year:2021, month:11,place:'lplp',memo:'heke'),
    //  Plan(id:1, title:'B', datetime:DateTime(2021,11,24),year:2021, month:11,place:'lplp',memo:'heke')],
    //  DateTime(2021,11,26):[Plan(id:3, title:'C', datetime:DateTime(2021,11,24),year:2021, month:11,place:'lplp',memo:'heke')]};
    print('koko');
    print(_eventList);*/
  }

  Future<void> setPlan(Plan plan) async {
    await DB().insertPlan(plan);
  }

  Future<void> setSpace(Space space) async {
    await DB().insertSpace(space);
  }

 Future<void> updatePlan(Plan plan, int id) async {
    await DB().updatePlan(plan, id);
 }

 Future<void> eventGet() async {
    _todoList = await DB().getEvents();
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
    void _onSelectionChanged1(DateRangePickerSelectionChangedArgs args) {
      setState(() {
        _singleday = args.value;
        //_dates = args.value;
      });
    }

    Future<void> _pickedDates(BuildContext context, DateRangePickerController controller) async {
      _days = [];
      //_todoList =
      eventGet();
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
                        if(_days.length>0&&_todoList.length>=_days.length){
                        _dateList = _days;
                        _dateList.shuffle();
                        _todoList.shuffle();
                        for(var i=0;i<_dateList.length;i++){
                          //setSpace(Space(datetime: _dateList[i], mode: 1, count: 1));
                          setPlan(Plan(title: _todoList[i].title, datetime: _dateList[i],year: _dateList[i].hour, month: _dateList[i].minute, hour: 12,minute: 0, place: 'ici', memo: ''));
                        }}else{}
                        print(_dateList);
                        Navigator.pop(context);
                        load().then((value) => setState(() {}));
                        print(value.toString());
                      },
                      onCancel: () {
                        _days = [];
                        controller=DateRangePickerController();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            );
          });}

    Future<void> _pickedDates1(BuildContext context, DateRangePickerController controller, DateTime selectedDay) async {
      //_dates = [];
      _singleday = [];
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
                        initialSelectedDate: selectedDay,
                      // multiRange 複数連日 などバリエーション豊かに選択範囲が設定できます！
                      selectionMode: DateRangePickerSelectionMode.multiple,
                      allowViewNavigation: true,
                      navigationMode: DateRangePickerNavigationMode.snap,
                      // スクロール量、止まる位置 snapは月毎にぴったり止まって切り替わる
                      showNavigationArrow: true,
                      onSelectionChanged: _onSelectionChanged1,
                      onViewChanged: (DateRangePickerViewChangedArgs args) {
                        var visibleDates = args.visibleDateRange;
                      },
                      showActionButtons: true,
                      onSubmit: (Object value) {
                        _singleday.sort((a, b) => a.compareTo(b));
                         setState(() {
                           //_inputdate = value;
                           _dates = _singleday;
                         });

                        Navigator.pop(context);
                        load();
                      },
                      onCancel: () {
                        //_dates=[];
                        controller=DateRangePickerController();
                        _singleday =[];
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
        //print(_events[day]);
        return _events[day] ?? [];
      }

      List _eventGet(DateTime day) {
        return _events[day] ?? [];
      }

      Future<void> _selectTime(BuildContext context) async {

        final TimeOfDay _plantime = await showTimePicker(context: context,
            initialTime: _initial,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });
        if(_plantime != null){
          //setState(() {
            _initial = _plantime;
          //});
        }
      }


      Future<void> dialogOn(DateTime selectedDay) async {
        print('?_dates');
        print(_dates);
            _initial = TimeOfDay(hour: 0, minute: 0);
            _inputdate = selectedDay;
            String weekday;
            if(selectedDay.weekday==1){weekday='(月)';}
            else if(selectedDay.weekday==2){weekday='(火)';}
            else if(selectedDay.weekday==3){weekday='(水)';}
            else if(selectedDay.weekday==4){weekday='(木)';}
            else if(selectedDay.weekday==5){weekday='(金)';}
            else if(selectedDay.weekday==6){weekday='(土)';}
            else if(selectedDay.weekday==7){weekday='(日)';}
        var result =  await showDialog(
            context: context,
            builder: (_) {
              return StatefulBuilder(
                  builder: (context, setState) {
              return SimpleDialog(
                contentPadding: EdgeInsets.all(0.0),
                titlePadding: EdgeInsets.all(0.0),
                title: Container(
                  color: Colors.lightGreen,
                  height: height * 0.55,
                  //width: width*0.75,
                  width: width * 0.9,

                   child: Scaffold(
                    body: Container(child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height:height*0.05),
                              Container(
                                  height: height * 0.05,
                                  width: width * 0.75 * 0.8,
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                          isDense: true,
                                          hintText: '予定'),
                                      controller: plantext,
                                      style: TextStyle(
                                          fontSize: 20 * adjustsizeh,
                                          height: 2.0,
                                          color: Colors.brown
                                      )
                                  )),
                              SizedBox(height:height*0.05),
                              Container(
                                  height: height * 0.07,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          height: height*0.15,
                                          width: width*0.5,
                                          alignment: Alignment.center,
                                          child: (_dates.length==0)?GestureDetector(
                                            onTap: () {
                                              _pickedDates1(
                                                  context, forcalendar,
                                                  selectedDay).then((value) => setState(() {}));
                                            },
                                            child: Container(
                                                height: height * 0.07,
                                                alignment: Alignment.center,
                                                child: Text(
                                                    _inputdate.year.toString() +
                                                        '/'
                                                        + _inputdate.month
                                                        .toString()
                                                        + '/' + _inputdate.day
                                                        .toString()
                                                        + '/' + weekday,
                                                    style: TextStyle(
                                                        fontSize: 18 *
                                                            adjustsizeh))
                                                      )) :(_dates.length==1)?GestureDetector(
                                              onTap: () {
                                                _pickedDates1(
                                                    context, forcalendar,
                                                    selectedDay);
                                              },
                                              child: Container(
                                                  height: height * 0.07,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      _dates[0].year.toString() +
                                                          '/'
                                                          + _dates[0].month
                                                          .toString()
                                                          + '/' + _dates[0].day
                                                          .toString()
                                                          + '/' + weekday,
                                                      style: TextStyle(
                                                          fontSize: 18 *
                                                              adjustsizeh))
                                              ))
                                                        :ListView.builder(
                                                           itemBuilder: (context, index){
                                                              return GestureDetector(
                                                                  onTap: () {
                                                                    _pickedDates1(
                                                                        context, forcalendar,
                                                                        selectedDay).then((value) => setState(() {}));
                                                                  },
                                                                  child: Container(
                                                                      height: height * 0.07,
                                                                      alignment: Alignment.center,
                                                                      child: Text(
                                                                          _dates[index].year.toString() +
                                                                              '/'
                                                                              + _dates[index].month
                                                                              .toString()
                                                                              + '/' + _dates[index].day
                                                                              .toString()
                                                                              + '/' + weekday,
                                                                          style: TextStyle(
                                                                              fontSize: 18 *
                                                                                  adjustsizeh))

                                                                  ));
                                                        })),
                                        /*Container(
                                        height: height*0.07,
                                        child:DateTimePicker(
                                      type: DateTimePickerType.time,
                                      //timePickerEntryModeInput: true,
                                      //controller: _timecontroller,
                                      initialValue: '00:00', //_initialValue,
                                      icon: Icon(Icons.access_time),
                                      use24HourFormat: true,
                                      locale: Locale('ja', 'JP'),
                                      onChanged: (value) {
                                        setState(() {
                                          //_timecontroller = TextEditingController(text:value);
                                      });},
                                    )),*/
                                        GestureDetector(
                                          onTap: () {
                                            _selectTime(context).then((value) => setState(() {}));
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  '${_initial.format(context)}～',
                                                  style: TextStyle(
                                                      fontSize: 18 *
                                                          adjustsizeh))),
                                        )
                                      ])
                              ),
                              /*Container(
                                  height: height * 0.1,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Text('規模選択'),
                                        Container(
                                            height: height * 0.07,
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: <Widget>[
                                                  Container(
                                                      height: height * 0.07,
                                                      width: width * 0.2,
                                                      child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .center,
                                                          children: <Widget>[
                                                            Checkbox(value: han,
                                                                onChanged: (
                                                                    value) {
                                                                  setState(() {
                                                                    han = value;
                                                                    ichi = !value;
                                                                    tan = !value;
                                                                  });
                                                                }),
                                                            Text('半日')
                                                          ])),
                                                  Container(
                                                      height: height * 0.07,
                                                      width: width * 0.2,
                                                      child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .center,
                                                          children: <Widget>[
                                                            Checkbox(
                                                                value: ichi,
                                                                onChanged: (
                                                                    value) {
                                                                  setState(() {
                                                                    ichi = value;
                                                                    han =!value;
                                                                    tan = !value;
                                                                  });
                                                                }),
                                                            Text('一日')
                                                          ])),
                                                  Container(
                                                      height: height * 0.07,
                                                      width: width * 0.2,
                                                      child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .center,
                                                          children: <Widget>[
                                                            Checkbox(value: tan,
                                                                onChanged: (
                                                                    value) {
                                                                  setState(() {
                                                                    tan = value;
                                                                    han = !value;
                                                                    ichi = ! value;
                                                                  });
                                                                }),
                                                            Text('時間')
                                                          ]))
                                                ]))
                                      ])),*/
                              SizedBox(height:height*0.05),
                              Container(
                                  height: height * 0.15,
                                  width: width * 0.7,
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                          isDense: true,
                                          hintText: 'メモ欄'),
                                      controller: memotext,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 100,
                                      style: TextStyle(
                                          fontSize: 18 * adjustsizeh,
                                          height: 2.0,
                                          color: Colors.black
                                      ))),
                              SizedBox(height:height*0.05),
                              Container(
                                  height: height * 0.06,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Container(
                                            height: height * 0.06,
                                            width: width * 0.28,
                                            child: ElevatedButton(
                                                child: Text('登録',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .yellow[200],
                                                        fontSize: 15)),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.green[800],
                                                ),
                                                onPressed: () {
                                                  //処理
                                                  setPlan(Plan(
                                                      title: plantext.text,
                                                      datetime: _dates[0],
                                                      year: 2021,
                                                      month: 11,
                                                      hour: _initial.hour,
                                                      minute: _initial.minute,
                                                      place: 'koko',
                                                      memo: memotext.text));
                                                  print(_dates[0]);
                                                  print(selectedDay);
                                                  setState(() {
                                                    plantext.clear();
                                                    memotext.clear();
                                                    load();
                                                    Navigator.pop(context);
                                                  });
                                                })),
                                        Container(
                                            height: height * 0.06,
                                            width: width * 0.28,
                                            child: ElevatedButton(
                                                child: Text('キャンセル',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .yellow[200],
                                                        fontSize: 15)),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.lightGreen,
                                                ),
                                                onPressed: () {
                                                  plantext.clear();
                                                  memotext.clear();
                                                  Navigator.pop(context);
                                                }))
                                      ]
                                  ))
                            ])
                    ),
                  ),
                ),
              ));
            });
            });
      }

    Future<void> dialogOn1(String title, DateTime selectedDay, int hour, int minute, String memo, int id) async {
      print('?_dates');
      print(_dates);
      _initial = TimeOfDay(hour: hour, minute: minute);
      _inputdate = selectedDay;

      String weekday;
      if(selectedDay.weekday==1){weekday='(月)';}
      else if(selectedDay.weekday==2){weekday='(火)';}
      else if(selectedDay.weekday==3){weekday='(水)';}
      else if(selectedDay.weekday==4){weekday='(木)';}
      else if(selectedDay.weekday==5){weekday='(金)';}
      else if(selectedDay.weekday==6){weekday='(土)';}
      else if(selectedDay.weekday==7){weekday='(日)';}
      plantext =TextEditingController(text: title);
      memotext = TextEditingController(text: memo);

      var result =  await showDialog(
          context: context,
          builder: (_) {
            return StatefulBuilder(
                builder: (context, setState) {
                  return SimpleDialog(
                    contentPadding: EdgeInsets.all(0.0),
                    titlePadding: EdgeInsets.all(0.0),
                    title: Container(
                      color: Colors.lightGreen,
                      height: height * 0.5,
                      //width: width*0.75,
                      width: width * 0.9,
                      child: Scaffold(
                        body: Container(child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                      height: height * 0.05,
                                      width: width * 0.75 * 0.8,
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                              isDense: true,
                                          //    hintText: '予定'
                                          ),
                                          controller: plantext,
                                          style: TextStyle(
                                              fontSize: 20 * adjustsizeh,
                                              height: 2.0,
                                              color: Colors.brown
                                          )
                                      )),
                                  Container(
                                      height: height * 0.07,
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceEvenly,
                                          children: <Widget>[
                                            Container(
                                                height: height*0.15,
                                                width: width*0.5,
                                                alignment: Alignment.center,
                                                child: (_dates.length==0)?GestureDetector(
                                                    onTap: () {
                                                      _pickedDates1(
                                                          context, forcalendar,
                                                          selectedDay).then((value) => setState(() {}));
                                                    },
                                                    child: Container(
                                                        height: height * 0.07,
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                            _inputdate.year.toString() +
                                                                '/'
                                                                + _inputdate.month
                                                                .toString()
                                                                + '/' + _inputdate.day
                                                                .toString()
                                                                + '/' + weekday,
                                                            style: TextStyle(
                                                                fontSize: 18 *
                                                                    adjustsizeh))
                                                    )) :(_dates.length==1)?GestureDetector(
                                                    onTap: () {
                                                      _pickedDates1(
                                                          context, forcalendar,
                                                          selectedDay);
                                                    },
                                                    child: Container(
                                                        height: height * 0.07,
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                            _dates[0].year.toString() +
                                                                '/'
                                                                + _dates[0].month
                                                                .toString()
                                                                + '/' + _dates[0].day
                                                                .toString()
                                                                + '/' + weekday,
                                                            style: TextStyle(
                                                                fontSize: 18 *
                                                                    adjustsizeh))
                                                    ))
                                                    :ListView.builder(
                                                    itemBuilder: (context, index){
                                                      return GestureDetector(
                                                          onTap: () {
                                                            _pickedDates1(
                                                                context, forcalendar,
                                                                selectedDay).then((value) => setState(() {}));
                                                          },
                                                          child: Container(
                                                              height: height * 0.07,
                                                              alignment: Alignment.center,
                                                              child: Text(
                                                                  _dates[index].year.toString() +
                                                                      '/'
                                                                      + _dates[index].month
                                                                      .toString()
                                                                      + '/' + _dates[index].day
                                                                      .toString()
                                                                      + '/' + weekday,
                                                                  style: TextStyle(
                                                                      fontSize: 18 *
                                                                          adjustsizeh))

                                                          ));
                                                    })),
                                            /*Container(
                                        height: height*0.07,
                                        child:DateTimePicker(
                                      type: DateTimePickerType.time,
                                      //timePickerEntryModeInput: true,
                                      //controller: _timecontroller,
                                      initialValue: '00:00', //_initialValue,
                                      icon: Icon(Icons.access_time),
                                      use24HourFormat: true,
                                      locale: Locale('ja', 'JP'),
                                      onChanged: (value) {
                                        setState(() {
                                          //_timecontroller = TextEditingController(text:value);
                                      });},
                                    )),*/
                                            GestureDetector(
                                              onTap: () {
                                                _selectTime(context).then((value) => setState(() {}));
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      '${_initial.format(context)}～',
                                                      style: TextStyle(
                                                          fontSize: 18 *
                                                              adjustsizeh))),
                                            )
                                          ])
                                  ),
                                  /*Container(
                                      height: height * 0.1,
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Text('規模選択'),
                                            Container(
                                                height: height * 0.07,
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Container(
                                                          height: height * 0.07,
                                                          width: width * 0.2,
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: <Widget>[
                                                                Checkbox(value: han,
                                                                    onChanged: (
                                                                        value) {
                                                                      setState(() {
                                                                        han = value;
                                                                        ichi = !value;
                                                                        tan = !value;
                                                                      });
                                                                    }),
                                                                Text('半日')
                                                              ])),
                                                      Container(
                                                          height: height * 0.07,
                                                          width: width * 0.2,
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: <Widget>[
                                                                Checkbox(
                                                                    value: ichi,
                                                                    onChanged: (
                                                                        value) {
                                                                      setState(() {
                                                                        ichi = value;
                                                                        han =!value;
                                                                        tan = !value;
                                                                      });
                                                                    }),
                                                                Text('一日')
                                                              ])),
                                                      Container(
                                                          height: height * 0.07,
                                                          width: width * 0.2,
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: <Widget>[
                                                                Checkbox(value: tan,
                                                                    onChanged: (
                                                                        value) {
                                                                      setState(() {
                                                                        tan = value;
                                                                        han = !value;
                                                                        ichi = ! value;
                                                                      });
                                                                    }),
                                                                Text('時間')
                                                              ]))
                                                    ]))
                                          ])),*/
                                  Container(
                                      height: height * 0.15,
                                      width: width * 0.85,
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                              isDense: true,
                                              hintText: 'メモ欄'),
                                          controller: memotext,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          style: TextStyle(
                                              fontSize: 18 * adjustsizeh,
                                              height: 2.0,
                                              color: Colors.black
                                          ))),
                                  Container(
                                      height: height * 0.06,
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Container(
                                                height: height * 0.06,
                                                width: width * 0.28,
                                                child: ElevatedButton(
                                                    child: Text('更新',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .yellow[200],
                                                            fontSize: 15)),
                                                    style: ElevatedButton.styleFrom(
                                                      primary: Colors.green[800],
                                                    ),
                                                    onPressed: () {
                                                      //処理
                                                      print(selectedDay);
                                                      print(selectedDay.hour);
                                                      updatePlan(Plan(
                                                          title: plantext.text,
                                                          datetime: selectedDay,
                                                          year: selectedDay.year,
                                                          month: selectedDay.month,
                                                          hour: _initial.hour,
                                                          minute: _initial.minute,
                                                          place: 'koko',
                                                          memo: memotext.text), id);
                                                      setState(() {
                                                        plantext.clear();
                                                        memotext.clear();
                                                        load();
                                                        Navigator.pop(context);
                                                      });
                                                    })),
                                            Container(
                                                height: height * 0.06,
                                                width: width * 0.28,
                                                child: ElevatedButton(
                                                    child: Text('キャンセル',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .yellow[200],
                                                            fontSize: 15)),
                                                    style: ElevatedButton.styleFrom(
                                                      primary: Colors.lightGreen,
                                                    ),
                                                    onPressed: () {
                                                      plantext.clear();
                                                      memotext.clear();
                                                      Navigator.pop(context);
                                                    }))
                                          ]
                                      ))
                                ])
                        ),
                     )),
                    ),
                  );
                });
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
          body: Center(child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: height * 0.6,
                    //height: 400,
                    //width: ,
                    child: TableCalendar(
                      focusedDay: DateTime.now(),
                      firstDay: DateTime.utc(2021, 1, 1),
                      lastDay: DateTime.utc(2022, 12, 31),
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
                          print('_getevent');
                          print(_getEventForDay(selectedDay));
                          _planlist=[];
                          print('getevent'+selectedDay.toString());
                          _planlist = _eventGet(selectedDay);
                          print(_planlist);
                        });
                        _getEventForDay(selectedDay);
                      }},
                      onDayLongPressed: (selectedDay, focusedDay){
                        setState(() {
                          dialogOn(selectedDay);
                        });
                      },
                      eventLoader: _getEventForDay,
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                         currentMonth= focusedDay.month;
                      },
                    )),
               // Container(
                 //   height: height*0.1,
                    //child:
                    ListView(
                      shrinkWrap: true,
                      children: _getEventForDay(_selectedDay).map((plan) =>
                          Slidable(
                              actionExtentRatio: 0.2,
                              actionPane: SlidableScrollActionPane(),
                              secondaryActions: [
                                IconSlideAction(
                                  caption: '削除',
                                  color: Colors.green[900],
                                  icon: Icons.remove,
                                  onTap: () {
                                    setState(() {
                                      DB().deletePlan(plan.id);
                                      load();
                                    });
                                  },
                                ),
                              ],
                        child: InkWell(
                            onTap: (){
                             /* DB().deletePlan(plan.id);
                              print('remove'+_selectedDay.toString());
                              _eventList = {};
                              _events.clear();*/

                             dialogOn1(plan.title, _selectedDay, _selectedDay.hour, _selectedDay.minute, plan.memo, plan.id);
                            },
                            child: Container(
                              height: height*0.08,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.green[900])),
                             child: Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 children: <Widget>[
                                   SizedBox(width: width*0.05),
                                   (plan.hour==0&&plan.minute==0)?Text(plan.hour.toString()+'0'+':'+plan.minute.toString()+'0'+'～')
                                   :(plan.hour==0&&plan.minute!=0)?Text(plan.hour.toString()+'0'+':'+plan.minute.toString()+'～')
                                   :(plan.hour!=0&&plan.minute==0)?Text(plan.hour.toString()+':'+plan.minute.toString()+'0'+'～')
                                   :Text(plan.hour.toString()+':'+plan.minute.toString()+'～'),
                                   SizedBox(width: width*0.1),
                                   Text(plan.title.toString(), style: TextStyle(fontSize: 18)),
                                 ]),
                      )))).toList(),
                    )
                    /*Container(
                        height: height*0.15,
                        child:ListView.builder(
                      shrinkWrap: true,
                      itemCount: _plans.length,
                      itemBuilder: (context, index){
                        return InkWell(onTap: (){},
                        child: Container(
                            height: height*0.05,
                            child: Text(_plans[index].title)));
                      },
                    ))*/
                //)
              ],
            ),
          )
      ));
    }
}