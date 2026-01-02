import 'dart:convert';

import 'package:evahan/utility/carousel.dart';
import 'package:evahan/utility/promotionbox.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<String> topadimageList = [];
  List<String> bottomadimageList = [];
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchTopAdImages();
    fetchBottomAdImages();
    fetchTrusted();
  }

  Future<void> fetchTopAdImages() async {
    final url = Uri.parse(
      "https://app.evahansevai.com/api/views/homepage/topad",
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (!mounted) return;

        setState(() {
          topadimageList =
              List<String>.from(data['data'] ?? []);
        });

      }
    } catch (e) {
      debugPrint("TopAd Error: $e");
    }
  }

  Future<void> fetchBottomAdImages() async {
    final url = Uri.parse("https://app.evahansevai.com/api/views/homepage/bottomad");

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (!mounted) return;

        setState(() {
          bottomadimageList =
              List<String>.from(data['data'] ?? []);
        });

      }
    } catch (e) {
      debugPrint("TopAd Error: $e");
    }
  }

  Future<void> fetchTrusted() async {
    final url = Uri.parse(
      "https://app.evahansevai.com/api/views/homepage/trusted_property",
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (!mounted) return;

        setState(() {
          imageUrls =
              List<String>.from(data['data'] ?? []);
        });

      }
    } catch (e) {
      debugPrint("TopAd Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          topadimageList.isEmpty
            ? SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator(color: kred,)),
              )
            : Carousel(imageList: topadimageList),
          SizedBox(height: 20),
          Promotionbox(imageUrls: imageUrls),
          SizedBox(height: 20),
          bottomadimageList.isEmpty
            ? SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator(color: kred,)),
              )
            : Carousel(imageList: bottomadimageList),
        ],
      ),
    );
  }
}