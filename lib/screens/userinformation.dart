import 'dart:convert';

import 'package:evahan/screens/approveuser.dart';
import 'package:evahan/utility/customs.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Userinformation extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String uesrid;
  final String category;
  final String state;
  final String district;
  final String taluk;
  final String mobileno;
  final String email;
  const Userinformation({
    super.key,
    required this.firstname,
    required this.lastname,
    required this.uesrid,
    required this.category,
    required this.state,
    required this.district,
    required this.taluk,
    required this.mobileno,
    required this.email,
  });
  @override
  State<Userinformation> createState() => _UserinformationState();
}

class _UserinformationState extends State<Userinformation> {

  Future<void> approve() async{
    final url = Uri.parse('https://app.evahansevai.com/api/users/${widget.uesrid}/approval');

    try{
      final response = await http.post(
        url,
        headers: {
          'Accept' : 'application/json',
          'Content-Type' : 'application/json'
        },
        body: jsonEncode({
          'approval_status' : 1
        })
      );

      if(response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Approved User Successfully');
      } else {
        Fluttertoast.showToast(msg: 'Error in approving');
      }

    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> reject() async{
    final url = Uri.parse('https://app.evahansevai.com/api/users/${widget.uesrid}/approval');

    try{
      final response = await http.post(
        url,
        headers: {
          'Accept' : 'application/json',
          'Content-Type' : 'application/json'
        },
        body: jsonEncode({
          'approval_status' : 3
        })
      );

      if(response.statusCode == 200) {
        await Fluttertoast.showToast(msg: 'Rejected Successfully');
      } else {
        await Fluttertoast.showToast(msg: 'Error in disapproving');
      }

    } catch (e) {
      print('Error: $e');
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
            'User Information',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: kblackgrey,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5,),
                    text(
                      'First Name',
                      widget.firstname
                    ),
                    text(
                      'Last Name',
                      widget.lastname
                    ),
                    text(
                      'User ID',
                      widget.uesrid
                    ),
                    text(
                      'Category',
                      widget.category
                    ),
                    text(
                      'Location',
                      '${widget.state} > ${widget.district} > ${widget.taluk}'
                    ),
                    text(
                      'Mobile',
                      widget.mobileno
                    ),
                    text(
                      'Email',
                      widget.email
                    ),
                    const SizedBox(height: 5,),
                  ],
                ),
              ),
            ),
            button(
              'Approve',
              () {
                approve();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Approveuser()),
                );
              }
            ),
            const SizedBox(height: 15),
            button1(
              'Reject',
              () {
                reject();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Approveuser()),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

text(String title, String ans) => Padding(
  padding: const EdgeInsets.only(top: 10,left: 15,bottom: 10),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.grey,
          fontSize: 12
        ),
      ),
      const SizedBox(
        height: 3,
      ),
      Text(
        ans,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14
        ),
      ),
    ],
  ),
);

button1(String title, VoidCallback onTap) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
    ),
    child: RawMaterialButton(
      onPressed: onTap,
      fillColor: Colors.black,
      elevation: 2,
      constraints: BoxConstraints.tightFor(
        height: 55,
        width: double.infinity
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),
      ),
    ),
  ),
);