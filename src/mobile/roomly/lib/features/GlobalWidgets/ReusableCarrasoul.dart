import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ReusableCarousel extends StatelessWidget {
  final List<String> images;
  final double height;
  final bool autoPlay;
  final bool showOverlay;

  ReusableCarousel({
    required this.images,
    this.height = 200.0,
    this.autoPlay = true,
    this.showOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: height,
                viewportFraction: 1.0,
                autoPlay: autoPlay,
                enlargeCenterPage: true,
              ),
              items: images.map((imageUrl) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
            if (showOverlay)
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}