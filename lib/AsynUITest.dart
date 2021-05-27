import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(StreamBuilderApp());
}

class FutureBuilderApp extends StatefulWidget {
  @override
  _FutureBuilder createState() => _FutureBuilder();
}

class _FutureBuilder extends State<FutureBuilderApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
              future: mockNetworkData(),
              builder: (context, snapshot) {
                // 请求已结束
                if (snapshot.connectionState == ConnectionState.done) {
                  // 请求失败，显示错误
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    // 请求成功，显示数据
                    return Text("Contents: ${snapshot.data}");
                  }
                } else {
                  // 请求未结束，显示loading
                  return CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
}

Future<String> mockNetworkData() async {
  return Future.delayed(Duration(seconds: 2), () => "模拟网络返回de数据");
}

Stream<int> counter() {
  return Stream.periodic(Duration(seconds: 1), (i) {
    return i;
  });
}

class StreamBuilderApp extends StatefulWidget{
  @override
  _StreamBuilder createState() => _StreamBuilder();

}

class _StreamBuilder extends State<StreamBuilderApp>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: StreamBuilder<int>(
            stream: counter(), //
            //initialData: ,// a Stream<int> or null
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('没有Stream');/// 当前没有异步任务，比如[FutureBuilder]的[future]为null时
                case ConnectionState.waiting:/// 异步任务处于等待状态
                  return Text('等待数据...');
                case ConnectionState.active:/// Stream处于激活状态（流上已经有数据传递了），对于FutureBuilder没有该状态。
                  return Text('active: ${snapshot.data}');
                case ConnectionState.done:/// 异步任务已经终止.
                  return Text('Stream已关闭');
              }
              return null; // unreachable
            },
          ),
        ),
      ),
    );
  }
}
