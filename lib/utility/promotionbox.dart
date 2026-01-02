import 'dart:async';

import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';


class Promotionbox extends StatefulWidget {
  final List<String> imageUrls;
  const Promotionbox({
    super.key,
    required this.imageUrls,
  });

  @override
  State<Promotionbox> createState() => _PromotionboxState();
}

class _PromotionboxState extends State<Promotionbox> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  List<String> _loopedImages = [];

  @override
  void initState() {
    super.initState();
    _prepareLoopedData();
    _startAutoScroll();
  }

  void _prepareLoopedData() {
    _loopedImages = [...widget.imageUrls, ...widget.imageUrls];
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double current = _scrollController.offset;

        if (current >= maxScroll / 2) {
          // Reset to start half way (seamless loop)
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            current + 2, // move by 2px
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      }
    });
  }
  

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        height: 110,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kgrey),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 174, 174, 174),
              offset: const Offset(0, 4),
              blurRadius: 2,
            )
          ],
        ),
        child: widget.imageUrls.isEmpty
            ? const Center(
                child: Text(
                  "No Data",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5,bottom: 7,left: 10,),
                        child: Text(
                          'People Trusted',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: const Color.fromARGB(255, 54, 54, 54),
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _loopedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: promotors(
                            _loopedImages[index],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Widget promotors(String image) => Container(
  height: 60,
  width: 60,
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: kgrey),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: const Color.fromARGB(255, 174, 174, 174),
        offset: const Offset(0, 4),
        blurRadius: 2,
      )
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Image.network(
      image,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png',
          fit: BoxFit.contain,
        );
      },
    ),
  ),
);
