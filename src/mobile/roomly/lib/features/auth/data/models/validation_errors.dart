// validation_indicators.dart
import 'package:flutter/material.dart';

class ValidationErrorText extends StatelessWidget {
  final bool showError;
  final String errorText;

  const ValidationErrorText({
    super.key,
    required this.showError,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return showError
        ? Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
      child: Text(
        errorText,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    )
        : const SizedBox.shrink();
  }
}

class PasswordRequirements extends StatelessWidget {
  final String password;

  const PasswordRequirements({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password must contain:',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        _buildRequirement(
          'At least 10 characters',
          password.length >= 10,
        ),
        _buildRequirement(
          'At least one uppercase letter',
          password.contains(RegExp(r'[A-Z]')),
        ),
        _buildRequirement(
          'At least one lowercase letter',
          password.contains(RegExp(r'[a-z]')),
        ),
        _buildRequirement(
          'At least one number',
          password.contains(RegExp(r'[0-9]')),
        ),
        _buildRequirement(
          'At least one special character (@#\$%^&+=!)',
          password.contains(RegExp(r'[@#$%^&+=!]')),
        ),
      ],
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Text(
      '• $text',
      style: TextStyle(
        color: isMet ? Colors.green : Colors.grey,
        fontSize: 12,
      ),
    );
  }
}