
import 'package:carousel_slider/carousel_slider.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class Carousel extends StatefulWidget {
  final List<dynamic> imageList;
  const Carousel({
    super.key,
    required this.imageList
  });

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late final List<String> imageList;

  @override
  void initState() {
    super.initState();

    if (widget.imageList.isEmpty) {
      imageList = [
        'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png'
      ];
    } else {
      imageList = widget.imageList.map<String>((img) =>
        '$img'
      ).toList();
    }
  }

  int _currentIndexTop = 0;
  final CarouselSliderController _carouselControllerTop = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2,top: 15),
              child: Center(
                child: CarouselSlider(
                  carouselController: _carouselControllerTop,
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    aspectRatio: 16 / 9,
                    autoPlayInterval: const Duration(seconds: 5),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndexTop = index;
                      });
                    },
                  ),
                  items: imageList.map((imageUrl) {
                    return Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: kgrey),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 2),
                              color: const Color.fromARGB(255, 185, 185, 185),
                              blurRadius: 2,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png',
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        ),
                      );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex: _currentIndexTop,
            count: imageList.length,
            effect: CustomizableEffect(
              activeDotDecoration: DotDecoration(
                width: 9,
                height: 9,
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(6),
                dotBorder: DotBorder(color: kred, width: 2),
              ),
              dotDecoration: DotDecoration(
                width: 6,
                height: 6,
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
                dotBorder: DotBorder(color: Colors.grey.shade700, width: 2),
              ),
            ),
            onDotClicked: (index) {
              _carouselControllerTop.animateToPage(index);
            },
          ),
        ),
      ],
    );
  }
}
