import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:shop_spectrum/presentation/screens/login/login.dart';
import 'package:shop_spectrum/presentation/widgets/appbar_leading.dart';

import 'package:shop_spectrum/utils/constant/index.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // _setInitialScreen(User? user) async {
  //   user == null
  //       ? Get.offAll(() => const LoginUserIdScreen())
  //       : user.emailVerified
  //           ? Get.offAll(() => const Dashboard())
  //           : Get.offAll(() => const VerifyEmailScreen());
  // }

  @override
  Widget build(BuildContext context) {
    // isEmailVerified
    //     ? const LoginUserIdScreen()
    //     :
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (isEmailVerified) {
            return const LoginUserIdScreen();
          } else {
            return Scaffold(
              appBar: AppBar(
                leading: AppBarLeading(
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'Verify Email',
                  style: TextStyles.primaryBold.copyWith(
                    color: Colors.black,
                    fontSize: (20 / Dimensions.designWidth).w,
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (PaddingConstants.horizontalPadding /
                          Dimensions.designWidth)
                      .w,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "A verification link has been sent to your given Email Id.",
                      textAlign: TextAlign.center,
                      style: TextStyles.primaryBold.copyWith(
                        color: Colors.black54,
                        fontSize: (24 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // GradientButton(
                    //     onTap: canResendEmail
                    //         ? () => sendVerificationEmail
                    //         : () {},
                    //     text: "Resend Email")
                  ],
                ),
              ),
            );
          }
        });
  }
}
