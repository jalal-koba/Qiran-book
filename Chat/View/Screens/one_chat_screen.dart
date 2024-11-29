import 'package:azwijn/data/Chat/Provider/chat_states.dart';
import 'package:azwijn/data/Chat/View/Widgets/Bubbles/date_bubble.dart';
import 'package:azwijn/data/Chat/View/Widgets/Bubbles/text_bubble.dart';
import 'package:azwijn/data/Chat/View/Widgets/chat_input.dart';
import 'package:azwijn/data/Chat/View/Widgets/try_again.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:azwijn/data/models/user/user_model.dart';
import 'package:azwijn/data/Chat/Provider/chat_provider.dart';
import 'package:azwijn/data/Chat/View/Widgets/chat_app_bar.dart';
import 'package:azwijn/utils/shared_preference.dart';
import 'package:azwijn/widgets/background_widget.dart';
import 'package:azwijn/widgets/my_custom_footer.dart';

import '../../../../utils/global_variables.dart';

class OneChatScreen extends StatefulWidget {
  final int userId;
  final String username;
  final ChatProvider? preProvider;
  final int? index;

  const OneChatScreen(
      {super.key,
      required this.userId,
      required this.username,
      this.preProvider,
      this.index});

  @override
  OneChatScreenState createState() => OneChatScreenState();
}

class OneChatScreenState extends State<OneChatScreen> {
  TextEditingController chatController = TextEditingController();

  UserModel? me;

  int numberOfMessages = -1;
  late ChatProvider chatProvider;

  @override
  void initState() {
    chatProvider = ChatProvider();

    super.initState();
    init();
  }

  init() async {
    String id = await SharedPreferenceHandler.getUserId();

    me = UserModel(name: await SharedPreferenceHandler.getUserName(), id: id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    streamSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      ChatProvider.showNotification(message);
    });

    chatProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size(AppBar().preferredSize.width, AppBar().preferredSize.height),
        child: ChatAppBar(widget: widget),
      ),
      body: BackGroundWidget(
        child: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => chatProvider
              ..userId = widget.userId
              ..getMessages()
              ..repeatAutoRefresh(),
            child: Consumer<ChatProvider>(builder: (context, value, child) {
              chatProvider = context.watch<ChatProvider>();

              if (chatProvider.state is ChatLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (chatProvider.state is ChatErrorState) {
                final state = chatProvider.state as ChatErrorState;
                return TryAgain(
                    state: state,
                    onTap: () {
                      chatProvider.getMessages();
                    });
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: SmartRefresher(
                        controller: chatProvider.refreshController,
                        enablePullUp: true,
                        enablePullDown: false,
                        footer: const MyCustomFooter(),
                        onLoading: () {
                          chatProvider
                              .messages[chatProvider.messages.length - 1].id;
                        },
                        child: ListView.separated(
                            controller: chatProvider.scrollController,
                            separatorBuilder: (context, index) {
                              if (index < chatProvider.messages.length - 1) {
                                if (comparTowDates(
                                    chatProvider.messages[index].createdAt,
                                    chatProvider
                                        .messages[index + 1].createdAt)) {
                                  return DateBubble(
                                    date: dateBubbleFormat(
                                        chatProvider.messages[index].createdAt),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              } else {
                                return DateBubble(
                                    date: dateBubbleFormat(chatProvider
                                        .messages[index].createdAt));
                              }
                            },
                            reverse: true,
                            itemCount: chatProvider.messages.length + 1,
                            itemBuilder: (context, index) {
                              if (index == chatProvider.messages.length) {
                                return const SizedBox();
                              }

                              final bool previousMessageIsme;

                              if (index != 0) {
                                previousMessageIsme =
                                    chatProvider.messages[index - 1].isMe;
                              } else if (index < chatProvider.messages.length) {
                                previousMessageIsme =
                                    !chatProvider.messages[index].isMe;
                              } else {
                                previousMessageIsme = true;
                              }

                              return TextBubble(
                                  chatProvider: chatProvider,
                                  previousMessageIsme: previousMessageIsme,
                                  message: chatProvider.messages[index]);
                            }),
                      )),
                  ChatInput(
                      chatController: chatController,
                      preProvider: widget.preProvider,
                      index: widget.index,
                      userId: widget.userId)
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

bool comparTowDates(DateTime date1, DateTime date2) {
  return (date1.day != date2.day && date1.month == date2.month) ||
      (date1.day == date2.day && date1.month != date2.month);
}

String dateBubbleFormat(DateTime date) {
  String formattedDate = DateFormat(
    'd MMMM',
  ).format(date.toLocal());

  return formattedDate;
}
