import 'package:azwijn/Payment/Provider/payment_provider.dart';
import 'package:azwijn/constants/app_colors.dart';
import 'package:azwijn/data/models/subscription/package.dart';
import 'package:azwijn/data/network_common.dart';
import 'package:azwijn/screens/packages/Provider/package_provider.dart';
import 'package:azwijn/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PackageCard extends StatelessWidget {
  const PackageCard(
      {super.key, required this.package, required this.packageProvider});
  final Package package;
  final PackageProvider packageProvider;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: AppColors.textFieldColor,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
            fit: BoxFit.cover,
            width: 100.w,
            height: 30.h,
            "${NetworkCommon.storage}/${package.image}",
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return SizedBox(
                  width: 100.w,
                  height: 30.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  ),
                );
              }
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error);
            },
          ),
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.name,
                  style: TextStyle(
                      color: AppColors.seconedaryColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 1.h,
                ),
                ...List.generate(
                  package.featuresList.length,
                  (i) => Row(
                    children: <Widget>[
                      Icon(
                        size: 15.sp,
                        Icons.check,
                        color: AppColors.greanColor,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        packageProvider.features[package.featuresList[i]]!,
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "${double.parse(package.oldPrice.toString()).toStringAsFixed(0)} \$",
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      "${double.parse(package.newPrice.toString()).toStringAsFixed(0)} \$",
                      style: TextStyle(
                          decorationColor: AppColors.redColor,
                          color: AppColors.redColor,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
                ChangeNotifierProvider(
                  create: (context) => PaymentProvider(),
                  child: Consumer<PaymentProvider>(
                      builder: (context, payment, child) {
                    return CustomButton(
                      width: 100.w,
                      isLoaded: payment.isLoadingPostPayment(),
                      buttonText: "اشتراك",
                      textColor: Colors.white,
                      onPressed: () {
                        payment.creatPaymentIntent(
                            packageId: package.id, context: context);
                      },
                    );
                  }),
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
