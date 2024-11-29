import 'package:azwijn/constants/app_colors.dart';
import 'package:azwijn/data/Chat/Provider/chat_states.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TryAgain extends StatelessWidget {
  const TryAgain({
    super.key,
    required this.state,
    required this.onTap,
  });

  final ChatErrorState state;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            state.message,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text(
              "أعد المحاولة",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
