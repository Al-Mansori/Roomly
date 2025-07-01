import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'floating_bot_icon.dart';

class BotLayout extends StatelessWidget {
  final Widget child;

  const BotLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        FloatingBotIcon(
          onTap: () {
            context.push('/chatbot');
          },
        ),
      ],
    );
  }
}
