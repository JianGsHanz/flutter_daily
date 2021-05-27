import 'package:flutter/widgets.dart';

// 一个通用的InheritedWidget，保存任意需要跨组件共享的状态
class InheritedProvider<T> extends InheritedWidget{

  //需要保存的共享状态，使用泛型
  final T data;

  InheritedProvider({this.data,Widget child}):super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    //在此简单返回true，则每次更新都会调用依赖其的子孙节点的`didChangeDependencies`。
    return true;
  }
}