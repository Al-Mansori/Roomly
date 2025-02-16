import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const CustomAppBar({
    Key? key,
    required this.icon,
    this.backgroundColor = Colors.transparent,
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 45,
          height: 45,
          decoration: const BoxDecoration(
            color: Color(0xFF7F7F7F),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop(); // Go back to the previous page
              } else {
                context.go('/'); // Fallback if no previous page exists
              }
            },
            icon: Icon(icon, color: iconColor),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
