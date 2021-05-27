import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(StackApp());
}

class StackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      home: StackAppPage(),
    );
  }
}

class StackAppPage extends StatefulWidget {
  @override
  _StackAppPage createState() => _StackAppPage();
}

class _StackAppPage extends State<StackAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("StackApp"),
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Positioned(
            child: Container(
              child: Text(
                "data1",
                style: TextStyle(color: Colors.red,),
                textAlign: TextAlign.center,
              ),
              color: Colors.black12,
            ),
            top: 32,
          ),
          Positioned(
            child: Container(
              child: Text(
                "data2",
                style: TextStyle(color: Colors.red,),
                textAlign: TextAlign.center,
              ),
              color: Colors.black12,
            ),
            top: 100,
            bottom: 50,
          ),

          Positioned(
            child: Container(
              child: Text(
                "data3",
                style: TextStyle(color: Colors.red,),
                textAlign: TextAlign.center,
              ),
              color: Colors.black12,
            ),
            bottom: 0,
          )
        ],
      ),
    );
  }
}
