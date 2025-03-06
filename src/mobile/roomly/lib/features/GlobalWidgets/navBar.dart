import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../Search/CustomSearchBottom.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(2, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(context, "Home", FontAwesomeIcons.home, true, "/home"),
          _navItem(context, "Search", FontAwesomeIcons.search, false, "/search"),
          _navItem(context, "Booking", FontAwesomeIcons.calendar, false, "/booking"),
          _navItem(context, "Favorit", FontAwesomeIcons.heart, false, "/favorite"),
          _navItem(context, "Account", FontAwesomeIcons.user, false, "/profile"),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, IconData icon,
      bool isActive, String route) {
    return InkWell(
      onTap: () {
        if (route == "/search") {
          _showCustomBottomSheet(context);
        } else {
          context.go(route);
        }
      },      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          children: [
            FaIcon(
              icon,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
              size: 16,
            ),
            SizedBox(height: 5), // Space between icon and text
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                shadows: [
                  Shadow(offset: Offset(2, 4),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.25)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showCustomBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return CustomSearchBottomSheet();
    },
  );
}

