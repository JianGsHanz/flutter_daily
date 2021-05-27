import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(InheritedWidgetApp());
}

class InheritedWidgetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InheritedWidgetTestRoute(),
    );
  }
}

class InheritedWidgetTestRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InheritedWidgetTestRouteState();
}

class _InheritedWidgetTestRouteState extends State<InheritedWidgetTestRoute> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShareDataWidget( //使用ShareDataWidget
        data: count,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(),//子widget中依赖ShareDataWidget
            RaisedButtonT(onTap: (){ //RaisedButtonT意在查看回调情况
              setState(() {
                //每点击一次，将count自增，然后重新build,ShareDataWidget的data将被更新
                count++;
              });
            },)
          ],
        ),
      ),
    );
  }
}

class RaisedButtonT extends StatefulWidget{
  VoidCallback onTap;
  RaisedButtonT({this.onTap});

  @override
  State<StatefulWidget> createState() =>_RaisedButtonT();

}

class _RaisedButtonT extends State<RaisedButtonT>{
  @override
  Widget build(BuildContext context) {
    print("zyh _RaisedButtonT build");
    return RaisedButton(onPressed: widget.onTap,child: Text("CustomButton"),);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    print("zyh  Button didChangeDependencies===");
  }
}

class TextWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    print("zyh TextWidget build");
    //使用InheritedWidget中的共享数据
    return Text(ShareDataWidget.of(context).data.toString());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //父或祖先widget中的InheritedWidget改变(updateShouldNotify返回true)时会被调用。
    //如果build中没有依赖InheritedWidget，则此回调不会被调用。
    print("zyh didChangeDependencies == ");
  }
}

class ShareDataWidget extends InheritedWidget {
  ShareDataWidget({@required this.data, Widget child}) : super(child: child);

  final int data; //需要在子树中共享的数据，保存点击次数

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static ShareDataWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShareDataWidget>();

  //该回调决定当data发生变化时，是否通知子树中依赖data的Widget
  @override
  bool updateShouldNotify(covariant ShareDataWidget old) {
    //如果返回true，则子树中依赖(build函数中有调用)本widget
    //的子widget的`state.didChangeDependencies`会被调用
    return old.data != data;
  }
}
