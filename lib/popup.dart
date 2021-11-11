import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:random_calendar/db.dart';
import 'package:random_calendar/event.dart';

//ダイアログ内のレイアウト、書式、色設定、チェックボックスの処理


class Popup extends StatefulWidget {

  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  List _eventLists =[];
  var todotext = TextEditingController();
  var todotext1 = TextEditingController();
  bool han= false;
  bool ichi = false;
  bool tan = false;
  bool one = false;
  bool multi = false;

  @override
  void initState() {
    eventsLoad();
    super.initState();
  }

  Future<void> eventsLoad() async {
    _eventLists = await DB().getEvents();
  }


  @override
  void dispose() {
    todotext?.dispose();
    todotext1?.dispose();
    super.dispose();
  }

  void insert() async {
    await DB().insert(
      Event(
        title: todotext.text,
        mode: null,
        count: null,
        datetime: null,
        enrollment: DateTime.now().toString()
      )
    );
  }

  void update(int id, int mode, int count) async {
    await DB().update(
      Event(
        title: todotext1.text,
        mode: mode,
        count: count,
        datetime: null,
        enrollment: DateTime.now().toString()
      ), id
    );
  }

  void remove(int id) async {
    DB().delete(id);
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final adjustsizeh = MediaQuery.of(context).size.height * 0.0011;

   /* Future<Widget> _todoDialog(BuildContext context) async {
      await showDialog(
          context: context,
          builder: (_) {
            return SimpleDialog(
              contentPadding: EdgeInsets.all(0.0),
              titlePadding: EdgeInsets.all(0.0),
              title: Container(
                height: height*0.75,
                child: Scaffold(
                  body: Container(
                      child: Column(children: <Widget>[
                        Container(
                          height: height*0.15,
                            child: TextFormField(decoration: InputDecoration(
                                isDense: true,
                                hintText: 'やってみたいこと入力してください'),
                                controller: todotext,
                                style: TextStyle(
                                    fontSize: 15*adjustsizeh,
                                    height: 2.0,
                                    color: Colors.brown
                                )
                            )),
                        Container(
                            height: height*0.15,
                            child: Column(children: <Widget>[
                          Text('規模選択'),
                          Container(
                              height: height*0.1,
                              child:Row(children: <Widget>[
                            Container(
                                height: height*0.1,
                                width: width*0.23,
                                child: Row(children: <Widget>[
                              Checkbox(value: han, onChanged: (value){
                                han=value;
                              }),
                              Text('半日')
                            ])),
                            Container(
                                height: height*0.1,
                                width: width*0.23,
                                child: Row(children: <Widget>[
                              Checkbox(value: ichi, onChanged: (value){
                                ichi=value;
                              }),
                              Text('一日')
                            ])),
                            Container(
                                height: height*0.1,
                                width: width*0.23,
                                child: Row(children: <Widget>[
                              Checkbox(value: tan, onChanged: (value){
                                tan=value;
                              }),
                              Text('短時間')
                            ]))
                          ]))
                        ])),
                        Container(
                          height: height*0.15,
                          child: Column(children: <Widget>[
                          Text('回数選択'),
                          Container(
                              height: height*0.1,
                              child:Row(children: <Widget>[
                            Container(
                                height: height*0.1,
                                width: width*0.28,
                                child: Row(children: <Widget>[
                              Checkbox(value: one, onChanged: (value){
                                one=value;
                              }),
                              Text('１回のみ')
                            ])),
                            Container(
                                height: height*0.1,
                                width: width*0.28,
                                child: Row(children: <Widget>[
                              Checkbox(value: multi, onChanged: (value){
                                multi=value;
                              }),
                              Text('複数回')
                            ])),
                            //TODO スイッチ形式で二択用意、　複数回選択時詳細設定部分表示し、回数指定（バーで選択or入力、不定期、月一など選択可）
                          ]))
                        ])),
                        Container(
                            height: height*0.2,
                            child:Row(
                            children: <Widget>[
                              Container(
                                  height: height*0.17,
                                  width: width*0.28,
                                  child:ElevatedButton(
                                  child: Text('登録', style: TextStyle(color: Colors.yellow[200],fontSize: 15)),
                                  style: ElevatedButton.styleFrom(
                                primary: Colors.lightGreen,
                              ))),
                              Container(
                                  height: height*0.17,
                                  width: width*0.28,
                                  child: ElevatedButton(
                                  child: Text('キャンセル',  style: TextStyle(color: Colors.yellow[200], fontSize: 15)),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.lightGreen,
                                  )))]
                        ))
                      ])
                  ),
                ),
              ),
            );
          });}*/

    Widget floatButton(){
      return FloatingActionButton(child: Icon(Icons.add,color: Colors.white),
          backgroundColor: Colors.lightGreen,
          onPressed: () async {
            var result =  await showDialog(
                context: context,
                builder: (_) {
                  return SimpleDialog(
                    contentPadding: EdgeInsets.all(0.0),
                    titlePadding: EdgeInsets.all(0.0),
                    title: Container(
                      height: height*0.65,
                      child: Scaffold(
                        body: Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                              Container(
                                  height: height*0.15,
                                  child: TextFormField(decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'やってみたいこと入力してください'),
                                      controller: todotext,
                                      style: TextStyle(
                                          fontSize: 15*adjustsizeh,
                                          height: 2.0,
                                          color: Colors.brown
                                      )
                                  )),
                              Container(
                                  height: height*0.15,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                    Text('規模選択'),
                                    Container(
                                        height: height*0.1,
                                        child:Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                          Container(
                                              height: height*0.1,
                                              width: width*0.23,
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                Checkbox(value: han, onChanged: (value){
                                                  han=value;
                                                }),
                                                Text('半日')
                                              ])),
                                          Container(
                                              height: height*0.1,
                                              width: width*0.23,
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                Checkbox(value: ichi, onChanged: (value){
                                                  ichi=value;
                                                }),
                                                Text('一日')
                                              ])),
                                          Container(
                                              height: height*0.1,
                                              width: width*0.23,
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                Checkbox(value: tan, onChanged: (value){
                                                  tan=value;
                                                }),
                                                Text('短時間')
                                              ]))
                                        ]))
                                  ])),
                              Container(
                                  height: height*0.15,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                    Text('回数選択'),
                                    Container(
                                        height: height*0.1,
                                        child:Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                          Container(
                                              height: height*0.1,
                                              width: width*0.28,
                                              child: Row(children: <Widget>[
                                                Checkbox(value: one, onChanged: (value){
                                                  one=value;
                                                }),
                                                Text('１回のみ')
                                              ])),
                                          Container(
                                              height: height*0.1,
                                              width: width*0.28,
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                Checkbox(value: multi, onChanged: (value){
                                                  multi=value;
                                                }),
                                                Text('複数回')
                                              ])),
                                          //TODO スイッチ形式で二択用意、　複数回選択時詳細設定部分表示し、回数指定（バーで選択or入力、不定期、月一など選択可）
                                        ]))
                                  ])),
                              Container(
                                  height: height*0.2,
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            height: height*0.17,
                                            width: width*0.28,
                                            child:ElevatedButton(
                                                child: Text('登録', style: TextStyle(color: Colors.yellow[200],fontSize: 15)),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.lightGreen,
                                                ),
                                                onPressed: () {
                                                  insert();
                                                })),
                                        Container(
                                            height: height*0.17,
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
      });
    }
    
    Widget todoLists(){
      return ListView.builder(itemBuilder: (context, index){
        return Slidable(
            secondaryActions: [
              IconSlideAction(
                caption: '削除',
                color: Colors.green[900],
                icon: Icons.remove,
                onTap: () {
                  remove(_eventLists[index].id);
                  setState(() {
                    eventsLoad();
                  });
                },
              ),
            ],
          child:InkWell(
            onTap: () async {
              var result =  await showDialog(
                  context: context,
                  builder: (_) {
                    return SimpleDialog(
                      contentPadding: EdgeInsets.all(0.0),
                      titlePadding: EdgeInsets.all(0.0),
                      title: Container(
                        height: height*0.65,
                        child: Scaffold(
                          body: Container(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                        height: height*0.15,
                                        child: TextFormField(decoration: InputDecoration(
                                            isDense: true,
                                            hintText: 'やってみたいこと入力してください'),
                                            controller: todotext,
                                            style: TextStyle(
                                                fontSize: 15*adjustsizeh,
                                                height: 2.0,
                                                color: Colors.brown
                                            )
                                        )),
                                    Container(
                                        height: height*0.15,
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text('規模選択'),
                                              Container(
                                                  height: height*0.1,
                                                  child:Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                            height: height*0.1,
                                                            width: width*0.23,
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Checkbox(value: han, onChanged: (value){
                                                                    han=value;
                                                                  }),
                                                                  Text('半日')
                                                                ])),
                                                        Container(
                                                            height: height*0.1,
                                                            width: width*0.23,
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Checkbox(value: ichi, onChanged: (value){
                                                                    ichi=value;
                                                                  }),
                                                                  Text('一日')
                                                                ])),
                                                        Container(
                                                            height: height*0.1,
                                                            width: width*0.23,
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Checkbox(value: tan, onChanged: (value){
                                                                    tan=value;
                                                                  }),
                                                                  Text('短時間')
                                                                ]))
                                                      ]))
                                            ])),
                                    Container(
                                        height: height*0.15,
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text('回数選択'),
                                              Container(
                                                  height: height*0.1,
                                                  child:Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                            height: height*0.1,
                                                            width: width*0.28,
                                                            child: Row(children: <Widget>[
                                                              Checkbox(value: one, onChanged: (value){
                                                                one=value;
                                                              }),
                                                              Text('１回のみ')
                                                            ])),
                                                        Container(
                                                            height: height*0.1,
                                                            width: width*0.28,
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Checkbox(value: multi, onChanged: (value){
                                                                    multi=value;
                                                                  }),
                                                                  Text('複数回')
                                                                ])),
                                                        //TODO スイッチ形式で二択用意、　複数回選択時詳細設定部分表示し、回数指定（バーで選択or入力、不定期、月一など選択可）
                                                      ]))
                                            ])),
                                    Container(
                                        height: height*0.2,
                                        child:Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                  height: height*0.17,
                                                  width: width*0.28,
                                                  child:ElevatedButton(
                                                      child: Text('更新', style: TextStyle(color: Colors.yellow[200],fontSize: 15)),
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Colors.lightGreen,
                                                      ),
                                                      onPressed: () {
                                                        update(_eventLists[index].id, null, null);
                                                      })),
                                              Container(
                                                  height: height*0.17,
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
            },
            child: Container(child: Text(_eventLists[index])))
        );
      },
      itemCount: _eventLists.length);
    }


    
    return Scaffold(
      appBar: AppBar(
          elevation: 8,
          centerTitle: true,
          title:Text("やることリスト",style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.lightGreen,
          actions: [
          ]
      ),
      floatingActionButton: floatButton(),
      body: Center(
          child: Container(
            height: height*0.85,
              width: width*0.98,
            child: Column(
                children: [
                  Container(
                      height: height*0.65,
                      width: width*0.95,
                      child:todoLists())
                  ])
            )));
  }

}