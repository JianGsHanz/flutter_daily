import 'package:flutter/widgets.dart';
import 'package:flutter_app/provider/Item.dart';

class CartModel extends ChangeNotifier {
  // 用于保存购物车中商品列表
  final List<Item> _items = [];

  double get totalPrice => _items.fold(0, (value, item){
    print("zyh ---- value = ${value}, item = ${item.toString()}");
    return value + item.count * item.price;
  });

  // 将 [item] 添加到购物车。这是唯一一种能从外部改变购物车的方法。
  void add(Item item){
    _items.add(item);
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }
}
