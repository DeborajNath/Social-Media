import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:shop_spectrum/presentation/widgets/index.dart';
import 'package:shop_spectrum/utils/constant/index.dart';

class AppBarLeading extends StatelessWidget {
  const AppBarLeading({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (22 / Dimensions.designWidth).w,
      ),
      child: InkWell(
        onTap: onTap ??
            () {
              bool canPop = Navigator.canPop(context);
              log("canPop -> $canPop");
              if (canPop) {
                Navigator.pop(context);
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialog(
                      svgAssetPath: ImageConstants.warning,
                      title: "Exit App?",
                      message: "Do you really want to close the app?",
                      auxWidget: SolidButton(
                        color: Colors.orangeAccent,
                        fontColor: Colors.deepOrangeAccent,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        text: "No",
                      ),
                      actionWidget: GradientButton(
                        onTap: () {
                          if (Platform.isAndroid) {
                            Navigator.pop(context);
                            SystemNavigator.pop();
                          } else {
                            Navigator.pop(context);
                            exit(0);
                          }
                        },
                        text: "Yes",
                      ),
                    );
                  },
                );
              }
            },
        child: SvgPicture.asset(
          ImageConstants.arrowBack,
        ),
      ),
    );
  }
}
