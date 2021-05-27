import 'package:flutter/material.dart';
import 'package:flutter_app/provider/ChangeNotifierProvider.dart';

// 这是一个便捷类，会获得当前context和指定数据类型的Provider
class Consumer<T> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return builder(
        context,
        //自动获取Model
        ChangeNotifierProvider.of<T>(context));
  }

  final Widget child;
  final Widget Function(BuildContext context, T value) builder;

  Consumer({Key key, @required this.builder, this.child}) : super(key: key);
}
