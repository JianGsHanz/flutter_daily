import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(WidgetListApp());
}

class WidgetListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WidgetList',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: WidgetList(),
    );
  }
}

class WidgetList extends StatefulWidget {
  @override
  _WidgetListState createState() => _WidgetListState();
}

class _WidgetListState extends State<WidgetList>
    with SingleTickerProviderStateMixin {
  bool _switchSelected = true;
  bool _checkboxSelected = true;

  //onChanged是专门用于监听文本变化，而controller的功能却多一些，除了能监听文本变化外，它还可以设置默认值、选择文本
  TextEditingController _textFieldController = new TextEditingController();

  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _textFieldController.text = 'zhangyaohua';
    _textFieldController.selection = TextSelection(
        baseOffset: 2, extentOffset: _textFieldController.text.length);
    //监听输入改变
    _textFieldController.addListener(() {});

    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    //正向播放动画，播完即停止
    // _animationController.forward();
    //反向播放动画，播完即停止
    // AnimationController.reverse()
    //从头开始循环
    _animationController.repeat();

    _animationController.addListener(() => setState(() => {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WidgetList'),
      ),
      body: Scrollbar(
        thickness: 6.0,
        child: SingleChildScrollView(
          child: new Center(
            child: new Column(
              children: [
                new Text("TextSpan"),
                new Text.rich(TextSpan(children: [
                  TextSpan(text: 'hello '),
                  TextSpan(text: 'word\n', style: TextStyle(color: Colors.red)),
                ])),
                new Text("Image"),
                new Image.asset(
                  'assets/ic_eye_open.png',
                  width: 30,
                  height: 30,
                ),
                new Image.network(
                  "https://t7.baidu.com/it/u=993577982,1027868784&fm=193&f=GIF",
                  width: 30,
                  height: 30,
                ),
                new Text("\nButton"),
                new RaisedButton(
                    child: Text('RaisedButton'),
                    color: Colors.amber,
                    onPressed: () {}),
                new FlatButton(
                    child: Text('FlatButton'),
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () {}),
                new OutlineButton(
                    child: Text('OutlineButton'),
                    color: Colors.amber,
                    borderSide:
                        BorderSide(color: Colors.lightGreen, width: 2.0),
                    //边框
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    //圆角
                    onPressed: () {}),
                new IconButton(
                    icon: Icon(
                      Icons.error,
                      color: Colors.lightGreen,
                    ),
                    onPressed: () {}),
                new IconButton(
                    icon: Image.asset('assets/ic_bought.png'),
                    onPressed: () {}),
                new FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                    label: Text('错误')),
                new Text("Switch:$_switchSelected"),
                new Switch(
                    value: _switchSelected,
                    onChanged: (value) {
                      setState(() {
                        _switchSelected = value;
                      });
                    }),
                new Text("Checkbox:$_checkboxSelected"),
                new Checkbox(
                    value: _checkboxSelected,
                    activeColor: Colors.red, //选中时的颜色
                    onChanged: (value) {
                      setState(() {
                        _checkboxSelected = value;
                      });
                    }),
                new Text('TextField\n'),
                new Container(
                  margin: EdgeInsets.only(left: 50.0, right: 50.0),
                  child: TextField(
                    controller: _textFieldController,
                    //通过controller监听文本
                    autofocus: false,
                    cursorColor: Color(0xFF7ECC02),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        prefixIcon: Icon(Icons.supervised_user_circle),
                        labelText: "输入",
                        suffixIcon: IconButton(
                            icon: Icon(Icons.close),
                            splashColor: Color(0x00000000), //按下溅起颜色
                            onPressed: () {
                              if (_textFieldController.text != null &&
                                  _textFieldController.text.isNotEmpty) {
                                Fluttertoast.showToast(
                                    msg: _textFieldController.text);
                                _textFieldController.clear();
                              }
                            })),
                    onChanged: (v) {
                      //文字改变监听
                      Fluttertoast.showToast(msg: v);
                    },
                  ),
                ),
                new Text('\n表单Form'),
                new Form(
                  key: _formKey, //设置globalKey，用于后面获取FormState
                  autovalidate: true, //开启自动校验
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          autofocus: false,
                          // controller: _unameController,
                          decoration: InputDecoration(
                              labelText: "用户名",
                              hintText: "用户名或邮箱",
                              icon: Icon(Icons.person)),
                          // 校验用户名
                          validator: (v) {
                            return v.trim().length > 0 ? null : "用户名不能为空";
                          }),
                      TextFormField(
                          // controller: _pwdController,
                          decoration: InputDecoration(
                              labelText: "密码",
                              hintText: "您的登录密码",
                              icon: Icon(Icons.lock)),
                          obscureText: true,
                          //校验密码
                          validator: (v) {
                            return v.trim().length > 5 ? null : "密码不能少于6位";
                          }),
                      // 登录按钮
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                padding: EdgeInsets.all(15.0),
                                child: Text("登录"),
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                onPressed: () {
                                  //在这里不能通过此方式获取FormState，context不对
                                  //print(Form.of(context));

                                  // 通过_formKey.currentState 获取FormState后，
                                  // 调用validate()方法校验用户名密码是否合法，校验
                                  // 通过后再提交数据。
                                  if ((_formKey.currentState as FormState)
                                      .validate()) {
                                    //验证通过提交数据
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Text('\nProgressBar\n'),
                      // 模糊进度条(会执行一个动画)
                      new LinearProgressIndicator(
                        backgroundColor: Colors.black12,
                        valueColor: AlwaysStoppedAnimation(Colors.amber),
                        minHeight: 3,
                      ),
                      //进度条显示50%
                      new LinearProgressIndicator(
                        backgroundColor: Colors.black12,
                        valueColor: AlwaysStoppedAnimation(Colors.amber),
                        minHeight: 20,
                        value: .5, //进度条显示50%
                      ),

                      new CircularProgressIndicator(
                        backgroundColor: Colors.black12,
                        valueColor: AlwaysStoppedAnimation(Colors.amber),
                        strokeWidth: 4.0,
                      ),
                      //静止进度条显示50%
                      new CircularProgressIndicator(
                        backgroundColor: Colors.black12,
                        valueColor: AlwaysStoppedAnimation(Colors.amber),
                        strokeWidth: 4.0,
                        value: .5,
                      ),

                      new Text('\n自定义ProgressBar\n'),
                      new SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black12,
                          valueColor: AlwaysStoppedAnimation(Colors.amber),
                        ),
                      ),
                      new CircularProgressIndicator(
                        backgroundColor: Colors.black12,
                        valueColor: ColorTween(
                                begin: Colors.lightGreen, end: Colors.amber)
                            .animate(_animationController),
                        value: _animationController.value,
                      ),

                      new Text('\n线性布局(Column&Row)\n'),
                      /*Row和Column都只会在主轴方向占用尽可能大的空间，而纵轴的长度则取决于他们最大子元素的长度*/
                      new Column(
                        children: [
                          Container(
                            color: Colors.lightGreen,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("MainAxisAlignment:"),
                                Text("center"),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.amberAccent,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("MainAxisAlignment:"),
                                Text("start"),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.cyan,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              //Row的高度（crossAxisAlignment纵轴）等于子组件中最高的子元素高度
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("MainAxisAlignment:"),
                                Text("end"),
                              ],
                            ),
                          ),
                          new Text('\n弹性布局(Flex)\n'),
                          new Container(
                            height: 100,
                            child: Flex(
                              direction: Axis.vertical,
                              children: [
                                Expanded(
                                    child: Container(
                                      color: Colors.red,
                                    ),
                                    flex: 2),
                                Spacer(
                                  flex: 1,
                                ), //分割（占用指定比例的空间）
                                Expanded(
                                    child: Container(
                                      color: Colors.blue,
                                    ),
                                    flex: 1)
                              ],
                            ),
                          ),
                          new Container(
                            height: 50,
                            margin: EdgeInsets.only(top: 20),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                    child: Container(
                                      color: Colors.red,
                                    ),
                                    flex: 2),
                                Spacer(
                                  flex: 1,
                                ),
                                Expanded(
                                    child: Container(
                                      color: Colors.blue,
                                    ),
                                    flex: 1),
                                Expanded(
                                    child: Container(
                                      color: Colors.blueGrey,
                                    ),
                                    flex: 1)
                              ],
                            ),
                          ),
                          new Text('\n流式布局(Wrap&Flow)\n'),
                          new Wrap(
                            spacing: 8.0,
                            runSpacing: 5.0,
                            runAlignment: WrapAlignment.center,
                            children: [
                              Chip(
                                label: Text("Chip-1"),
                                avatar: CircleAvatar(
                                  child: Text('Z'),
                                  backgroundColor: Colors.blueGrey,
                                ),
                              ),
                              Chip(
                                label: Text("Chip-2"),
                                avatar: CircleAvatar(
                                  child: Text('Y'),
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                              Chip(
                                label: Text("Chip-3"),
                                avatar: CircleAvatar(
                                  child: Text('H'),
                                  backgroundColor: Colors.red,
                                ),
                              ),
                              Chip(
                                label: Text("Chip-4"),
                                avatar: CircleAvatar(
                                  child: Text('Y'),
                                  backgroundColor: Colors.lightGreen,
                                ),
                              ),
                              Chip(
                                label: Text("Chip-5"),
                                avatar: CircleAvatar(
                                  child: Text('H'),
                                ),
                              ),
                            ],
                          ),
                          Flow(
                            delegate:
                                TestFlowDelegate(margin: EdgeInsets.all(10.0)),
                            children: <Widget>[
                              new Container(
                                width: 80.0,
                                height: 80.0,
                                color: Colors.red,
                              ),
                              new Container(
                                width: 80.0,
                                height: 80.0,
                                color: Colors.green,
                              ),
                              new Container(
                                width: 80.0,
                                height: 80.0,
                                color: Colors.blue,
                              ),
                              new Container(
                                width: 80.0,
                                height: 80.0,
                                color: Colors.yellow,
                              ),
                              new Container(
                                width: 80.0,
                                height: 80.0,
                                color: Colors.brown,
                              ),
                              new Container(
                                width: 80.0,
                                height: 80.0,
                                color: Colors.purple,
                              ),
                            ],
                          ),
                          new Text('\n层叠布局(Stack&Positioned)\n'),
                          new Container(
                            width: double.infinity,
                            height: 200,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  color: Colors.cyanAccent,
                                  child: Text('Container'),
                                ),
                                Container(
                                  child: Text('叠在一起'),
                                ),
                                Positioned(
                                  child: Text(
                                    'left20',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  left: 20,
                                  top: 0,
                                ),
                                Positioned(
                                  child: Text(
                                    'left30 top20',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  left: 20,
                                  top: 20,
                                ),
                                Positioned(
                                  child: Text(
                                    'right10 bottom20',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  right: 10,
                                  bottom: 20,
                                ),
                              ],
                            ),
                          ),

                          /*Stack可以有多个子元素，并且子元素可以堆叠，而Align只能有一个子元素，不存在堆叠*/
                          new Text('\n相对定位(Align)\n'),
                          new Text('固定左上右下'),
                          new Container(
                            color: Colors.cyanAccent,
                            child: Align(
                              widthFactor: 2,
                              heightFactor: 2,
                              alignment: Alignment.bottomLeft,
                              child: FlutterLogo(
                                size: 60,
                              ),
                            ),
                          ),
                          new Text('偏移'),
                          new Container(
                            width: 120,
                            height: 120,
                            color: Colors.cyanAccent,
                            child: Align(
                              alignment: FractionalOffset(0.2, 0.6),
                              child: FlutterLogo(
                                size: 60,
                              ),
                            ),
                          ),
                          new Text('\nPadding\n'),
                          new Container(
                            color: Colors.blueGrey,
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, bottom: 20),
                                    child: Container(
                                      child: Text("EdgeInsets.only(left: 20)"),
                                      color: Colors.lightGreen,
                                    ),
                                  ),
                                  Padding(
                                    //上下各添加20像素补白
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                        "EdgeInsets.symmetric(vertical: 20)"),
                                  ),
                                  Padding(
                                    // 分别指定四个方向的补白
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 10, 20, 20),
                                    child:
                                        Text("EdgeInsets.fromLTRB(0,10,20,20)"),
                                  )
                                ],
                              ),
                            ),
                          ),
                          new Text('\n尺寸限制容器\n'),
                          new Text('ConstrainedBox'),
                          new ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: 20, minHeight: 50),
                            child: Container(
                              //这里的width，height受BoxConstraints的最小宽度、高度限制（如果小于则显示最小宽高度，大于显示实际宽高度）
                              width: 10,
                              height: 10,
                              color: Colors.black,
                            ),
                          ),
                          new Text('SizedBox'),
                          SizedBox(
                            width: 50,
                            height: 40,
                            child: Container(
                              color: Colors.purple,
                            ),
                          ),
                          //SizedBox只是ConstrainedBox的一个定制，上面代码等价于：
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: Container(
                              color: Colors.purple,
                            ),
                          ),
                          //多重限制时，对于minWidth和minHeight来说，是取父子中相应数值较大的。实际上，只有这样才能保证父限制与子限制不冲突。
                          new Text('多重限制ConstrainedBox'),
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: 90.0, minHeight: 20.0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth: 60.0, minHeight: 60.0),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: Colors.red),
                                ),
                              )),
                          new Text('去除多重限制ConstrainedBox'),
                          //去除多重限制 UnconstrainedBox
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: 90.0, minHeight: 20.0),
                            child: UnconstrainedBox(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth: 60.0, minHeight: 60.0),
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.lightGreen),
                                ),
                              ),
                            ),
                          ),

                          new Text('\n装饰容器DecoratedBox\n'),
                          new DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.blueGrey, Colors.blue]),
                              //渐变
                              borderRadius:
                                  BorderRadiusDirectional.circular(5.0),
                              //圆角
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black54,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 5.0)
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 80.0, vertical: 18.0),
                              child: Text("click"),
                            ),
                          )
                        ],
                      ),
                      new Text('\nContainer\n'),
                      new Container(
                        margin: EdgeInsets.only(
                            top: 20.0, left: 120.0, bottom: 100.0),
                        //容器外填充
                        constraints: BoxConstraints.tightFor(
                            width: 200.0, height: 150.0),
                        //卡片大小
                        decoration: BoxDecoration(
                            //背景装饰
                            gradient: RadialGradient(
                                //背景径向渐变
                                colors: [Colors.red, Colors.orange],
                                center: Alignment.topLeft,
                                radius: .98),
                            boxShadow: [
                              //卡片阴影
                              BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 4.0)
                            ]),
                        transform: Matrix4.rotationZ(.2),
                        //卡片倾斜变换
                        alignment: Alignment.center,
                        //卡片内文字居中
                        child: Text(
                          //卡片文字
                          "5.20",
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TestFlowDelegate extends FlowDelegate {
  EdgeInsets margin = EdgeInsets.zero;

  TestFlowDelegate({this.margin});

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = margin.left;
    var y = margin.top;
    //计算每一个子widget的位置
    for (int i = 0; i < context.childCount; i++) {
      var w = context.getChildSize(i).width + x + margin.right;
      if (w < context.size.width) {
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0.0));
        x = w + margin.left;
      } else {
        x = margin.left;
        y += context.getChildSize(i).height + margin.top + margin.bottom;
        //绘制子widget(有优化)
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i).width + margin.left + margin.right;
      }
    }
  }

  @override
  getSize(BoxConstraints constraints) {
    //指定Flow的大小
    return Size(double.infinity, 200.0);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
