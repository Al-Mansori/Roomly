import 'package:flutter/material.dart';

const TextStyle pageTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

BoxShadow globalShadow = BoxShadow(
  color: Colors.black.withOpacity(0.25),
  offset: Offset(0, 4),
  blurRadius: 4, // Blur radius
  spreadRadius: 0, // Spread radius (0 means the shadow will only be around the border)
);
