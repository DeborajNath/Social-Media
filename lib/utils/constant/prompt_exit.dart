import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shop_spectrum/presentation/widgets/index.dart';
import 'package:shop_spectrum/utils/constant/index.dart';

class PromptExit {
  static void promptUser(BuildContext context, bool isInitial) async {
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
            actionWidget: SolidButton(
              color: Colors.white,
              fontColor: Colors.black,
              onTap: () {
                Navigator.pop(context);
              },
              text: "No",
            ),
            auxWidget: GradientButton(
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
  }
}
