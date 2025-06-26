class UserModel {
  final String name;
  final String uid;
  final String profile;
  final String isOnline;
  final String phoneNumber;
  final List<String> groupId;
  final String statu;
  UserModel({
    required this.name,
    required this.uid,
    required this.profile,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
    required this.statu,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profile': profile,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
      'statu': statu,

    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profile: map['profile'] ?? '',
      isOnline: map['isOnline'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      statu: map['statu'] ?? '',
      groupId: List<String>.from(map['groupId']),
    );
  }
}