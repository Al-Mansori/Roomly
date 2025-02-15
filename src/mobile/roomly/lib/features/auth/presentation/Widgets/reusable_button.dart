import 'package:flutter/material.dart';

List<Color> g = const [Colors.white, Color(0xFF898989)];

class ReusableButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final VoidCallback onPressed;
  final bool isGradiant;
  final String? imagePath;
  final Color color;

  const ReusableButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isGradiant = false,
    this.textColor = Colors.white,
    this.imagePath,
    this.color = const Color(0xFF0A3FB3),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Ink(
        decoration: BoxDecoration(
          gradient: isGradiant ? LinearGradient(
            colors: g,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ) : null,
          color: isGradiant ? null : color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imagePath != null) ...[
                  Image.asset(imagePath!, width: 24, height: 24),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
