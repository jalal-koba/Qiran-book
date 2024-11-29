import 'package:azwijn/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TryAgain extends StatelessWidget {
  const TryAgain({
    super.key,
    required this.onPressed,
  });
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.error),
          SizedBox(height: 2.h),
          MaterialButton(
            color: AppColors.primaryColor,
            onPressed: onPressed,
            child: const Text(
              'حاول مرة أخرة',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
