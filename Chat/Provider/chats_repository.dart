import 'package:azwijn/data/models/user/chatModel.dart';
import 'package:dio/dio.dart';

import '../../network_common.dart';

class ChatRepository {
  Future<List<Chat>> getChats() async {
    return NetworkCommon()
        .dio
        .get(
          "v1/chat/users",
        )
        .then(
      (value) {
        List<Chat> users = [];
        var results = NetworkCommon.decodeResp(value);

        results["data"]["data"].forEach((result) {
          Chat user = Chat.fromJson(result);
          // user.lastMessage =  user.lastMessage?.trim();
          users.add(user);
          print(result);
        });
        return users;
      },
    );
  }

  Future<Response> getMessages(
      {required int userId, required int? fmid}) async {
    return NetworkCommon()
        .dio
        .get(
          "v1/chat/users/$userId/messages?type=mobile_mode${fmid != null ? "&fmid?$fmid" : ""}",
        )
        .then((value) {
      return value;
    });
  }

  Future<Response> autoRefresh(int userId, int? lmid) async {
    return NetworkCommon()
        .dio
        .get(
          "v1/chat/users/$userId/messages?lmid=${lmid ?? -1}&type=mobile_mode",
        )
        .then(
      (value) {
        return value;
      },
    );
  }

  Future<void> deleteMessage(
      {required int messageId, required int userId}) async {
    NetworkCommon().dio.delete("v1/chat/users/$userId/messages/$messageId");
  }
}
