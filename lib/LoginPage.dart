import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Temp1.dart';

void main() {
  runApp(LoginPageApp());
}

class LoginPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'login',
      theme: ThemeData(primaryColor: Color(0xFF7ECC02)),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  String user;
  String pwd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          new Stack(
            overflow: Overflow.visible,
            children: [
              new Container(
                child: Image.asset(
                  "assets/ic_login_bg.png",
                ),
                width: double.infinity,
              ),
              new Container(
                child: Image.asset(
                  "assets/ic_eye_open.png",
                ),
                width: 114,
                height: 109,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 60),
                constraints: BoxConstraints(minWidth: double.infinity),
              ),
            ],
          ),
          new Container(
            child: new TextField(
              cursorColor: Color(0xFF7ECC02),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                prefixIcon: Icon(Icons.supervised_user_circle),
                labelText: "输入用户名",
              ),
              autofocus: false,
              onChanged: _userFieldChanged,
            ),
            margin: EdgeInsets.all(20.0),
          ),
          new Container(
            child: new TextField(
              cursorColor: Color(0xFF7ECC02),
              autofocus: false,
              onChanged: _pwdFieldChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                prefixIcon: Icon(Icons.lock),
                labelText: "请输入密码",
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true, //密码***
            ),
            margin: EdgeInsets.only(left: 20, right: 20),
          ),
          new Container(
            height: 50,
            child: new ElevatedButton(
              onPressed: () {
                if (user == null || pwd == null) {
                  Fluttertoast.showToast(
                      msg: "用户名或密码为空~", gravity: ToastGravity.CENTER);
                  return;
                }
                if (user == "zyh" && pwd == "123") {
                  Fluttertoast.showToast(
                      msg: "登录成功~", gravity: ToastGravity.CENTER);
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                    return MyApp();
                  }));
                } else {
                  Fluttertoast.showToast(
                      msg: "用户名或密码错误~", gravity: ToastGravity.CENTER);
                }
              },
              child: new Text(
                "登录",
                style: TextStyle(fontSize: 16),
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
                  backgroundColor:
                      MaterialStateProperty.all(Color(0xFF7ECC02))),
            ),
            width: double.infinity,
            margin: EdgeInsets.all(20.0),
          ),
        ],
      ),
    );
  }

  void _userFieldChanged(String str) {
    user = str;
    print(str);
  }

  void _pwdFieldChanged(String str) {
    pwd = str;
    print(str);
  }
}
