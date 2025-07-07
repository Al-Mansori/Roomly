// dialog_helper.dart
import 'package:flutter/material.dart';
import 'package:roomly/features/GlobalWidgets/pop_p.dart';

void showCustomDialog({
  required BuildContext context,
  required String title,
  required String message,
  required AlertType alertType,
  String buttonText = 'OK',
  VoidCallback? onPressed,
  bool barrierDismissible = true,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => CustomAlertDialog(
      title: title,
      message: message,
      alertType: alertType,
      buttonText: buttonText,
      onPressed: () => Navigator.of(context).pop(),
    ),
  );
}