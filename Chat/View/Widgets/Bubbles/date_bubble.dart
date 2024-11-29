import 'package:azwijn/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DateBubble extends StatelessWidget {
  const DateBubble({
    super.key,
    required this.date,
  });

  final String date;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding: EdgeInsets.symmetric(horizontal: 1.8.w, vertical: 0.5.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primaryColor),
        child: Text(
          date,
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
        ),
      ),
    );
  }
}
