import 'package:azwijn/constants/app_colors.dart';
import 'package:azwijn/data/Chat/Provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({
    super.key,
    required this.preProvider,
    required this.index,
    required this.chatController,
    required this.userId,
  });
  final TextEditingController chatController;
  final ChatProvider? preProvider;
  final int? index;
  final int userId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 20.h),
                      child: TextField(
                        style: const TextStyle(
                            fontSize: 15.0, color: Colors.black),
                        controller: chatController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالة ... ',
                          fillColor: AppColors.whiteColor,
                          border: InputBorder.none,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.seconedaryColor,
                                  width: 0.5.w),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.w))),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.seconedaryColor,
                                  width: 0.5.w),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.w))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.seconedaryColor,
                                  width: 0.5.w),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.w))),
                          contentPadding:
                              const EdgeInsets.only(left: 16, right: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
          const SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () async {
              context.read<ChatProvider>().sendTextSunc(
                  content: chatController.text.trim(),
                  index: index,
                  preProvider: preProvider);

              chatController.clear();
            },
            child: const ClipOval(
              child: Material(
                color: AppColors.seconedaryColor,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
