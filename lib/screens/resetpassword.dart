import 'dart:convert';

import 'package:evahan/login.dart';
import 'package:evahan/utility/customappbar.dart';
import 'package:evahan/utility/customs.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Resetpassword extends StatefulWidget {
  final String phoneNumber;

  const Resetpassword({super.key, required this.phoneNumber});

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  String getOtp() {
    return otpControllers.map((c) => c.text).join();
  }

  Future<void> verifyOtp() async {
    final otp = getOtp();

    if (otp.length != 4) {
      _showSnack('Enter valid 4-digit OTP');
      return;
    }

    if (passwordController.text.length < 6) {
      _showSnack('Password must be at least 6 characters');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showSnack('Passwords do not match');
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://app.evahansevai.com/api/forgot-password/reset'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "phone_number": widget.phoneNumber,
          "otp": otp,
          "password": passwordController.text,
          "password_confirmation": confirmPasswordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showSnack(data['message']);
        Navigator.pop(context);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
          ((route) => false)
        );
        
      } else {
        _showSnack(data['message'] ?? 'Invalid OTP');
        print(data);
      }
    } catch (e) {
      _showSnack('Something went wrong');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: Customappbar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
          
              /// Logo
              Center(
                child: Image.asset(
                  'images/evahanlogo.png',
                  height: 100,
                ),
              ),
          
              const SizedBox(height: 40),
          
              /// OTP text
              Text(
                "OTP sent to +91 ${widget.phoneNumber}",
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
          
              const SizedBox(height: 50),
          
              /// New password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
          
              const SizedBox(height: 16),
          
              /// Confirm password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
          
              const SizedBox(height: 60),
          
              /// Button
              isLoading
                  ? CircularProgressIndicator(color: kred)
                  : button(
                    'Verify OTP',
                    () {
                      verifyOtp();
                    }
                  )
            ],
          ),
        ),
      ),
    );
  }
}
