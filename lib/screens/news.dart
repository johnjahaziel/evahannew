import 'dart:convert';

import 'package:evahan/navigation.dart';
import 'package:evahan/providers/userprovider.dart';
import 'package:evahan/utility/customs.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final TextEditingController title = TextEditingController();
  final TextEditingController content = TextEditingController();

  String titlee = '';
  String contente = '';

  bool isLoading = false;

  Future<void> _news() async{
    setState(() {
      isLoading = true;
    });

    final userid = Provider.of<Userprovider>(context, listen: false).userId;

    try{
      final response = await http.post(
        Uri.parse('https://app.evahansevai.com/api/newsletters/store'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userid.toString(),
          'heading': title.text,
          'content': content.text
        })
      );

      print(userid);
      print(title.text);
      print(content.text);

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200){

        setState(() {
          isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Navigation(initialIndex: 1,)),
        );

        Fluttertoast.showToast(msg: responseData['message']);
      } else if (response.statusCode == 422) {
        setState(() {
          titlee   = responseData['errors']['heading']?.toString() ?? '';
          contente = responseData['errors']['content']?.toString() ?? '';
        });

        Fluttertoast.showToast(
          msg: responseData['message']?.toString() ?? 'Validation error',
        );

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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'News Letter',
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
              'Whats new today?',
              'Title',
              title
            ),
            if (titlee.isNotEmpty)
            errortext(titlee),
            const SizedBox(height: 20),
            textfield2(
              'Tell us more about it',
              'Drop in your detailed note here',
              content
            ),
            if (contente.isNotEmpty)
            errortext(contente),
            const SizedBox(height: 60),
            button(
              'Submit',
              () {
                _news();
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
        controller: controller,
        maxLines: 8,
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