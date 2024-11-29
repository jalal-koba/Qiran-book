import 'package:azwijn/constants/app_colors.dart';
import 'package:azwijn/data/Chat/View/Screens/one_chat_screen.dart';
import 'package:azwijn/data/models/home_page_model.dart';
import 'package:azwijn/data/network_common.dart';
import 'package:azwijn/screens/another_profile/another_profile.dart';
import 'package:azwijn/utils/global_functions.dart';
import 'package:azwijn/widgets/my_text.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({
    super.key,
    required this.widget,
  });

  final OneChatScreen widget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.seconedaryColor,
      title: InkWell(
        onTap: () async {
          await NetworkCommon()
              .dio
              .get("v1/users/show/${widget.userId}")
              .then((value) {
            var results = NetworkCommon.decodeResp(value);
            General.routingPage(
                context,
                AnotherProfileScreen(
                  userData: ActiveUsersDatum.fromJson(
                    results["data"],
                  ),
                ));
          });
        },
        child: MyText(
          title: widget.username,
          color: AppColors.whiteColor,
          fontWeight: FontWeight.bold,
          size: 18,
        ),
      ),
      leading: const BackButton(
        color: AppColors.whiteColor,
      ),
      centerTitle: true,
    );
  }
}
