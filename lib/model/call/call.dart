

class Call{
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final String callId;
  final bool hasDialled;
  final DateTime timestamp;
  //Text(
  //DateFormat('yyyy-MM-dd – kk:mm').format(snapshot.data![index].timestamp),
  //style: TextStyle(fontSize: 12, color: Colors.grey),
  //),
  Call(
  {
    required this.callerId,required this.callerName,required this.callerPic,required this.receiverId,
    required this.receiverName,required this.receiverPic,required this.callId,required this.hasDialled,   required this.timestamp,
});
Map<String,dynamic>toMap(){
  return{
    'callerId':callerId,
    'callerName':callerName,
    'callerPic':callerPic,
    'receiverId':receiverId,
    'receiverName':receiverName,
    'receiverPic':receiverPic,
    'callId':callId,
    'hasDialled':hasDialled,
    "timestamp":timestamp.millisecondsSinceEpoch,
  };

}
factory Call.fromMap(Map<String,dynamic>map){
       return Call(
           callerId:map['callerId'] ?? '',
           callerName: map['callerName'] ?? '',
           callerPic: map['callerPic'] ?? '',
           receiverId: map['receiverId'] ?? '',
           receiverName: map['receiverName'] ?? '',
           receiverPic: map['receiverPic'] ?? '',
           callId: map['callId'] ?? '',
           hasDialled: map['hasDialled'] ?? false,
         timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),

       );
}



}