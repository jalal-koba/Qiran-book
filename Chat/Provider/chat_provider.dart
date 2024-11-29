import 'dart:async';
import 'dart:collection';

import 'package:azwijn/constants/app_colors.dart';
import 'package:azwijn/data/Chat/Model/Chat_response.dart';
import 'package:azwijn/data/Chat/Model/message_to_send.dart';
import 'package:azwijn/data/Chat/Provider/chat_states.dart';
import 'package:azwijn/data/Chat/View/Widgets/report_dialog.dart';
import 'package:azwijn/data/models/user/chatModel.dart';
import 'package:azwijn/data/Chat/Provider/chats_repository.dart';
import 'package:azwijn/utils/global_functions.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notification;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../Models/message.dart';
import '../../network_common.dart';
import '../../../main.dart';

class ChatProvider with ChangeNotifier {
  ChatStates state = InitialState();

  bool _isWaiting = false;
  bool _sendReportLoading = false;
  bool _hasData = false;
  bool get hasData => _hasData;
  bool get isWaiting => _isWaiting;
  bool get sendReportLoading => _sendReportLoading;

  late DateTime currentDate;

  RefreshController refreshController = RefreshController();
  final TextEditingController reportController = TextEditingController();
  List<Chat> users = [];
  List<Message> messages = [];
  int page = 1;
  int lastPage = -1;

  int userId = 0;
  void getChats() async {
    _isWaiting = true;
    _hasData = false;
    notifyListeners();

    return ChatRepository().getChats().then((value) {
      users.addAll(value);
      _isWaiting = false;
      _hasData = true;
      notifyListeners();
    }).catchError((error) {
      _isWaiting = false;
      notifyListeners();
    });
  }

  void showMessageMenu(
    BuildContext context,
    Offset offset,
    Message message,
  ) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      constraints: BoxConstraints(
        maxWidth: 25.w,
        minWidth: 20,
      ),
      color: Colors.grey[200],
      surfaceTintColor: Colors.transparent,
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        overlay.size.width,
        overlay.size.height,
      ),
      items: [
        if (message.isError)
          PopupMenuItem(
            value: 'resend',
            child: Center(
              child: Text(
                'إعادة إرسال',
                style: TextStyle(
                    fontSize: 10.sp, color: const Color.fromARGB(184, 0, 0, 0)),
              ),
            ),
          ),
        if (message.content != null)
          PopupMenuItem(
            value: 'copy',
            child: Center(
              child: Text(
                'نسخ النص',
                style: TextStyle(
                    fontSize: 10.sp, color: const Color.fromARGB(184, 0, 0, 0)),
              ),
            ),
          ),
        if (!message.isError && !message.isLocal && message.isMe)
          PopupMenuItem(
            value: 'delete',
            child: Center(
              child: Text(
                'حذف الرسالة',
                style: TextStyle(
                    fontSize: 10.sp, color: const Color.fromARGB(184, 0, 0, 0)),
              ),
            ),
          ),
        if (!message.isMe)
          PopupMenuItem(
            value: 'report',
            child: Center(
              child: Text(
                'إبلاغ',
                style: TextStyle(
                    fontSize: 10.sp, color: const Color.fromARGB(184, 0, 0, 0)),
              ),
            ),
          ),
      ],
    ).then((value) {
      switch (value) {
        case 'resend':
          message.isError = false;

          notifyListeners();
          sendText(messageToSend: textMessagesQueue.first);
          break;
        case 'copy':
          Clipboard.setData(ClipboardData(text: message.content!));
          break;
        case 'delete':
          deleteMessage(messageId: message.id);

          break;

        case 'report':
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ReportDialog(chatProvider: this, message: message);
            },
          );

          break;
      }
    });
  }

  Future<void> reportOnMessage({required Message message}) async {
    try {
      _sendReportLoading = true;
      notifyListeners();
      final FormData formData = FormData.fromMap({
        "accused_id": message.senderId,
        "accused_message_id": message.id,
        "reason": reportController.text
      });

      await NetworkCommon().dio.post("v1/reports", data: formData);
      reportController.clear();
      General.showToast(txt: "تم إرسال الإبلاغ بنجاح");
      _sendReportLoading = false;
      notifyListeners();
    } on DioException catch (_) {
      _sendReportLoading = false;
      notifyListeners();
      General.showToast(txt: "حدث خطأ ما");
    }
  }

  Future<void> deleteMessage({required int messageId}) async {
    try {
      for (int index = 0; index < messages.length; index++) {
        if (messageId == messages[index].id) {
          messages.removeAt(index);
          break;
        }
      }
      notifyListeners();
      await ChatRepository()
          .deleteMessage(messageId: messageId, userId: userId);
    } on DioException catch (_) {
      General.showToast(txt: "حدث خطأ في حذف الرسالة", color: Colors.black);
    }
  }

  Future<void> getMessages({int? fmid, int? id}) async {
    if (fmid == null) {
      state = ChatLoadingState();
      notifyListeners();
    }

    try {
      Response response =
          await ChatRepository().getMessages(userId: id ?? userId, fmid: fmid);

      ChatResponse chatResponse = ChatResponse.fromJson(response.data);

      if (fmid == null) {
        messages = chatResponse.data.messages;
      } else {
        if (chatResponse.data.messages.isEmpty) {
          refreshController.loadNoData();
        } else {
          messages.addAll(chatResponse.data.messages);
          refreshController.loadComplete();
        }
      }

      state = ChatSuccessState();
      notifyListeners();
    } on DioException catch (error) {
      refreshController.loadComplete();
      if (fmid == null) {
        if (error.type == DioExceptionType.badResponse) {
          state = ChatErrorState(message: error.response?.data['message']);
          notifyListeners();
        } else {
          state = ChatErrorState(message: "حدث خطأ");
          notifyListeners();
        }
      }
      state = AutoRefreshErrorState();
      notifyListeners();
    }
  }

  Queue<MessageToSend> textMessagesQueue = Queue();

  void repeatAutoRefresh() {
    Timer.periodic(const Duration(seconds: 20), (timer) {
      if (textMessagesQueue.isEmpty) {
        autoRefresh();
      }
    });
  }

  Future<void> autoRefresh() async {
    ChatResponse chatResponse;
    int? lmid;

    for (int i = messages.length - 1; i > -1; i--) {
      if (messages[i].readAt == null && !messages[i].isLocal) {
        lmid = messages[i].id;

        break;
      }
    }

    try {
      Response response = await ChatRepository().autoRefresh(userId, lmid);

      chatResponse = ChatResponse.fromJson(response.data);

      List<Message> receivedMessages = chatResponse.data.messages;

      mergeMessages(receivedMessages: receivedMessages);

      notifyListeners();
    } on DioException catch (_) {
      General.showToast(txt: "حدث خطأ ما ", color: Colors.red);
    }
  }

  void mergeMessages(
      {required List receivedMessages, bool mergeAfterGoToReply = false}) {
    List<Message> temp = List.from(messages);

    List<Message> newMessages = [];
    Set<int> existingMessageIds = temp.map((msg) => msg.id!).toSet();

    for (Message receivedMessage in receivedMessages) {
      if (existingMessageIds.contains(receivedMessage.id)) {
        int index = temp.indexWhere((msg) => msg.id == receivedMessage.id);
        temp[index] = receivedMessage;
      } else {
        newMessages.add(receivedMessage);
      }
    }
    if (mergeAfterGoToReply) {
      temp.addAll(newMessages);
    } else {
      temp.insertAll(0, newMessages);
    }
    temp.sort((a, b) => b.id.compareTo(a.id));
    messages = temp;
  }

  ScrollController scrollController = ScrollController();
  Future<void> sendTextSunc(
      {required String content,
      required ChatProvider? preProvider,
      required int? index}) async {
    if (content.isNotEmpty) {
      scrollController.animateTo(scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);

      preProvider?.users.insert(0, preProvider.users[index!]);
      preProvider?.users[0].lastMessageContent = content;

      preProvider?.users.removeAt(index! + 1);

      preProvider?.notifyListeners();

      final date = DateTime.now();

      final int uniqId = date.microsecondsSinceEpoch;

      messages.insert(
          0,
          Message(
            id: uniqId,
            content: content,
            createdAt: date,
            isMe: true,
            isLocal: true,
          ));

      textMessagesQueue.add(MessageToSend(
        type: "text",
        uniqId: uniqId,
        content: content,
      ));

      sendText(messageToSend: textMessagesQueue.first);

      notifyListeners();

      // emit(SendTextLoadingState());
    }
  }

  bool sendTextLoading = false;
  Future<void> sendText({
    required MessageToSend messageToSend,
  }) async {
    if (sendTextLoading) {
      return;
    }
    FormData formData = FormData.fromMap({
      "content": messageToSend.content,
    });
    try {
      sendTextLoading = true;

      Response response = await NetworkCommon()
          .dio
          .post("v1/chat/users/$userId/messages", data: formData);

      Message message = Message.fromJson(response.data['data']);

      message.isMe = true;

      messages = messages.map(
        (e) {
          if (messageToSend.uniqId == e.id) {
            e.id = message.id;
            e.isLocal = false;
            e.isError = false;
          }
          return e;
        },
      ).toList();

      sendTextLoading = false;

      textMessagesQueue.removeFirst();

      notifyListeners();
      if (textMessagesQueue.isNotEmpty) {
        sendText(
          messageToSend: textMessagesQueue.first,
        );
      }
    } on DioException catch (_) {
      sendTextLoading = false;

      textMessagesQueue.first.isError = true;

      messages = messages.map(
        (e) {
          if (messageToSend.uniqId == e.id) {
            e.isError = true;
          }
          return e;
        },
      ).toList();

      for (var element in textMessagesQueue) {
        messages = messages.map(
          (e) {
            if (element.uniqId == e.id) {
              e.isError = true;
            }
            return e;
          },
        ).toList();
      }
      notifyListeners();
    }
  }

  static void showNotification(RemoteMessage message) {
    notification.FlutterLocalNotificationsPlugin
        flutterLocalNotificationsPlugin;
    flutterLocalNotificationsPlugin =
        notification.FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
        const notification.InitializationSettings(
            android: notification.AndroidInitializationSettings(
                '@mipmap/ic_launcher')),
        onDidReceiveNotificationResponse: (details) {
      Navigator.popUntil(MyApp.navigatorKey.currentState!.context,
          (route) => route.settings.name != '/messages');

      MyApp.navigatorKey.currentState!
          .pushNamed('/messages', arguments: message.data);
    }, onDidReceiveBackgroundNotificationResponse: (details) {
      MyApp.navigatorKey.currentState!
          .pushNamed('/messages', arguments: message.data);
    });
    String groupKey = 'com.example.general-notification-channel';
    var androidPlatformChannelSpecifics =
        notification.AndroidNotificationDetails(
      'general-notification-channel',
      'general-notification-channel',
      playSound: true,
      importance: notification.Importance.max,
      priority: notification.Priority.high,
      groupKey: groupKey,
      icon: '@mipmap/ic_launcher',
      color: AppColors.whiteColor,
 
    );

    var iOSPlatformChannelSpecifics =
        const notification.DarwinNotificationDetails(
      presentBadge: true,
      presentSound: true,
    );

    notification.NotificationDetails platformChannelSpecifics =
        notification.NotificationDetails(
            android: androidPlatformChannelSpecifics,
            iOS: iOSPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(0, message.data['username'],
        message.data['content'], platformChannelSpecifics);
  }


}
