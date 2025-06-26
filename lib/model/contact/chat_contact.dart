
class ChatContact{
  final String name;
  final String prof;
  final String contactId;
  final DateTime time;
  final String lastMassge;
  final String isOnline;
  final int unreadMessageCount;
  final String reciverId;
  final bool isSeen;

  ChatContact( {required this.name,required this.prof,required this.contactId,required this.time,
    required this.lastMassge,required this.isOnline,  required this.unreadMessageCount,
    required this.reciverId,required this.isSeen });


  Map<String, dynamic> toMap() {
    return {
      'name':name,
      'prof':prof,
      'contactId':contactId,
      'time':time.millisecondsSinceEpoch,
      'lastMassge':lastMassge,
      'isOnline':isOnline,
      'unreadMessageCount':unreadMessageCount,
      'reciverId':reciverId,
      'isSeen':isSeen,


    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] ?? '',
      prof: map['prof'] ?? '',
      contactId: map['contactId'] ?? '',
      time:DateTime.fromMicrosecondsSinceEpoch(map['time']),
      lastMassge: map['lastMassge'] ??'',
      isOnline: map['isOnline'] ?? '',
      unreadMessageCount: map['unreadMessageCount'] ?? 0,
      reciverId:map['reciverId'] ?? '',
      isSeen: map['isSeen'] ?? false,

    );
  }
}