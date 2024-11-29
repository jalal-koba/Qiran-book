import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class CustomBubble extends StatelessWidget {
  const CustomBubble({
    super.key,
    required this.isMe,
    required this.previousMessageIsme,
    this.isImage = false,
    required this.child,
  });
  final Widget child;
  final bool isMe;
  final bool previousMessageIsme;
  final bool isImage;
  @override
  Widget build(BuildContext context) {
    return Bubble(
      showNip: previousMessageIsme != isMe,
      elevation: 1.8,
      radius: const Radius.circular(12),
      padding: isImage
          ? const BubbleEdges.symmetric(horizontal: 1, vertical: 1)
          : const BubbleEdges.symmetric(horizontal: 12, vertical: 5),
      color: isMe
          ? const Color.fromARGB(255, 255, 201, 212)
          : const Color.fromARGB(255, 251, 231, 255),
      nip: isMe ? BubbleNip.rightBottom : BubbleNip.leftBottom,
      nipHeight: 10,
      nipWidth: 8,
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: child),
        ],
      ),
    );
  }
}
