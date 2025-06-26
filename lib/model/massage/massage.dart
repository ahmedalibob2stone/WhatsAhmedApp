

import 'package:whatsapp/common/enums/enum_massage.dart';
class Message {
  final String senderId;
  final String recieverid;
  final String text;
  final EnumData type;
  final DateTime time;
  final String messageId;
  late final bool isSeen;
  final prof;
  final proff;
 final String repliedMessage;
  final String repliedTo;
  final EnumData repliedMessageType;

  Message({
    required this.senderId,
    required this.recieverid,
    required this.text,
    required this.type,
    required this.time,
    required this.messageId,
    required this.isSeen,
    required this.prof,
    required this.proff,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverid': recieverid,
      'text': text,
      'type': type.type,
      'time': time.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'prof':prof,
      'proff':proff,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type ,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      recieverid: map['recieverid'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
      prof: map['prof'] ?? '',
      proff: map['proff'] ?? '',
      repliedMessage: map['repliedMessage'] ?? '',
      repliedTo: map['repliedTo'] ?? '',
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
    );
  }
}
