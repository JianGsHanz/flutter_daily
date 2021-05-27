import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(ScrollApp());
}

class ScrollApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListViewApp(),
    );
  }
}

class ListViewApp extends StatefulWidget {
  @override
  _ListViewApp createState() => _ListViewApp();
}

class _ListViewApp extends State<ListViewApp> {
  String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ";
  String str1 = "张王李赵钱孙李";
  List<String> _list, _list1;
  Widget divider = Divider(color: Colors.green);

  int _index = 0;

  List<IconData> _icons = [
    Icons.ac_unit,
    Icons.airport_shuttle,
    Icons.all_inclusive,
    Icons.beach_access,
    Icons.cake,
    Icons.free_breakfast
  ];

  ScrollController _scrollController = new ScrollController();
  bool showButton = false;

  DateTime _lastClickAt; //最后点击时间

  @override
  void initState() {
    super.initState();
    _list = str.split("");
    _list1 = str1.split("");

    _scrollController.addListener(() {
      print("zyh-${_scrollController.offset}");
      if (_scrollController.offset > 1000 && !showButton) {
        setState(() {
          showButton = true;
        });
      } else if (_scrollController.offset < 1000 && showButton) {
        setState(() {
          showButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            height: 100,
            child: Align(
              alignment: FractionalOffset(0.5, 0.7), //居中向下偏移
              child: Text(
                "Scroll",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _index = 0;
                        });
                      },
                      color: Colors.blueGrey,
                      child: Text("ListViewBuilder")),
                  margin: EdgeInsets.only(left: 10, right: 10),
                ),
                Container(
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _index = 1;
                        });
                      },
                      color: Colors.blueGrey,
                      child: Text("ListViewSeparated")),
                  margin: EdgeInsets.only(right: 10),
                ),
                Container(
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _index = 2;
                        });
                      },
                      color: Colors.blueGrey,
                      child: Text("GridViewBuilder")),
                  margin: EdgeInsets.only(right: 10),
                ),
                Container(
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _index = 3;
                        });
                      },
                      color: Colors.blueGrey,
                      child: Text("GridViewCount")),
                  margin: EdgeInsets.only(right: 10),
                ),
                Container(
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _index = 4;
                        });
                      },
                      color: Colors.blueGrey,
                      child: Text("GridViewExtent")),
                  margin: EdgeInsets.only(right: 10),
                ),
                Container(
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _index = 5;
                        });
                      },
                      color: Colors.blueGrey,
                      child: Text("CustomScrollView")),
                  margin: EdgeInsets.only(right: 10),
                ),
                Container(
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _index = 6;
                        });
                      },
                      color: Colors.blueGrey,
                      child: Text("滚动监听ScrollController")),
                  margin: EdgeInsets.only(right: 10),
                ),
              ],
            ),
          ),
          Expanded(
            child: switchList(_index),
          )
        ],
      ),
    );
  }

  Widget switchList(int index) {
    switch (_index) {
      case 0:
        return getListViewBuilder();
      case 1:
        return getListViewSeparated();
      case 2:
        return getGridViewBuilder();
      case 3:
        return getGridViewCount();
      case 4:
        return getGridViewExtent();
      case 5:
        return getCustomScrollView();
      case 6:
        return scrollController();
    }
  }

  ListView getListViewBuilder() => ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_list[index]),
          );
        },
        itemCount: _list.length,
      );

  ListView getListViewSeparated() => ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            _list1[index],
            textAlign: TextAlign.center,
          ),
          tileColor: Colors.blue,
        );
      },
      separatorBuilder: (context, index) {
        return divider;
      },
      itemCount: _list1.length);

  GridView getGridViewBuilder() => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 1.0),
        itemCount: _icons.length,
        itemBuilder: (context, index) {
          return Icon(_icons[index]);
        },
      );

  //GridView.count构造函数内部使用了SliverGridDelegateWithFixedCrossAxisCount
  //SliverGridDelegateWithMaxCrossAxisExtent 水平方向元素个数固定
  GridView getGridViewCount() => GridView.count(
        crossAxisCount: 3,
        //指定横轴三个子widget
        childAspectRatio: 1.0,
        //宽高比
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          Container(
            color: Colors.blue,
            child: Text("1"),
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.blue,
            child: Text("2"),
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.blue,
            child: Text("3"),
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.blue,
            child: Text("4"),
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.blue,
            child: Text("5"),
            alignment: Alignment.center,
          ),
        ],
      );

  //GridView.extent构造函数内部使用了SliverGridDelegateWithMaxCrossAxisExtent，
  //SliverGridDelegateWithMaxCrossAxisExtent 水平方向元素个数不再固定，
  // 其水平个数也就是有几列，由maxCrossAxisExtent和屏幕的宽度以及padding和mainAxisSpacing等决定
  GridView getGridViewExtent() => GridView.extent(
        maxCrossAxisExtent: 60,
        childAspectRatio: 1.0,
        //宽高比
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          Container(
            color: Colors.deepOrange,
            child: Text("1"),
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.deepOrange,
            child: Text("2"),
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.deepOrange,
            child: Text("3"),
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.deepOrange,
            child: Text("4"),
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.deepOrange,
            child: Text("5"),
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.deepOrange,
            child: Text("6"),
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.deepOrange,
            child: Text("7"),
            alignment: Alignment.center,
          ),
        ],
      );

  CustomScrollView getCustomScrollView() => CustomScrollView(
        slivers: [
          //AppBar，包含一个导航栏
          SliverAppBar(
            pinned: true,
            bottom: PreferredSize(
              preferredSize: Size(20, 20),
              child: Text(''),
            ),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('FlexibleSpaceBar'),
              background: Image.network(
                "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
                fit: BoxFit.fill,
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.all(10.0),
            sliver: new SliverGrid(
                //Grid
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      color: Colors.cyan[100 * (index % 9)],
                      child: new Text('grid item $index'),
                    );
                  },
                  childCount: 20,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisCount: 4, //Grid按列显示
                    crossAxisSpacing: 10,
                    childAspectRatio: 3 //宽高比
                    )),
          ),

          //HorizontalListView
          new SliverToBoxAdapter(
            child: Container(
              height: 100.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.lightBlue[100 * (index % 9)],
                    width: 100.0,
                    child: Card(
                      child: Text('data'),
                    ),
                  );
                },
              ),
            ),
          ),

          //List
          new SliverFixedExtentList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.lightBlue[100 * (index % 9)],
                  child: new Text('list item $index'),
                );
              }, childCount: 50),
              itemExtent: 50),
        ],
      );

  WillPopScope scrollController() => WillPopScope(
      child: Scaffold(
        body: Scrollbar(
          child: ListView.builder(
            key: PageStorageKey(1),
            //为可滚动组件保存其滚动位置
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_list[index]),
              );
            },
            itemCount: _list.length,
            itemExtent: 40.0,
            controller: _scrollController,
          ),
        ),
        floatingActionButton: !showButton
            ? null
            : FloatingActionButton(
                onPressed: () {
                  _scrollController.jumpTo(0);
                  //返回到顶部时执行动画
                  // _scrollController.animateTo(.0,
                  //     duration: Duration(milliseconds: 200),
                  //     curve: Curves.ease
                  // );
                },
                child: Icon(Icons.arrow_upward),
              ),
      ),
      onWillPop: () async {
        if (_lastClickAt == null ||
            DateTime.now().difference(_lastClickAt) > Duration(seconds: 2)) {
          _lastClickAt = DateTime.now();
          Fluttertoast.showToast(msg: "再按一次退出");
          return false;
        }
        return true;
      });
}
