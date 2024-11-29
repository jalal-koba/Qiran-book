import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeServices {
  static init() {
    Stripe.publishableKey = "pk_test_UQedOw5S3NLLJKB2LWI8TMxg";
  }

  static Future<void> initPaymentSheet({required String clientSecret}) async {
    try {
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              billingDetails: const BillingDetails(),
              paymentIntentClientSecret: clientSecret,
              merchantDisplayName: "Buy a Package",
              style: ThemeMode.system));
    } on Exception catch (_) {}
  }

  static Future<void> presentPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }
}
