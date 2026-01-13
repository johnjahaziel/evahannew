import 'dart:convert';

import 'package:evahan/login.dart';
import 'package:evahan/utility/customappbar.dart';
import 'package:evahan/utility/customs.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Verifyotp extends StatefulWidget {
  final String phonenumber;
  const Verifyotp({
    super.key,
    required this.phonenumber
  });

  @override
  State<Verifyotp> createState() => _VerifyotpState();
}

class _VerifyotpState extends State<Verifyotp> {
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());

  late final String phoneNumber;

  @override
  void initState() {
    super.initState();
    phoneNumber = widget.phonenumber;
  }

  bool isLoading = false;

  String get otp =>
      otpControllers.map((controller) => controller.text).join();

  Future<void> verifyOtp() async {
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter 4 digit OTP")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {

      final response = await http.post(
        Uri.parse('https://app.evahansevai.com/api/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "phone_number": phoneNumber,
          "otp": otp,
        }),
      );

      setState(() => isLoading = false);

      final data = jsonDecode(response.body);

      if(response.statusCode == 200) {
        Fluttertoast.showToast(msg: data['message']);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
          ((route) => false)
        );
        
      } else {
        Fluttertoast.showToast(msg: data['message']);
        print(data);
      }
      
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(phoneNumber);
    return SafeArea(
      child: Scaffold(
        backgroundColor: kwhite,
        appBar: Customappbar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Center(
              child: Image.asset(
                'images/evahanlogo.png',
                height: 100,
              ),
            ),
            SizedBox(height: 80),
            Text(
              "OTP sent to +91 $phoneNumber",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
        
            const SizedBox(height: 40),
        
            /// OTP boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container( 
                  width: 55,
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: TextField(
                    controller: otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),
        
            const SizedBox(height: 120),
        
            isLoading
              ? CircularProgressIndicator(
                  color: kred,
                )
              : button(
              'Verify OTP',
              () {
                verifyOtp();
              }
            )
          ],
        ),
      ),
    );
  }
}
