
import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runZonedGuarded((){
    runApp(MyApp());
  },(error,stack){
    print("error = $error, stack = $stack");
  } );
}

class MyApp extends StatelessWidget {
  var future = Future.value(33);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    // future.then((value) => {throw "error------"});
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        //命名路由 step1 定义路由
        // "newRoute":(context) => NewRoute(text: ModalRoute.of(context).settings.arguments),
        // "lRoute":(context) => LRoute(),
      },
      onGenerateRoute: (settings){ //上面routes没有注册才会走onGenerateRoute
        switch(settings.name){
          case 'newRoute':
            return MaterialPageRoute(builder: (context) => NewRoute(text: settings.arguments));
          default:
            return MaterialPageRoute(builder: (context) => LRoute());
        }

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String text = "Jump";

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
                onPressed: () async {
                  // 打开`NewRoute`，并等待返回结果
                  // var result = await Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) {
                  //   return NewRoute(
                  //     text: "点击了 $_counter 次",
                  //   );
                  // }));
                  //命名路由 step2 跳转传值
                  var result = await Navigator.pushNamed(context, "newRoute", arguments: "点击了 $_counter 次");

                  setState(() {
                    this.text = result;
                  });
                },
                child: Text(this.text))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class NewRoute extends StatelessWidget {
  String text;

  NewRoute({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //命名路由 step3 接受值
    var t = ModalRoute.of(context).settings.arguments;

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("NewRoute"),
        ),
        body: Column(
          children: [
            Text("NewRoute"),
            Image.asset("assets/ic_bought.png")
          ],
        ),
      ),
      onWillPop: () {
        Navigator.pop(context, text);
      },
    );
  }
}


class LRoute extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //命名路由 step3 接受值
    // var t = ModalRoute.of(context).settings.arguments;

    return Scaffold(body: Text("LLLLLLLLLLLLLLLLLLLRoute"),);
  }
}