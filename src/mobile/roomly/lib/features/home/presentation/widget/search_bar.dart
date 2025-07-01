import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(127, 0, 0, 0),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search Workspaces',
                hintStyle: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 127)),
                border: InputBorder.none,
                icon: SvgPicture.asset(
                  'assets/icons/magnifying-glass-solid.svg',
                  width: 15,
                  height: 15,
                  colorFilter: const ColorFilter.mode(
                    Color.fromRGBO(255, 255, 255, 127),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}