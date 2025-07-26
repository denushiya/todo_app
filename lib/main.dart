import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(HelloWorld());
}

class HelloWorld extends StatelessWidget {
  const HelloWorld();

  @override
  Widget build(BuildContext ctx) {
    TextStyle commonStyle = TextStyle(color: Colors.blue);

    Widget getText(String val) {
      return Text(val, style: commonStyle);
    }

    // app
    return MaterialApp(
      // screen
      home:Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("TODO APP", style: TextStyle(color: Colors.white)),
          //centerTitle: false,
        ),
        body: Row(
          children: [
            //Text("hello world!!!",style:commonStyle),
            //Text("hello guys!!!",style: commonStyle),
            //getText("hello1"),
            //SizedBox(width: 50),
            //getText("hello2"),
            //SizedBox(height: 50),
            Container(
              //margin: EdgeInsets.fromLTRB(20, 30, 40, 50),
              //padding: EdgeInsets.fromLTRB(100, 50, 0, 0),
              width: 250, 
              height: 250, 
              color: Colors.amber,
              child:  Column(
                children: [
                  getText("hello1"),
                  getText("hello2"),
                  getText("hello3"),
                  getText("hello4")
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}