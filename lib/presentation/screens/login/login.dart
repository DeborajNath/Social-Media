import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_spectrum/main.dart';
import 'package:shop_spectrum/presentation/routers/routes.dart';
import 'package:shop_spectrum/presentation/screens/dashboard/dashboard.dart';
import 'package:shop_spectrum/presentation/widgets/index.dart';
import 'package:shop_spectrum/utils/constant/index.dart';

class LoginUserIdScreen extends StatefulWidget {
  const LoginUserIdScreen({super.key});

  @override
  State<LoginUserIdScreen> createState() => _LoginUserIdScreenState();
}

class _LoginUserIdScreenState extends State<LoginUserIdScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEmailValid = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Dashboard();
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
                onTap: () {
                  PromptExit.promptUser(context, true);
                },
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
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Log in",
                            style: TextStyles.primaryBold.copyWith(
                              color: Colors.black,
                              fontSize: (28 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(
                            height: 36,
                          ),
                          Row(
                            children: [
                              Text(
                                "User ID",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: Colors.black,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              Text(
                                " (Email address)",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: Colors.black,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(
                            height: 14,
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
                            height: 24,
                          ),
                          Row(
                            children: [
                              Text(
                                "Password",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: Colors.black,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(
                            height: 14,
                          ),
                          CustomTextField(
                            minLines: 1,
                            maxLines: 1,
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: _obscurePassword
                                  ? Icon(
                                      Icons.visibility_off_outlined,
                                      color: Colors.black38,
                                      size: (17.5 / Dimensions.designWidth).w,
                                    )
                                  : Icon(
                                      Icons.visibility_outlined,
                                      color: const Color(0xffD19B2A),
                                      size: (17.5 / Dimensions.designWidth).w,
                                    ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            onChanged: (p0) {},
                          ),
                          const SizeBox(
                            height: 14,
                          ),
                          buildSubmitButton(context),
                          const SizeBox(
                            height: 36,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Routes.forgotPassword);
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: Colors.black,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.registration);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account?  ",
                              style: TextStyles.primary.copyWith(
                                color: Colors.black,
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Register",
                                  style: TextStyles.primaryBold.copyWith(
                                    color: const Color(0xffD19B2A),
                                    fontSize: (16 / Dimensions.designWidth).w,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizeBox(
                      height: PaddingConstants.bottomPadding +
                          MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
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

  Widget buildSubmitButton(BuildContext context) {
    if (!_isEmailValid) {
      return SolidButton(
        onTap: () {},
        text: "Login",
      );
    } else {
      return GradientButton(
          onTap: () {
            FocusScope.of(context).unfocus();
            login();
          },
          text: "Login");
    }
  }

  Future login() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      UtilsGreen.showSnackBar('Login Successful');
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      FocusScope.of(context).unfocus();
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
