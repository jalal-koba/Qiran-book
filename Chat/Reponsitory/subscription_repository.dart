import 'package:azwijn/data/models/subscription/create_subscription_model.dart';
import 'package:azwijn/data/models/subscription/package.dart';
import 'package:dio/dio.dart';

import '../../../data/network_common.dart';

class SubscriptionRepository {
  const SubscriptionRepository();

  Future<PackagesResponse> getPackages() async {
    return NetworkCommon()
        .dio
        .get(
          "v1/packages",
        )
        .then((value) {
      var results = NetworkCommon.decodeResp(value);
      return PackagesResponse.fromJson(results);
    });
  }

 
}
