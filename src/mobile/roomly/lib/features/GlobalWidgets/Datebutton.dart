import 'package:flutter/material.dart';


class ResponsiveContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.15,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Number of seats: 2',
                  style: _textStyle(),
                ),
                SizedBox(height: 8),
                Text(
                  'Total 114.0 EGP',
                  style: _textStyle(),
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.02), // Adds spacing
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10),
                backgroundColor: Color(0xFF0A3FB3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {},
              child: FittedBox(
                child: Text(
                  'Review Booking',
                  style: _textStyle(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
    );
  }
}
