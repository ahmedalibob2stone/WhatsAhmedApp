class Group {
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String> membersUid;
  final DateTime timeSent;
  final Map<String, int> unreadMessageCount;
  final String adminUid; // New field to store the admin UID

  Group({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.membersUid,
    required this.timeSent,
    required this.unreadMessageCount,
    required this.adminUid,  // Initialize the admin UID
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'membersUid': membersUid,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'unreadMessageCount': unreadMessageCount,
      'adminUid': adminUid, // Add adminUid to the map
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      senderId: map['senderId'] ?? '',
      name: map['name'] ?? '',
      groupId: map['groupId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      groupPic: map['groupPic'] ?? '',
      membersUid: List<String>.from(map['membersUid']),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      unreadMessageCount: Map<String, int>.from(map['unreadMessageCount']),
      adminUid: map['adminUid'] ?? '', // Initialize adminUid from the map
    );
  }
}
