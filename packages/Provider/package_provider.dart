import 'package:azwijn/data/models/subscription/package.dart';
import 'package:azwijn/screens/packages/Repository/subscription_repository.dart';
import 'package:azwijn/utils/global_functions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum PackageState {
  initState,
  loadingState,
  successState,
  errorState,
}

class PackageProvider with ChangeNotifier {
  PackageState state = PackageState.initState;

  Map<String, String> features = {
    "CHAT": "الدردشة",
    "PROFILE_VISITORS": "رؤية من زار بروفايلي",
    "CARES": "القدرة على اهتمام بشخص ما",
    "CHAT_NATIONALTIES": "القدرة على تحديد الجنسيات التي تراسلني",
    "CHAT_COUUNTRIES": "القدرة على تحديد البلدان التي تراسلني",
    "MANAGE_NOTIFICATIONS": "التحكم بالإشعارات التي تصلني",
  };

  List<Package> packages = [];
  Future<void> getPackages({required BuildContext context}) async {
    state = PackageState.loadingState;

    notifyListeners();

    const SubscriptionRepository().getPackages().then((value) {
      packages = value.packages;

      state = PackageState.successState;

      notifyListeners();
    }).catchError((error) {
      state = PackageState.errorState;
      notifyListeners();
      General.showDialogue(
          txtWidget:
              Text((error as DioException).response?.data["data"]("error")),
          context: context);
    });
  }
}
