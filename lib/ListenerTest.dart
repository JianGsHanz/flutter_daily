import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(RouteApp());
}

class RouteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RouteHome(),
    );
  }
}

class RouteHome extends StatefulWidget {
  @override
  _RouteState createState() => _RouteState();
}

class _RouteState extends State<RouteHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Route"),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => _ListenerRoute()));
                },
                child: Text("Listener原始指针事件处理"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => _GestureDetectorRoute()));
                },
                child: Text("GestureDetector手势识别"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => _DragRoute()));
                },
                child: Text("Drag拖动"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => _ScaleRoute()));
                },
                child: Text("Scale放缩"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => _GestureRecognizerRoute()));
                },
                child: Text("GestureRecognizer在TextSpan的应用"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => _BothDirectionRoute()));
                },
                child: Text("BothDirection手势竞争"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => _NotificationListenerRoute()));
                },
                child: Text("NotificationListener通知"),
              ),
            ],
          ),
        ));
  }
}

///Listener原始指针事件处理
class _ListenerRoute extends StatefulWidget {
  @override
  _ListenerState createState() => _ListenerState();
}

class _ListenerState extends State<_ListenerRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Listener(
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(Size(300.0, 200.0)),
            child: DecoratedBox(decoration: BoxDecoration(color: Colors.blue)),
          ),
          onPointerDown: (event) => print("down0"),
        ),
        Listener(
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(Size(200.0, 100.0)),
            child: Center(child: Text("左上角200*100范围内非文本区域点击")),
          ),
          onPointerDown: (event) => print("down1"),
          // behavior: HitTestBehavior.deferToChild, //放开此行注释后可以"点透"
        )
      ],
    ));
  }
}

///手势识别
class _GestureDetectorRoute extends StatefulWidget {
  @override
  _GestureDetectorState createState() => _GestureDetectorState();
}

class _GestureDetectorState extends State<_GestureDetectorRoute> {
  String _operation = "No Gesture detected!"; //保存事件名
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            color: Colors.blue,
            width: 200,
            height: 100,
            child: Text(
              _operation,
              style: TextStyle(color: Colors.white),
            ),
          ),
          onTap: () => setState(() => _operation = "点击"),
          onDoubleTap: () => setState(() => _operation = "双击"),
          onLongPress: () => setState(() => _operation = "长按"),
        ),
      ),
    );
  }
}

///拖拽
class _DragRoute extends StatefulWidget {
  @override
  _DragState createState() => _DragState();
}

class _DragState extends State<_DragRoute> with SingleTickerProviderStateMixin {
  double _top = 20.0;
  double _left = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      child: Stack(
        children: [
          Positioned(
              top: _top,
              left: _left,
              child: CircleAvatar(
                child: Text("H"),
                backgroundColor: Colors.blueGrey,
              ))
        ],
      ),
      //手指按下时会触发此回调
      onPanDown: (DragDownDetails e) {
        //打印手指按下的位置(相对于屏幕)
        print("用户手指按下：${e.globalPosition}");
      },
      //手指滑动时会触发此回调
      onPanUpdate: (DragUpdateDetails e) {
        setState(() {
          _left += e.delta.dx;
          _top += e.delta.dy;
        });
      },
      onPanEnd: (DragEndDetails e) {
        //打印滑动结束时在x、y轴上的速度
        print(e.velocity);
      },
    ));
  }
}

///放缩
class _ScaleRoute extends StatefulWidget {
  @override
  _ScaleState createState() => _ScaleState();
}

class _ScaleState extends State<_ScaleRoute> {
  double _width = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: Image.asset(
            "assets/ic_login_bg.png",
            width: _width,
          ),
          onScaleUpdate: (ScaleUpdateDetails details) {
            setState(() {
              //缩放倍数在0.8到10倍之间
              _width = 200 * details.scale.clamp(.8, 10.0);
            });
          },
        ),
      ),
    );
  }
}

///GestureRecognizer - TapGestureRecognizer
class _GestureRecognizerRoute extends StatefulWidget {
  @override
  _GestureRecognizerState createState() => _GestureRecognizerState();
}

class _GestureRecognizerState extends State<_GestureRecognizerRoute> {
  TapGestureRecognizer _tapGesture = new TapGestureRecognizer();
  bool _state = false;

  @override
  void dispose() {
    _tapGesture.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text.rich(TextSpan(children: [
          TextSpan(text: "hello word"),
          TextSpan(
              text: "点我变色",
              style: TextStyle(
                  color: _state ? Colors.blue : Colors.deepOrange,
                  fontSize: 26),
              recognizer: _tapGesture
                ..onTap = () {
                  setState(() {
                    _state = !_state;
                  });
                }),
          TextSpan(text: "ending"),
        ])),
      ),
    );
  }
}

class _BothDirectionRoute extends StatefulWidget {
  @override
  _BothDirectionState createState() => _BothDirectionState();
}

class _BothDirectionState extends State<_BothDirectionRoute> {
  double _top = 20.0;
  double _left = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: _top,
              left: _left,
              child: GestureDetector(
                child: CircleAvatar(
                  child: Text("A"),
                ),
                //垂直方向拖动
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    _top += details.delta.dy;
                  });
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    _left += details.delta.dx;
                  });
                },
              ))
        ],
      ),
    );
  }
}

class _NotificationListenerRoute extends StatefulWidget {
  @override
  _NotificationListenerState createState() => _NotificationListenerState();
}

class _NotificationListenerState extends State<_NotificationListenerRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*//监听全部
      body: NotificationListener(
        onNotification: (notification){
          switch (notification.runtimeType){
            case ScrollStartNotification: print("开始滚动"); break;
            case ScrollUpdateNotification: print("正在滚动"); break;
            case ScrollEndNotification: print("滚动停止"); break;
            case OverscrollNotification: print("滚动到边界"); break;
          }
        },
        child: ListView.builder(itemBuilder: (context,index){
          return ListTile(title: Text("data $index"),);
        },itemCount: 80,),
      ),*/

      //指定监听
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          print("zyh == $notification");
          return false; //当返回值为true时，阻止冒泡，其父级Widget将再也收不到该通知
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("data $index"),
            );
          },
          itemCount: 80,
        ),
      ),
    );
  }
}
