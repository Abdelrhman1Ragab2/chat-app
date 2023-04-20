import 'package:chat_if/model/chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String id;
  String name;
  String email;
  String? bio;
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
    required this.bio,
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
      userIdKey: user.id,
      usernameKey: user.name,
      userEmailKey: user.email,
      userBiolKey:user.bio,
      userFriendsKey: user.friends,
      userImageUrlKey: user.imgUrl,
      userPhoneNumberKey: user.phone,
      userChatsKey: user.chats,
      friendsRequestsKey: user.friendsRequest,
      userOnlineKey:user.isOnline,
    };
  }

  static AppUser fromFirebase(DocumentSnapshot ds, SnapshotOptions? options) {
    return AppUser(
      id: ds.id,
      email: ds.get(userEmailKey),
      bio:  ds.get(userBiolKey),
      friends: (ds.get(userFriendsKey) as List).cast(),
      chats: (ds.get(userChatsKey) as List).cast(),
      imgUrl: ds.get(userImageUrlKey),
      name: ds.get(usernameKey),
      phone: ds.get(userPhoneNumberKey),
      friendsRequest: (ds.get(friendsRequestsKey) as List).cast(),
      isOnline: ds.get(userOnlineKey)
    );
  }

  static const String userIdKey = "id";
  static const String usernameKey = "name";
  static const String userEmailKey = "email";
  static const String userBiolKey = "bio";
  static const String userImageUrlKey = "imageUrl";
  static const String userPhoneNumberKey = "phone";
  static const String userFriendsKey = "friends";
  static const String userChatsKey = "chats";
  static const String friendsRequestsKey = "friends request";
  static const String userOnlineKey = "online";
}
