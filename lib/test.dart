import 'package:http/http.dart';

void main() {
  var map = {};
  Map<String, String> m = new Map<String, String>();
  m['d'] = "dd";
  print(m);
  var set = <String>{};
  set.add("aaa");
  set.add("bbb");
  print(set);

  final i = 3.14;
  final j = i * 3;
  //final只是要求变量在初始化后值不变，但通过final，我们无法在编译时（运行之前）知道这个变量的值
  final k = new DateTime.now();
  //const所修饰的是编译时常量，我们在编译时就已经知道了它的值，所以下面的编译不过
  // const k1 = new DateTime.now();
  print(j);

  enableFlags(bold: true);

  //异步
  Future.delayed(new Duration(seconds: 2), () {
    throw AssertionError("断言");
  }).then((value) =>
    {print(value)}
  ).catchError((e) {
    print("err = $e");
  }).whenComplete(() => //whenComplete无论成功失败都执行
    {print("object")}
  );
  
  //Stream 也是用于接收异步事件数据，和Future 不同的是，它可以接收多个异步操作的结果（成功或失败）
  Stream.fromFutures([
    Future.delayed(new Duration(seconds: 1),(){
      return "1. seconds = ${DateTime.now()}";
    }),

    Future.delayed(new Duration(seconds: 3),(){
      return "2. seconds = ${DateTime.now()}";
    }),

    Future.delayed(new Duration(seconds: 1),(){
      return "3. seconds = ${DateTime.now()}";
    })

  ]).listen((event) {
    print(event);
  },onError:(handleError){

  },onDone: (){
    print("onDone");
  });

  //异步
  loadData();

  print("object===============");

  //extents with implements
  C c = new C("name");
  c.printC();
}

//函数作为变量
var say = (str) {
  print(str);
};

//函数作为参数传递
void execute(var call) => call();

//可选的‘位置’参数
// 用[]标记为可选的位置参数，并放在参数列表的最后面：
String optParamFunction(String from, String msg, [String device]) {
  var result = '$from says $msg';
  if (device != null) {
    result = '$result with a $device';
  }
  return result;
}

//可选的‘命名’参数
//设置[bold]和[hidden]标志
void enableFlags({bool bold, bool hidden}) {
  // ...

  print("bold = $bold, hidden = $hidden");
}

/*
执行到loadData方法时，会同步进入方法内部进行执行，
当执行到await时就会停止async内部的执行，从而继续执行外面的代码。
当await有返回后，会继续从await的位置继续执行。所以await的操作，不会影响后面代码的执行。

 */
loadData() async {
  String dataURL = "https://jsonplaceholder.typicode.com/posts";
  Response response = await get(Uri.parse(dataURL));
  print(" =-========-=");
  print(" = ${response.body}");
}

////////////////////extents  with   implements///////////////////////////
class P{
  P(String name);
  void printP() => print("Im P");
}

class C extends P with B implements A{
  C(String name) : super(name);
  void printC() => print("Im C $n");

  @override
  void printA() {
    // TODO: implement printA
  }
}

class A{
  A(String name);
  void printA() => print("Im A");
}

class B{
  String n = "Bbbb";
  void printB() => print("Im B");
}