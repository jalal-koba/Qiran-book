import 'package:azwijn/constants/app_colors.dart';
import 'package:azwijn/data/Chat/Model/message.dart';
import 'package:azwijn/data/Chat/View/Widgets/Bubbles/text_bubble.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TimeAndTic extends StatelessWidget {
  const TimeAndTic({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        !message.isMe
            ? const SizedBox()
            : message.isLocal && !message.isError
                ? Icon(
                    Icons.timer_outlined,
                    color: Colors.grey,
                    size: 15.sp,
                  )
                : message.isError
                    ? Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red,
                        size: 16.sp,
                      )
                    : message.readAt != null
                        ? Icon(
                            Icons.done_all,
                            color:  AppColors.seconedaryColor,
                            size: 15.sp,
                          )
                        : Icon(
                            Icons.done,
                            color: Colors.grey,
                            size: 15.sp,
                          ),
        SizedBox(width: 1.w),
        Text(
          dateFormattedMessage(message.createdAt),
          style: TextStyle(
            fontSize: 8.2.sp,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
