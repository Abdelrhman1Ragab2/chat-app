import 'package:flutter/foundation.dart';

class TabBarProvider with ChangeNotifier{
  int currentIndex=0;
  void changeTab(int changeIndex){
    currentIndex=changeIndex;
    notifyListeners();
  }
}