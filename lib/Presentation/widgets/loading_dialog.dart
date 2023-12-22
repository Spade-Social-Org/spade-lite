import 'package:flutter/material.dart';
import 'package:spade_lite/Common/navigator.dart';

void loadingDialog() => showDialog(
      context: kNavigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Container(
          color: Colors.black,
          child: Center(child: Image.asset("assets/images/ShuffleE.gif")),
        );
      },
    );
