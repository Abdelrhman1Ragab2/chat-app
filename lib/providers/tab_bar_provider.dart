import 'package:flutter/foundation.dart';

class TabBarProvider with ChangeNotifier{
  int currentIndex=1;
  void changeTab(int changeIndex){
    currentIndex=changeIndex;
    notifyListeners();
  }

  bool showBottomSheet=false;

  void onShowBottomSheet({bool? showSheet})
  {
    if(showSheet==false)
      {showBottomSheet=showSheet!;}
    else showBottomSheet=!showBottomSheet;
    notifyListeners();
  }
}