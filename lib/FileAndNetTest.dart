import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'download_chunks.dart';

void main() {
  runApp(FileAndNetApp());
}

class FileAndNetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FileAndNetHome(),
    );
  }
}

class FileAndNetHome extends StatefulWidget {
  @override
  _FileAndNetState createState() => _FileAndNetState();
}

class _FileAndNetState extends State<FileAndNetHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 48.0)),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => _FileOperationRoute()));
              },
              child: Text("文件操作"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => _HttpClientTestRoute()));
              },
              child: Text("HttpClient请求"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => _HttpClientTestRoute()));
              },
              child: Text("Dio请求"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => _HttpChunksRoute()));
              },
              child: Text("Http分块下载"),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileOperationRoute extends StatefulWidget {
  @override
  _FileOperationState createState() => _FileOperationState();
}

class _FileOperationState extends State<_FileOperationRoute> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _readFileContent().then((value) {
      setState(() {
        _count = int.parse(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("文件操作"),
      ),
      body: Center(
        child: Text("点击了$_count次"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Increment",
        onPressed: _incrementCounter,
      ),
    );
  }

  void _incrementCounter() async {
    setState(() {
      _count++;
    });
    // 将点击次数以字符串类型写到文件中
    (await _getLocalFile()).writeAsString("$_count");
  }

  ///临时目录: 可以使用 getTemporaryDirectory() 来获取临时目录； 系统可随时清除的临时目录（缓存）。在iOS上，这对应于NSTemporaryDirectory() (opens new window)返回的值。在Android上，这是getCacheDir() (opens new window)返回的值。
  /// 文档目录: 可以使用getApplicationDocumentsDirectory()来获取应用程序的文档目录，该目录用于存储只有自己可以访问的文件。只有当应用程序被卸载时，系统才会清除该目录。在iOS上，这对应于NSDocumentDirectory。在Android上，这是AppData目录。
  /// 外部存储目录：可以使用getExternalStorageDirectory()来获取外部存储目录，如SD卡；由于iOS不支持外部目录，所以在iOS下调用该方法会抛出UnsupportedError异常，而在Android下结果是android SDK中getExternalStorageDirectory的返回值。
  Future<File> _getLocalFile() async {
    var dir = (await getApplicationDocumentsDirectory()).path;
    return File("$dir/count.txt");
  }

  Future<String> _readFileContent() async {
    var file = await _getLocalFile();
    return file.readAsString();
  }
}

/// httpclient请求
class _HttpClientTestRoute extends StatefulWidget {
  @override
  _HttpClientTestState createState() => _HttpClientTestState();
}

class _HttpClientTestState extends State<_HttpClientTestRoute> {
  bool _loading = false;
  String _result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HttpClient请求"),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              onPressed: _loading
                  ? null
                  : () {
                      setState(() {
                        _loading = true;
                        _result = "正在请求...";
                      });
                      _getNetResult();
                    },
              child: Text("请求接口"),
            ),
            Text(_result),
          ],
        ),
      ),
    );
  }

  void _getNetResult() async {
    try {
      //创建一个HttpClient
      HttpClient httpClient = HttpClient();
      //打开Http连接
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(
          "https://api.agotoz.net/api/app/pay-packages?page=1&per_page=9999999"));
      request.headers.add("Authorization",
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC90ZXN0Mi5hcGkuYWdvdG96Lm5ldFwvYXBpXC9hcHBcL3VzZXJzXC9sb2dpbiIsImlhdCI6MTYyMjYyNTM1MSwiZXhwIjoxNjI3ODA5MzUxLCJuYmYiOjE2MjI2MjUzNTEsImp0aSI6IjNqbmI5Um9ibDJnb3hpQWMiLCJzdWIiOjY2NywicHJ2IjoiYWU3ODkzZDdmZGQwZGFjOGNmYTI3Y2U3YWI0OGQ3Njk4YzA5ODY3OSIsInJvbGUiOiJ1c2VyIn0.xN7l3DyMqCDhnkk9LjrohzSL-zoTEI3mcIJujeeQ2iE");
      request.headers.add("app-type", "2");
      request.headers.add("os-type", "1");
      request.headers.add("org-id", "2");
      request.headers.add("version", "1.0.0");
      //等待连接服务器（会将请求信息发送给服务器）
      HttpClientResponse response = await request.close();
      //读取响应内容
      _result = await response.transform(utf8.decoder).join();

      httpClient.close();
    } catch (e) {
      _result = "请求失败：$e";
    } finally {
      setState(() {
        _loading = false;
      });
      print(_result);
    }
  }
}

///Dio请求
class _DioTestRoute extends StatefulWidget {
  @override
  _DioTestState createState() => _DioTestState();
}

class _DioTestState extends State<_DioTestRoute> {
  bool _loading = false;
  String _result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dio请求"),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              onPressed: _loading
                  ? null
                  : () {
                      setState(() {
                        _loading = true;
                        _result = "正在请求...";
                      });
                      _getNetResult();
                    },
              child: Text("请求接口"),
            ),
            Text(_result),
          ],
        ),
      ),
    );
  }

  void _getNetResult() async {
    try {
      Map map = Map<String, String>();
      map["Authorization"] =
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC90ZXN0Mi5hcGkuYWdvdG96Lm5ldFwvYXBpXC9hcHBcL3VzZXJzXC9sb2dpbiIsImlhdCI6MTYyMjYyNTM1MSwiZXhwIjoxNjI3ODA5MzUxLCJuYmYiOjE2MjI2MjUzNTEsImp0aSI6IjNqbmI5Um9ibDJnb3hpQWMiLCJzdWIiOjY2NywicHJ2IjoiYWU3ODkzZDdmZGQwZGFjOGNmYTI3Y2U3YWI0OGQ3Njk4YzA5ODY3OSIsInJvbGUiOiJ1c2VyIn0.xN7l3DyMqCDhnkk9LjrohzSL-zoTEI3mcIJujeeQ2iE";
      map["app-type"] = "2";
      map["os-type"] = "1";
      map["org-id"] = "2";
      map["version"] = "1.0.0";
      Response response = await Dio().get(
          "https://api.agotoz.net/api/app/pay-packages?page=1&per_page=9999999",
          options: Options(headers: map));
      _result = response.data;
      print(response.data.toString());
    } catch (e) {
      _result = "请求失败：$e";
    } finally {
      setState(() {
        _loading = false;
      });
      print(_result);
    }
  }
}

///Http分块请求
class _HttpChunksRoute extends StatefulWidget {
  @override
  __HttpChunksState createState() => __HttpChunksState();
}

class __HttpChunksState extends State<_HttpChunksRoute> {
  String _progress = "开始下载";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 48.0)),
            RaisedButton(onPressed: () async{
              var url = "http://download.dcloud.net.cn/HBuilder.9.0.2.macosx_64.dmg";
              var savePath = (await getExternalStorageDirectory()).path;
              await downloadWithChunks(url, savePath, onReceiveProgress: (received, total) {
                if (total != -1) {
                  setState(() {
                    _progress = "${(received / total * 100).floor()}%";
                  });
                  // print("${(received / total * 100).floor()}%");
                }
              });
            },child: Text(_progress),)
          ],
        ),
      ),
    );
  }

}