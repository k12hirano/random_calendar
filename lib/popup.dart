import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Popup extends StatefulWidget {

  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  List _eventLists =[];

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final adjustsizeh = MediaQuery.of(context).size.height * 0.0011;

    Widget floatButton(){
      return FloatingActionButton(child: Icon(Icons.add,color: Colors.black),
          backgroundColor: Colors.black,
          onPressed: () {
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