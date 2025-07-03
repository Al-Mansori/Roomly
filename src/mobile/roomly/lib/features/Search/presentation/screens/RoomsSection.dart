import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoomResultCard extends StatefulWidget {
  final String imageUrl;
  final String roomId;
  final String workspaceId;
  final String title;
  final String workspaceName;
  final String details;
  final String price;

  const RoomResultCard({
    super.key,
    required this.imageUrl,
    required this.roomId,
    required this.workspaceId,
    required this.title,
    required this.workspaceName,
    required this.details,
    required this.price,
  });

  @override
  _RoomResultCardState createState() => _RoomResultCardState();
}

class _RoomResultCardState extends State<RoomResultCard> {
  bool isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    void _navigateToRoom() {
      context.push('/room/${widget.roomId}',
          extra: {'workspaceId': widget.workspaceId});
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            GestureDetector(
              onTap: _navigateToRoom,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.imageUrl,
                  width: screenWidth * 0.9,
                  height: screenWidth * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  widget.workspaceName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: _navigateToRoom,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF0A3FB3),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Text(
                  widget.price,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 4),
        Text(
          widget.details,
          style: TextStyle(
            color: Color(0xFF808080),
            fontSize: screenWidth * 0.03,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
