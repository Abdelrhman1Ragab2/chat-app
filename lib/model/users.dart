import 'package:chat_if/model/chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String id;
  String name;
  String email;
  String imgUrl;
  final List<String> friends;
  final List<String> friendsRequest;
  final List<String> chats;
  bool isOnline;
  String phone;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.friends = const [],
    this.friendsRequest = const [],
    this.chats = const [],
    required this.imgUrl,
    required this.phone,
    required this.isOnline,
  });

  static Map<String, dynamic> toFirebase(
    AppUser user,
    SetOptions? options,
  ) {
    return {
      _userIdKey: user.id,
      _usernameKey: user.name,
      userEmailKey: user.email,
      userFriendsKey: user.friends,
      userImageUrlKey: user.imgUrl,
      _userPhoneNumberKey: user.phone,
      userChatsKey: user.chats,
      friendsRequestsKey: user.friendsRequest,
    };
  }

  static AppUser fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {
    return AppUser(
      id: ds.id,
      email: ds.get(userEmailKey),
      friends: (ds.get(userFriendsKey) as List).cast(),
      chats: (ds.get(userChatsKey) as List).cast(),
      imgUrl: ds.get(userImageUrlKey),
      name: ds.get(_usernameKey),
      phone: ds.get(_userPhoneNumberKey),
      friendsRequest: (ds.get(friendsRequestsKey) as List).cast(),
      isOnline: ds.get(userOnlineKey)
    );
  }

  static const String _userIdKey = "id";
  static const String _usernameKey = "name";
  static const String userEmailKey = "email";
  static const String userImageUrlKey = "imageUrl";
  static const String _userPhoneNumberKey = "phone";
  static const String userFriendsKey = "friends";
  static const String userChatsKey = "chats";
  static const String friendsRequestsKey = "friends request";
  static const String userOnlineKey = "online";
}
