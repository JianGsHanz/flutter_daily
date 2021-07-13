import 'package:flutter/material.dart';
import 'package:flutter_app/testtest/count_model.dart';
import 'package:flutter_app/testtest/provider_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Provider());
}

class Provider extends StatelessWidget {
  const Provider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: ProviderUse(),
    );
  }
}

class ProviderUse extends StatefulWidget {
  const ProviderUse({Key key}) : super(key: key);

  @override
  _ProviderUseState createState() => _ProviderUseState();
}

class _ProviderUseState extends State<ProviderUse> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CountModel>(
      create: (_) => CountModel(),
      builder: (context, child){
        return Scaffold(
          appBar: AppBar(title: Text("appbar"),),
          body: Center(
            child: Column(
              children: [
                IconButton(icon: Icon(Icons.ac_unit_sharp), onPressed: (){}),
                // Consumer<CountModel>(builder: (context,model,child){
                //   return IconButton(icon: Icon(model.iconData), onPressed: (){
                //     model.change();
                //   });
                // }),
                ///selector<A,S> 只有对应的S - notify 相应的selector才会刷新
                ///下面两个selector S 不同，所以不会同时刷新，既非必要不刷新
                Selector<CountModel,IconData>(builder: (context,icon,child){
                  return IconButton(onPressed: (){
                    context.read<CountModel>().change();
                  }, icon: Icon(icon));
                }, selector: (context,model) => model.iconData),
                Selector<CountModel,int>(builder: (context,count,child){
                  return Text("num:$count");
                }, selector: (context,model) => model.count),
                // Consumer<CountModel>(builder: (context,model,child){
                //   return Text("num:${model.count}");
                // }),

                RaisedButton(
                  onPressed: () {
                    context.read<CountModel>().add();
                  },
                  child: Text("+1"),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
