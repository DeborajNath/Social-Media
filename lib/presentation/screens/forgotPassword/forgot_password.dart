import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_spectrum/main.dart';
import 'package:shop_spectrum/presentation/screens/login/login.dart';
import 'package:shop_spectrum/presentation/widgets/index.dart';
import 'package:shop_spectrum/utils/constant/index.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const LoginUserIdScreen();
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: AppBarLeading(
                onTap: () {},
              ),
              title: Text(
                'Reset Password',
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
              child: FocusScope(
                autofocus: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Receive an Email to Reset your Password",
                      textAlign: TextAlign.center,
                      style: TextStyles.primaryBold.copyWith(
                        color: Colors.black54,
                        fontSize: (24 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(
                      height: 30,
                    ),
                    CustomTextField(
                      borderColor: (_emailController.text.contains('@') &&
                              _emailController.text.contains('.'))
                          ? _isEmailValid ||
                                  _emailController.text.isEmpty ||
                                  !_emailController.text.contains('@') ||
                                  (_emailController.text.contains('@') &&
                                      (RegExp("[A-Za-z0-9.-]").hasMatch(
                                          _emailController.text
                                              .split('@')
                                              .last)) &&
                                      !(_emailController.text
                                          .split('@')
                                          .last
                                          .contains(
                                            RegExp(
                                                r'[!@#$%^&*(),_?":{}|<>\/\\]'),
                                          )))
                              ? const Color(0xFFEEEEEE)
                              : Colors.red
                          : const Color(0xFFEEEEEE),
                      controller: _emailController,
                      suffixIcon: buildCheckCircle(context),
                      onChanged: emailValidation,
                    ),
                    const SizeBox(
                      height: 30,
                    ),
                    buildSubmitButton(context),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    if (!_isEmailValid) {
      return SolidButton(
        onTap: () {},
        text: "Reset Password",
      );
    } else {
      return GradientButton(
          onTap: () {
            FocusScope.of(context).unfocus();
            resetPassword();
          },
          text: "Reset Password");
    }
  }

  Widget buildCheckCircle(BuildContext context) {
    if (!_isEmailValid) {
      return Padding(
        padding: EdgeInsets.only(right: (18 / Dimensions.designWidth).w),
        child: InkWell(
          onTap: () {
            _emailController.clear();
          },
          child: SvgPicture.asset(
            ImageConstants.deleteText,
            width: (17.5 / Dimensions.designWidth).w,
            height: (17.5 / Dimensions.designWidth).w,
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(right: (18 / Dimensions.designWidth).w),
        child: SvgPicture.asset(
          ImageConstants.checkCircle,
          width: (20 / Dimensions.designWidth).w,
          height: (20 / Dimensions.designWidth).w,
        ),
      );
    }
  }

  void emailValidation(String p0) {
    setState(() {
      _isEmailValid = EmailValidator.validate(p0);
    });
  }

  Future resetPassword() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      UtilsGreen.showSnackBar('Password Reset Email Sent');
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      FocusScope.of(context).unfocus();
      Utils.showSnackBar(e.message);
    }
    // ignore: use_build_context_synchronously
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
