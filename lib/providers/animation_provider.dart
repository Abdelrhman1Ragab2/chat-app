import 'package:flutter/cupertino.dart';

class AnimationProvider with ChangeNotifier{

  String selectedId="";
   void onSelectFriend(String value){
     selectedId=value;
     notifyListeners();
   }

}