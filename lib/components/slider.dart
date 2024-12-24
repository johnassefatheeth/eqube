import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderP extends StatefulWidget {
  SliderP({Key? key}) : super(key: key);

  @override
  State<SliderP> createState() => _SliderPState();
}

class _SliderPState extends State<SliderP> {
  int activeIndex = 0;
  final controller = CarouselSliderController();
  // List of local asset images instead of URLs
  final assetImages = [
    '/images/pp3.png',
    '/images/pp1.jpg',
    '/images/pp2.jpg',
    '/images/pp4.jpg',
    '/images/pp5.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider.builder(
              carouselController: controller,
              itemCount: assetImages.length,
              itemBuilder: (context, index, realIndex) {
                final assetImage = assetImages[index];
                return buildImage(assetImage, index); // Use asset images
              },
              options: CarouselOptions(
                height: 140,
                autoPlay: true,
                enableInfiniteScroll: false,
                autoPlayAnimationDuration: Duration(seconds: 2),
                enlargeCenterPage: false,
                onPageChanged: (index, reason) =>
                    setState(() => activeIndex = index),
              ),
            ),
            SizedBox(height: 12),
            buildIndicator(),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        onDotClicked: animateToSlide,
        effect: ExpandingDotsEffect(dotWidth: 15, activeDotColor: Colors.blue),
        activeIndex: activeIndex,
        count: assetImages.length,
      );

  void animateToSlide(int index) => controller.animateToPage(index);
}

Widget buildImage(String assetImage, int index) =>
    Container(child: Image.asset(assetImage, fit: BoxFit.cover)); // Use Image.asset
