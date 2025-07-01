// custom_alert_dialog.dart
import 'package:flutter/material.dart';

enum AlertType { success, error, warning, info }

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final AlertType alertType;
  final String buttonText;
  final VoidCallback? onPressed;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.alertType,
    this.buttonText = 'OK',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      icon: _getIcon(),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: _getTitleColor(),
        ),
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          child: Text(
            buttonText,
            style: TextStyle(color: _getButtonColor()),
          ),
        ),
      ],
    );
  }

  Widget _getIcon() {
    switch (alertType) {
      case AlertType.success:
        return const Icon(Icons.check_circle, color: Colors.green, size: 48);
      case AlertType.error:
        return const Icon(Icons.error, color: Colors.red, size: 48);
      case AlertType.warning:
        return const Icon(Icons.warning, color: Colors.orange, size: 48);
      case AlertType.info:
        return const Icon(Icons.info, color: Colors.blue, size: 48);
    }
  }

  Color _getTitleColor() {
    switch (alertType) {
      case AlertType.success:
        return Colors.green;
      case AlertType.error:
        return Colors.red;
      case AlertType.warning:
        return Colors.orange;
      case AlertType.info:
        return Colors.blue;
    }
  }

  Color _getButtonColor() {
    switch (alertType) {
      case AlertType.success:
        return Colors.green;
      case AlertType.error:
        return Colors.red;
      case AlertType.warning:
        return Colors.orange;
      case AlertType.info:
        return Colors.blue;
    }
  }
}