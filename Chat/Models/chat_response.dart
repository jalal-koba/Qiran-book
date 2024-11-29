import 'package:azwijn/data/Chat/Model/message.dart';

class ChatResponse {
    final Data data;
    final int code;

    ChatResponse({
        required this.data,
        required this.code,
    });

    factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        data: Data.fromJson(json["data"] ),
        code: json["code"],
    );

}

class Data {
    final List<Message> messages;

    Data({
        required this.messages,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        messages: List<Message>.from(json["data"].map((x) => Message.fromJson(x))),
    );

}
  