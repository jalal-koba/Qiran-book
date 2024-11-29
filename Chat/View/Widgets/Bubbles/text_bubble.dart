import 'package:azwijn/data/Chat/Model/message.dart';
import 'package:azwijn/data/Chat/Provider/chat_provider.dart';
import 'package:azwijn/data/Chat/View/Widgets/Bubbles/custom_bubble.dart';
import 'package:azwijn/data/Chat/View/Widgets/Bubbles/time_and_tic.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class TextBubble extends StatefulWidget {
  final bool previousMessageIsme;
  final Message message;
  final ChatProvider chatProvider;
  const TextBubble({
    super.key,
    required this.previousMessageIsme,
    required this.chatProvider,
    required this.message,
  });

  @override
  State<TextBubble> createState() => _TextBubbleState();
}

class _TextBubbleState extends State<TextBubble> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          widget.message.isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            margin: widget.message.isMe
                ? EdgeInsets.fromLTRB(15.w, 5, 0, 5)
                : EdgeInsets.fromLTRB(0, 5, 15.w, 5),
            child: InkWell(
              onTapUp: (details) {
                widget.chatProvider.showMessageMenu(
                    context, details.globalPosition, widget.message);
              },
              child: CustomBubble(
                previousMessageIsme: widget.previousMessageIsme,
                isMe: widget.message.isMe,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 2.0),
                      Text(
                        "${widget.message.content}  ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: const Color.fromARGB(181, 0, 0, 0),
                          fontSize: 11.sp,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      TimeAndTic(message: widget.message)
                    ]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String dateFormattedMessage(DateTime time) {
  String formattedDate = DateFormat(
    'h:mm a',
  ).format(time.toLocal());

  return formattedDate;
}
