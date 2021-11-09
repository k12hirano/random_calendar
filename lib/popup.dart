import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Popup extends StatefulWidget {

  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  List _eventLists =[];
  var todotext = TextEditingController();
  bool han;
  bool ichi;
  bool tan;
  bool one;
  bool multi;


  @override
  void dispose() {
    todotext?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final adjustsizeh = MediaQuery.of(context).size.height * 0.0011;

    Future<Widget> _todoDialog(BuildContext context) async {
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
                            child: TextFormField(decoration: InputDecoration(
                                isDense: true,
                                hintText: 'やること入力してください'),
                                controller: todotext,
                                style: TextStyle(
                                    fontSize: 15*adjustsizeh,
                                    height: 2.0,
                                    color: Colors.brown
                                )
                            )),
                        Container(child: Column(children: <Widget>[
                          Text('規模選択'),
                          Container(child:Row(children: <Widget>[
                            Container(child: Row(children: <Widget>[
                              Checkbox(value: han, onChanged: (value){
                                han=value;
                              }),
                              Text('半日')
                            ])),
                            Container(child: Row(children: <Widget>[
                              Checkbox(value: ichi, onChanged: (value){
                                ichi=value;
                              }),
                              Text('一日')
                            ])),
                            Container(child: Row(children: <Widget>[
                              Checkbox(value: tan, onChanged: (value){
                                tan=value;
                              }),
                              Text('短時間')
                            ]))
                          ]))
                        ])),
                        Container(child: Column(children: <Widget>[
                          Text('回数選択'),
                          Container(child:Row(children: <Widget>[
                            Container(child: Row(children: <Widget>[
                              Checkbox(value: one, onChanged: (value){
                                one=value;
                              }),
                              Text('１回のみ')
                            ])),
                            Container(child: Row(children: <Widget>[
                              Checkbox(value: multi, onChanged: (value){
                                multi=value;
                              }),
                              Text('複数回')
                            ])),
                            //TODO スイッチ形式で二択用意、　複数回選択時詳細設定部分表示し、回数指定（バーで選択or入力、不定期、月一など選択可）
                          ]))
                        ]),),
                        Container(child:Row(
                            children: <Widget>[
                              Container(child:ElevatedButton(child: Text('登録'))),
                              Container(child: ElevatedButton(child: Text('キャンセル')))]
                        ))
                      ])
                  ),
                ),
              ),
            );
          });}

    Widget floatButton(){
      return FloatingActionButton(child: Icon(Icons.add,color: Colors.white),
          backgroundColor: Colors.lightGreen,
          onPressed: () async {
            _todoDialog;
      });
    }
    
    Widget todoLists(){
      return ListView.builder(itemBuilder: (context, index){
        return InkWell(child: Container(child: Text(_eventLists[index])));
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
                  todoLists()])
            )));
  }

}