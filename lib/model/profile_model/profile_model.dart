class profilemodel {
  final String name;
  final String uid;
  final String profile;
  final String status;

  profilemodel({
    required this.name,
    required this.uid,
    required this.profile,
    required this.status,

  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profile': profile,
      'status': status,

    };
  }

  factory profilemodel.fromMap(Map<String, dynamic> map) {
    return profilemodel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profile: map['profile'] ?? '',
      status: map['status'] ?? '',

    );
  }
}