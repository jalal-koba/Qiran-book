import 'package:azwijn/Payment/Utils/stripe_services.dart';
import 'package:azwijn/data/network_common.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PaymentProvider with ChangeNotifier {
  Future<void> showStripeSheet({
    required String clientSecret,
  }) async {
    await StripeServices.initPaymentSheet(clientSecret: clientSecret);

    await StripeServices.presentPaymentSheet();
  }

  bool _isLoadingPostPayment = false;

  bool isLoadingPostPayment() => _isLoadingPostPayment;

  Future<void> creatPaymentIntent(
      {required int packageId, required BuildContext context}) async {
    try {
      _isLoadingPostPayment = true;

      notifyListeners();

      FormData formData = FormData.fromMap({
        "package_id": packageId,
      });
      Response response = await NetworkCommon()
          .dio
          .post("v1/payment/stripe/payment-intent", data: formData);

      String clientSecret = response.data['data']['client_secret'];

      await showStripeSheet(clientSecret: clientSecret);

      _isLoadingPostPayment = false;
      notifyListeners();
    } catch (error) {
      _isLoadingPostPayment = false;
      notifyListeners();
    }
  }
}
