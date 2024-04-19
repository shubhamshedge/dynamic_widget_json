import 'package:dyanamic_form_with_json/dynamic_form_2/app_constant.dart';
import 'package:flutter/material.dart';

import 'dynamic_field_model.dart';

class Utils {
  static String? validateEmail(item, String value) {
    String p = item;
    RegExp regExp = RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }
    return AppConstant.strEmailEmpty;
  }

  static bool labelHidden(item) {
    if ((item as Fields).hiddenLabel != null) {
      if (item.hiddenLabel is bool) {
        return !item.hiddenLabel!;
      }
    } else {
      return true;
    }
    return false;
  }

  static void showSnackBar(BuildContext context, String msg) {
    var snackBar = SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
