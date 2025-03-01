import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(2, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem("Home", true),
          _navItem("Search", false),
          _navItem("Booking", false),
          _navItem("Favorit", false),
          _navItem("Account", false),
        ],
      ),
    );
  }

  Widget _navItem(String title, bool isActive) {
    return Text(
      title,
      style: TextStyle(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
        fontSize: 12,
        fontWeight: FontWeight.w400,
        shadows: [Shadow(offset: Offset(2, 4), blurRadius: 4, color: Colors.black.withOpacity(0.25))],
      ),
    );
  }
}
