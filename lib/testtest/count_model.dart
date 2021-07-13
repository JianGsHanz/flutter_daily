import 'package:flutter/material.dart';

class CountModel extends ChangeNotifier{

  int count = 0;
  IconData iconData = Icons.ac_unit_sharp;
  void add(){
    count++;
    notifyListeners();
  }

  IconData change(){
    if (iconData != Icons.animation) {
      iconData =  Icons.animation;
    }else{
      iconData = Icons.ac_unit_sharp;
    }
    notifyListeners();
  }
}