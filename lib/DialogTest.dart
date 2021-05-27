import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(DialogApp());
}

class DialogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DialogRoute(),
    );
  }
}

class DialogRoute extends StatefulWidget {
  @override
  _DialogRoute createState() => _DialogRoute();
}

class _DialogRoute extends State<DialogRoute> {
  bool withTree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.lightGreen,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
              onPressed: () async {
                var b = await showCancelConfirmDialog();
                if (b) {
                  Fluttertoast.showToast(msg: "确认");
                } else {
                  Fluttertoast.showToast(msg: "取消");
                }
              },
              child: Text("AlertDialog")),
          RaisedButton(
              onPressed: () async {
                var i = await showItemDialog();
                if (i == 1) {
                  Fluttertoast.showToast(msg: "中文简体");
                } else {
                  Fluttertoast.showToast(msg: "中文繁体");
                }
              },
              child: Text("SimpleDialog")),
          RaisedButton(
              onPressed: () async {
                await showListDialog();
                //不用Dialog的另一种实现
                // await showListDialog1();
              },
              child: Text("ListDialog")),
          RaisedButton(
              onPressed: () {
                showLoadingDialog();
              },
              child: Text("LoadingDialog")),
          RaisedButton(
              onPressed: () async {
                var b = await showCustomDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("CustomDialog"),
                        content: Text("你是zhu"),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: Text("是")),
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: Text("不是"))
                        ],
                      );
                    });
                b
                    ? Fluttertoast.showToast(msg: "是")
                    : Fluttertoast.showToast(msg: "不是");
              },
              child: Text("CustomDialog")),
          RaisedButton(
              onPressed: () {
                showCheckboxDialog();
              },
              child: Text("CheckboxDialog")),
          RaisedButton(onPressed: () async{
            var i = await showBottomDialog();
            Fluttertoast.showToast(msg: "click = ${i}");
          }, child: Text("BottomDialog")),
        ],
      ),
    ));
  }

  Future<bool> showCancelConfirmDialog() {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示"),
            content: Text("我是内容容"),
            actions: [
              FlatButton(
                  onPressed: () {
                    // 关闭对话框
                    Navigator.of(context).pop(false);
                  },
                  child: Text("取消")),
              FlatButton(
                  onPressed: () {
                    //关闭对话框并返回true
                    Navigator.of(context).pop(true);
                  },
                  child: Text("确认")),
            ],
          );
        });
  }

  Future<int> showItemDialog() {
    return showDialog<int>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("选择语言"),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text("中文简体"),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 2);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text("中文繁体"),
                ),
              ),
            ],
          );
        });
  }

  Future<void> showListDialog() {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return Dialog(
            child: new Column(
              children: [
                ListTile(
                  title: Text("请选择"),
                ),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text("$index"),
                    onTap: () {
                      Fluttertoast.showToast(msg: "选择了 ${index}");
                    },
                  ),
                  itemCount: 30,
                )),
              ],
            ),
          );
        });
  }

  //不用Dialog的另一种实现
  Future<void> showListDialog1() {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return UnconstrainedBox(
            constrainedAxis: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 280),
              child: Material(
                child: Column(
                  children: [
                    ListTile(
                      title: Text("请选择"),
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) => ListTile(
                        title: Text("$index"),
                        onTap: () {
                          Fluttertoast.showToast(msg: "选择了 ${index}");
                        },
                      ),
                      itemCount: 30,
                    )),
                  ],
                ),
                type: MaterialType.card,
              ),
            ),
          );
        });
  }

  showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, //点击遮罩不关闭对话框
      builder: (context) {
        return UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: SizedBox(
            width: 280,
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 26.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 26.0),
                    child: Text("正在加载，请稍后..."),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //自定义dialog动画及遮罩
  Future<T> showCustomDialog<T>({
    @required BuildContext context,
    bool barrierDismissible = true,
    WidgetBuilder builder,
  }) {
    final ThemeData theme = Theme.of(context);
    return showGeneralDialog<T>(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          final Widget pageChild = Builder(builder: builder);
          return SafeArea(
            //适配异形屏
            child: Builder(
              builder: (context) {
                return theme != null
                    ? Theme(
                        data: theme,
                        child: pageChild,
                      )
                    : pageChild;
              },
            ),
          );
        },
        barrierDismissible: barrierDismissible,
        //点击遮罩是否关闭对话框
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        // 语义化标签(用于读屏软件)
        barrierColor: Colors.black87,
        // 自定义遮罩颜色
        transitionDuration: const Duration(milliseconds: 150),
        // 对话框打开/关闭的动画时长
        transitionBuilder: _buildMaterialDialogTransitions);
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // 使用缩放动画
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  Future<bool> showCheckboxDialog() {
    withTree = false; // 默认复选框不选中
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("您确定要删除当前文件吗?"),
              Row(
                children: <Widget>[
                  Text("同时删除子目录？"),
                  //方式一 只刷新当前widget
                  // StatefulBuilder(
                  //   builder: (context,setState){
                  //     return Checkbox(
                  //       value: withTree,
                  //       onChanged: (bool value) {
                  //         //复选框选中状态发生变化时重新构建UI
                  //         setState(() {
                  //           //更新复选框状态
                  //           withTree = !withTree;
                  //         });
                  //       },
                  //     );
                  //   },
                  // ),

                  //方式二 刷新全部UI组件 不是最优
                  // Checkbox(
                  //     value: withTree,
                  //     onChanged: (bool value) {
                  //       setState(() {
                  //         // 此时context为对话框UI的根Element，我们
                  //         // 直接将对话框UI对应的Element标记为dirty
                  //         (context as Element).markNeedsBuild();
                  //         withTree = !withTree;
                  //       });
                  //     }),
                  //方式三 最优 ：通过Builder来获得构建Checkbox的`context`，这是一种常用的缩小`context`范围的方式
                  Builder(builder: (context) {
                    return Checkbox(
                      value: withTree,
                      onChanged: (bool value) {
                        //复选框选中状态发生变化时重新构建UI
                        (context as Element).markNeedsBuild();
                        //更新复选框状态
                        withTree = !withTree;
                      },
                    );
                  }),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text("删除"),
              onPressed: () {
                //执行删除操作
                Navigator.of(context).pop(withTree);
              },
            ),
          ],
        );
      },
    );
  }


  Future<int> showBottomDialog(){
    return showModalBottomSheet<int>(context: context, builder: (context){
      return ListView.builder(itemBuilder: (context,index){
        return ListTile(title: Text("${index}"),onTap: (){
          Navigator.pop(context,index);
        },);
      },itemCount: 30,);
    });
  }
}
