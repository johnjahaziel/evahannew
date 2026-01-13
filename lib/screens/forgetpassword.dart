import 'dart:convert';

import 'package:evahan/screens/resetpassword.dart';
import 'package:evahan/utility/customs.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  final TextEditingController _usernameController = TextEditingController();

  Future<void> forgetpass() async {
    final url = Uri.parse('https://app.evahansevai.com/api/forgot-password/send-otp');

    try{
      final response = await http.post(
        url,
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({
          'phone_number': _usernameController.text
        })
      );

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200) {
        Fluttertoast.showToast(msg: responseData['message']);
        print(response.body);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Resetpassword(phoneNumber: _usernameController.text))
        );

      } else {
        Fluttertoast.showToast(msg: responseData['message']);
      }

    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Forgot Password',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 14
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: kblackgrey
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _usernameController,
                maxLines: 1,
                decoration: decor(
                  'Mobile Number'
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          SizedBox(height: 100),
          button(
            "Reset",
            forgetpass
          ),
          SizedBox(height: 40,)
        ],
      ),
    );
  }
}