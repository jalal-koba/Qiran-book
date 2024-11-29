 
class Message {
  bool isLocal;
  bool isError;
  int id;
  final int? senderId;
  final dynamic receiverId;
  final String? content;
  final dynamic readAt;
  final DateTime createdAt;
  bool isMe;

  Message({
    this.isLocal = false,
    this.isError = false,
    required this.id,
    this.senderId,
    this.receiverId,
    required this.content,
    this.readAt,
    required this.createdAt,
    required this.isMe,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        content: json["content"],
        readAt: json["read_at"],
        createdAt: DateTime.parse(json["created_at"]),
        isMe: json["is_sent_by_auth_user"] ?? false,
      );
}
