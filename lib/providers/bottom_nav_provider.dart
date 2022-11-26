import "package:flutter/material.dart";

class BottomNavProvider extends ChangeNotifier{
  int _current =0;
  int get current => _current;

  void changeIndex(int value){
    _current=value;
    notifyListeners();
  }
}