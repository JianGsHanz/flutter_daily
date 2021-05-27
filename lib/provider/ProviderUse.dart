import 'package:flutter/material.dart';
import 'package:flutter_app/provider/CartModel.dart';
import 'package:flutter_app/provider/ChangeNotifierProvider.dart';
import 'package:flutter_app/provider/Consumer.dart';
import 'package:flutter_app/provider/Item.dart';

void main() {
  runApp(ProviderApp());
}

class ProviderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      home: ProviderRoute(),
    );
  }
}

class ProviderRoute extends StatefulWidget {
  @override
  _ProviderRoute createState() => _ProviderRoute();
}
/// Model变化后会自动通知ChangeNotifierProvider（订阅者），
/// ChangeNotifierProvider内部会重新构建InheritedWidget，
/// 而依赖该InheritedWidget的子孙Widget就会更新。
class _ProviderRoute extends State<ProviderRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ChangeNotifierProvider<CartModel>(
          data: CartModel(),
          child: Builder(builder: (context){
            return Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 100)),
                //不优雅
                // Text("总价：${ChangeNotifierProvider.of<CartModel>(context).totalPrice}"),
                Consumer<CartModel>(builder: (context,cart) => Text("总价：${cart.totalPrice}")),
                RaisedButton(onPressed: (){
                  ChangeNotifierProvider.of<CartModel>(context,listen: false).add(Item(25.0, 2));
                },child: Text("添加商品"),),
              ],
            );
          },),
        ),
      ),
    );
  }
}
