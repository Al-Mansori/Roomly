import 'dart:async';
import 'package:flutter/material.dart';
class FloatingBotIcon extends StatefulWidget {
  final VoidCallback onTap;

  const FloatingBotIcon({
    super.key,
    required this.onTap,
  });

  @override
  State<FloatingBotIcon> createState() => _FloatingBotIconState();
}

class _FloatingBotIconState extends State<FloatingBotIcon> {
  double _left = 20;
  bool _movingRight = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (!mounted) return;
      setState(() {
        _left += _movingRight ? 2 : -2;
        final maxLeft = MediaQuery.of(context).size.width - 70;
        if (_left >= maxLeft) _movingRight = false;
        if (_left <= 10) _movingRight = true;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: _left,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Image.asset(
          'assets/icons/robot.png',
          width: 60,
          height: 60,
        ),
      ),
    );
  }
}