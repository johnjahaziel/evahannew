import 'dart:convert';

import 'package:evahan/navigation.dart';
import 'package:evahan/providers/languageprovider.dart';
import 'package:evahan/utility/customs.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Reportuser extends StatefulWidget {
  const Reportuser({super.key});

  @override
  State<Reportuser> createState() => _ReportuserState();
}

class _ReportuserState extends State<Reportuser> {
  final TextEditingController userid = TextEditingController();
  final TextEditingController description = TextEditingController();

  String useride = '';
  String descriptione = '';

  bool isLoading = false;

  Future<void> report() async{
    setState(() {
      isLoading = true;
    });

    try{
      final response = await http.post(
        Uri.parse('https://app.evahansevai.com/api/report-user/store'),
        headers: {
          'Content-Type': 'application/json',
          'Accept' : 'application/json'
        },
        body: jsonEncode({
          'user_id': userid.text,
          'issue_description': description.text,
        })
      );

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200) {
        
        setState(() {
          isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Navigation(initialIndex: 0,))
        );

        Fluttertoast.showToast(msg: responseData['message']);
      } else if (response.statusCode == 422) {
        Fluttertoast.showToast(msg: responseData['message']);

        setState(() {
          useride = responseData['errors']['user_id']?.toString() ?? '';
          descriptione = responseData['errors']['issue_description']?.toString() ?? '';
        });

        setState(() {
          isLoading = false;
        });

        print(responseData);
      } else {
        Fluttertoast.showToast(msg: responseData['message']);

        setState(() {
          isLoading = false;
        });

        print(responseData);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<Languageprovider>(context);
    final isTamil = langProvider.language == 'Tamil';
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            isTamil ? 'பயனரை புகாரளிக்க' : 'Report User',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: isLoading ? Center(
          child: CircularProgressIndicator(
            color: kred,
          ),
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            textfield(
              isTamil ? 'நீங்கள் எதற்கு/யாருக்கு புகார் அளிக்க விரும்புகிறீர்கள்?' : 'Whom do you want to report?',
              isTamil ? 'பயனர் ஐடி' : 'User ID',
              userid
            ),
            if (useride.isNotEmpty)
            errortext(useride),
            const SizedBox(height: 20),
            textfield2(
              isTamil ? 'என்ன நடந்தது' : 'What Happened',
              isTamil ? 'நிகழ்வைப் பற்றித் தெளிவாகச் சொல்லுங்கள்' : 'Tell us more about the incident',
              description
            ),
            if (descriptione.isNotEmpty)
            errortext(descriptione),
            const SizedBox(height: 60),
            button(
              isTamil ? 'சமர்ப்பிக்க' : 'Submit',
              () {
                report();
              }
            )
          ],
        ),
      )
    );
  }
}

textfield(String title, String title2, TextEditingController controller) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 25,right: 25,top: 10),
      child: TextField(
        maxLines: 1,
        controller: controller,
        decoration: InputDecoration(
          hintText: title2,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xff6C5B5B),
            fontSize: 11,
          ),
          filled: true,
          fillColor: Color(0xffD9D9D9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none
          )
        )
      ),
    ),
  ],
);

textfield2(String title, String title2, TextEditingController controller) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 25,right: 25,top: 10),
      child: TextField(
        maxLines: 8,
        controller: controller,
        decoration: InputDecoration(
          hintText: title2,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xff6C5B5B),
            fontSize: 11,
          ),
          filled: true,
          fillColor: Color(0xffD9D9D9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none
          )
        )
      ),
    ),
  ],
);