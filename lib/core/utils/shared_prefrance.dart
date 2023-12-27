// import 'package:shared_preferences/shared_preferences.dart';
//
//  class SharedPreferenceApp{
//
//     SharedPreferences? sharedPreferences;
//
//    Future<String?>initSharedPreference()async{
//      sharedPreferences = await SharedPreferences.getInstance();
//      return sharedPreferences!.getString("USERID");
//    }
//
//
//   Future<void>recordUserId(String userId)async{
//     sharedPreferences = await SharedPreferences.getInstance();
//     await sharedPreferences!.setString("USERID", userId);
//    print("   await sharedPreferences.setString(USERID, userId); is done ");
//
//   }
//
//
//   Future<void>deleteUserId(String userId)async{
//     sharedPreferences = await SharedPreferences.getInstance();
//     await sharedPreferences!.remove("USERID");
//   }
//
//
//
// }