import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String id;
  String name;
  String email;
  String imgUrl;
  final List<String> friends;
  String  phone;
  //{
  // id:"idddddddddd"
  // lasttime:55
  // active:true
  // }

  AppUser({required this.id,
    required this.name,
    required this.email,
    this.friends = const [],
    required this.imgUrl,
    required this.phone,});


  static Map<String, dynamic> toFirebase(
      AppUser user,
      SetOptions? options,
      ) {
    return {
      _userIdKey: user.id,
      _usernameKey:user.name,
      userEmailKey: user.email,
      userFriendsKey: user.friends,
      _userImageUrlKey: user.imgUrl,
      _userPhoneNumberKey: user.phone,


    };
  }

  static AppUser fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {

    return AppUser(
      id: ds.id,
      email: ds.get(userEmailKey),
      friends: (ds.get(userFriendsKey) as List).cast(),
      imgUrl:  ds.get(_userImageUrlKey),
      name:  ds.get(_usernameKey),
      phone: ds.get(_userPhoneNumberKey)


    );
  }


  static const String _userIdKey = "id";
  static const String _usernameKey = "name";
  static const String userEmailKey = "email";
  static const String _userImageUrlKey = "imageUrl";
  static const String _userPhoneNumberKey = "phone";
  static const String userFriendsKey = "friends";


}