import 'package:flutter/material.dart';

void main() {
  runApp(AnimationApp());
}

class AnimationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimationHome(),
    );
  }
}

class AnimationHome extends StatefulWidget {
  @override
  _AnimationState createState() => _AnimationState();
}

class _AnimationState extends State<AnimationHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 30)),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => _ScaleAnimationRoute1()));
              },
              child: Text("放缩动画"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => _HeroAnimationRouteA()));
              },
              child: Text("Hero动画"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => _StaggerRoute()));
              },
              child: Text("Stagger交织动画"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => _AnimatedSwitcherRoute()));
              },
              child: Text("AnimatedSwitcher动画切换"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => _AnimatedWidgetsTestRoute()));
              },
              child: Text("Flutter预置的动画过渡组件"),
            ),
          ],
        ),
      ),
    );
  }
}

///放缩 需要继承TickerProvider，如果有多个AnimationController，则应该使用TickerProviderStateMixin。
class _ScaleAnimationRoute extends StatefulWidget {
  @override
  _ScaleAnimationState createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<_ScaleAnimationRoute>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller =
        new AnimationController(duration: Duration(seconds: 2), vsync: this);
    //使用弹性曲线
    animation = CurvedAnimation(parent: _controller, curve: Curves.bounceIn);
    //图片宽高从0变到300
    animation = new Tween(begin: 0.0, end: 300.0).animate(animation)
      ..addListener(() {
        setState(() {});
      });
    //启动动画(正向执行)
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/ic_eye_open.png",
          width: animation.value,
          height: animation.value,
        ),
      ),
    );
  }
}

///AnimatedBuilder重构 不用显式的去添加帧监听器、动画构建的范围缩小了等等
class _ScaleAnimationRoute1 extends StatefulWidget {
  @override
  _ScaleAnimationState1 createState() => _ScaleAnimationState1();
}

class _ScaleAnimationState1 extends State<_ScaleAnimationRoute1>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller =
        new AnimationController(duration: Duration(seconds: 2), vsync: this);
    //使用弹性曲线
    animation = CurvedAnimation(parent: _controller, curve: Curves.bounceIn);
    //图片宽高从0变到300
    animation = new Tween(begin: 0.0, end: 300.0).animate(animation)
      ..addStatusListener((status) {
        /*//反复执行
      if (status == AnimationStatus.completed) {
        //动画执行结束时反向执行动画
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        //动画恢复到初始状态时执行动画（正向）
        _controller.forward();
      }*/
      });
    //启动动画(正向执行)
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*body: AnimatedBuilder(
      animation: animation,
      child: Image.asset(
        "assets/ic_eye_open.png",
      ),
      builder: (context, child) {
        return Center(
          child: Container(
            width: animation.value,
            height: animation.value,
            child: child,
          ),
        );
      },
    )*/
      body: GrowTransition(
        animation: animation,
        child: Image.asset(
          "assets/ic_eye_open.png",
        ),
      ),
    );
  }
}

///封装通用放缩animation
class GrowTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  GrowTransition({this.child, this.animation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) {
          return Container(
            width: animation.value,
            height: animation.value,
            child: child,
          );
        },
      ),
    );
  }
}

///hero动画  Hero指的是可以在路由(页面)之间“飞行”的widget，
///简单来说Hero动画就是在路由切换时，有一个共享的widget可以在新旧路由间切换
class _HeroAnimationRouteA extends StatefulWidget {
  @override
  _HeroAnimationStateA createState() => _HeroAnimationStateA();
}

class _HeroAnimationStateA extends State<_HeroAnimationRouteA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        child: InkWell(
          child: Hero(
            tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
            child: Image.asset(
              "assets/ic_eye_open.png",
              width: 100.0,
              height: 100.0,
            ),
          ),
          onTap: () {
            //打开B路由
            Navigator.push(context, PageRouteBuilder(pageBuilder:
                (BuildContext context, Animation animation,
                    Animation secondaryAnimation) {
              return new FadeTransition(
                opacity: animation,
                child: _HeroAnimationRouteB(),
              );
            }));
          },
        ),
      ),
    );
  }
}

class _HeroAnimationRouteB extends StatefulWidget {
  @override
  _HeroAnimationStateB createState() => _HeroAnimationStateB();
}

class _HeroAnimationStateB extends State<_HeroAnimationRouteB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
          child: Image.asset("assets/ic_eye_open.png"),
        ),
      ),
    );
  }
}

///Stagger交织动画

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.controller}) : super(key: key) {
    height = Tween<double>(begin: 0.0, end: 300.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0, 0.6, //间隔，前60%的动画时间
          curve: Curves.ease,
        ),
      ),
    );
    color = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0, 0.6, //间隔，前60%的动画时间
          curve: Curves.ease,
        ),
      ),
    );
    padding = Tween<EdgeInsets>(
      begin: EdgeInsets.only(left: .0),
      end: EdgeInsets.only(left: 100.0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.6, 1.0, //间隔，后40%的动画时间
          curve: Curves.ease,
        ),
      ),
    );
  }

  final Animation<double> controller;
  Animation<double> height;
  Animation<Color> color;
  Animation<EdgeInsets> padding;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: padding.value,
      child: Container(
        color: color.value,
        height: height.value,
        width: 50.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: controller, builder: _buildAnimation);
  }
}

class _StaggerRoute extends StatefulWidget {
  @override
  _StaggerRouteState createState() => _StaggerRouteState();
}

class _StaggerRouteState extends State<_StaggerRoute>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
  }

  Future<Null> _playAnimation() async {
    try {
      //先正向执行动画
      await _controller.forward().orCancel;
      //再反向执行动画
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _playAnimation();
        },
        child: Center(
          child: Container(
            width: 300.0,
            height: 300.0,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: Border.all(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            //调用我们定义的交织动画Widget
            child: StaggerAnimation(controller: _controller),
          ),
        ),
      ),
    );
  }
}

///AnimatedSwitcher动画切换
class _AnimatedSwitcherRoute extends StatefulWidget {
  @override
  _AnimatedSwitcherState createState() => _AnimatedSwitcherState();
}

class _AnimatedSwitcherState extends State<_AnimatedSwitcherRoute> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              //放缩动画
              /*transitionBuilder: (Widget child, Animation<double> animation) {
                //执行缩放动画
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },*/
              //旧页面屏幕中向左侧平移退出，新页面重屏幕右侧平移进入，下面这种方式实现不了。
              /*transitionBuilder: (Widget child, Animation<double> animation){
                var tween = Tween<Offset>(begin: Offset(1,0),end: Offset(0,0));
                return SlideTransition(position: tween.animate(animation),child: child,);
              },*/
              //左上右下平移动画
              transitionBuilder: (Widget child, Animation<double> animation) {
                return MySlideTransition(
                  position: animation,
                  direction: AxisDirection.down,
                  child: child,
                );
              },
              child: Text(
                "$_count",
                //显示指定key，不同的key会被认为是不同的Text，这样才能执行动画
                key: ValueKey<int>(_count),
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            RaisedButton(
              child: const Text(
                '+1',
              ),
              onPressed: () {
                setState(() {
                  _count += 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MySlideTransition extends AnimatedWidget {
  MySlideTransition(
      {Key key,
      @required Animation<double> position,
      this.direction = AxisDirection.down,
      this.transformHitTests,
      this.child})
      : super(key: key, listenable: position) {
    switch (direction) {
      case AxisDirection.left:
        _tween = Tween(begin: Offset(1, 0), end: Offset(0, 0));
        break;
      case AxisDirection.up:
        _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
        break;
      case AxisDirection.right:
        _tween = Tween(begin: Offset(-1, 0), end: Offset(0, 0));
        break;
      case AxisDirection.down:
        _tween = Tween(begin: Offset(0, -1), end: Offset(0, 0));
        break;
    }
  }

  final bool transformHitTests;
  final Widget child;

  //退场方向
  final AxisDirection direction;
  Tween<Offset> _tween;

  Animation<double> get position => listenable;

  @override
  Widget build(BuildContext context) {
    Offset offset = _tween.evaluate(position);
    //动画反向执行时，调整x偏移，实现“从左边滑出隐藏”
    if (position.status == AnimationStatus.reverse) {
      switch (direction) {
        case AxisDirection.left:
        case AxisDirection.right:
          offset = Offset(-offset.dx, offset.dy);
          break;
        case AxisDirection.up:
        case AxisDirection.down:
          offset = Offset(offset.dx, -offset.dy);
          break;
      }
    }
    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}


class _AnimatedWidgetsTestRoute extends StatefulWidget {
  @override
  _AnimatedWidgetsTestState createState() => _AnimatedWidgetsTestState();
}

class _AnimatedWidgetsTestState extends State<_AnimatedWidgetsTestRoute> {
  double _padding = 10;
  var _align = Alignment.topRight;
  double _height = 100;
  double _left = 0;
  Color _color = Colors.red;
  TextStyle _style = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    var duration = Duration(seconds: 5);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 48.0)),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    _padding = 20;
                  });
                },
                child: AnimatedPadding(
                  duration: duration,
                  padding: EdgeInsets.all(_padding),
                  child: Text("AnimatedPadding"),
                ),
              ),
              SizedBox(
                height: 50,
                child: Stack(
                  children: <Widget>[
                    AnimatedPositioned(
                      duration: duration,
                      left: _left,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            _left = 100;
                          });
                        },
                        child: Text("AnimatedPositioned"),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 100,
                color: Colors.grey,
                child: AnimatedAlign(
                  duration: duration,
                  alignment: _align,
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        _align = Alignment.center;
                      });
                    },
                    child: Text("AnimatedAlign"),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: duration,
                height: _height,
                color: _color,
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _height = 150;
                      _color = Colors.blue;
                    });
                  },
                  child: Text(
                    "AnimatedContainer",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              AnimatedDefaultTextStyle(
                child: GestureDetector(
                  child: Text("hello world"),
                  onTap: () {
                    setState(() {
                      _style = TextStyle(
                        color: Colors.blue,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationColor: Colors.blue,
                      );
                    });
                  },
                ),
                style: _style,
                duration: duration,
              ),
            ]
        ),
      ),
    );
  }
}
