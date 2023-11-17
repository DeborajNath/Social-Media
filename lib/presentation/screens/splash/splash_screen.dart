import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:shop_spectrum/presentation/routers/routes.dart';
import 'package:shop_spectrum/utils/constant/index.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  void navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (context.mounted) {
      Navigator.pushReplacementNamed(
        context,
        Routes.login,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImageConstants.splashScreen),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: (170 / Dimensions.designWidth).h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Spectrum",
                style: TextStyles.primaryBold.copyWith(
                  color: Colors.black,
                  fontSize: (50 / Dimensions.designWidth).w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
