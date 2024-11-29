import 'package:azwijn/constants/app_colors.dart';
import 'package:azwijn/screens/packages/Provider/package_provider.dart';
import 'package:azwijn/screens/packages/View/Widgets/package_card.dart';
import 'package:azwijn/screens/packages/View/Widgets/try_again.dart';
import 'package:azwijn/utils/global_functions.dart';
import 'package:azwijn/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Image.asset(
          "assets/images/qiranlogo.png",
          width: General.widthOfScreen(context) * .2,
          height: General.heightOfScreen(context) * .09,
        ),
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back_outlined,
            color: AppColors.seconedaryColor,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BackGroundWidget(
        child: ChangeNotifierProvider(
          create: (context) => PackageProvider()..getPackages(context: context),
          child: Consumer<PackageProvider>(
            builder: (context, value, child) {
              var state = value.state;
              if (state == PackageState.loadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state == PackageState.errorState) {
                return TryAgain(
                  onPressed: () {
                    value.getPackages(context: context);
                  },
                );
              }

              return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                  ),
                  itemCount: value.packages.length,
                  itemBuilder: (_, index) => PackageCard(
                        package: value.packages[index],
                        packageProvider: value,
                      ));
            },
          ),
        ),
      ),
    );
  }
}
