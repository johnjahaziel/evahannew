import 'dart:convert';

import 'package:evahan/navigation.dart';
import 'package:evahan/providers/languageprovider.dart';
import 'package:evahan/providers/userprovider.dart';
import 'package:evahan/utility/customs.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String selectedLanguage = 'English';

  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://app.evahansevai.com/api/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept' : 'application/json'
        },
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('isLoggedIn', true);

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final String userId = responseData['user_data']['reg_id'].toString();
        final String roleId = responseData['user_data']['category_id'].toString();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userid', userId);
        await prefs.setString('roleid', roleId);

        String? storedUserId = prefs.getString('userid');
        Provider.of<Userprovider>(context, listen: false).setUserId(
          storedUserId ?? userId,
          roleId
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Navigation()),
          ((route) => false)
        );

        Fluttertoast.showToast(msg: responseData['message']);
      } else {

        Fluttertoast.showToast(msg: responseData['message']);

      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<Languageprovider>(context);
    final isTamil = langProvider.language == 'Tamil';

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 60),
                    Center(
                      child: Image.asset(
                        'images/evahanlogo.png',
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 60),
                    Text(
                      isTamil ? 'வரவேற்கிறோம்' : 'Welcome Onboard',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: kgrey,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 2),
                            color: Color.fromARGB(255, 191, 191, 191),
                            blurRadius: 2,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _usernameController,
                        decoration: decor(isTamil ? 'மின்னஞ்சல்' : 'Email'),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: kgrey,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 2),
                            color: Color.fromARGB(255, 191, 191, 191),
                            blurRadius: 2,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: decor(isTamil ? 'கடவுச்சொல்' : 'Password'),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // showModalBottomSheet(
                          //   backgroundColor: Colors.white,
                          //   context: context,
                          //   builder: (_) => Forgetpassword(),
                          // );
                        },
                        child: Text(
                          isTamil
                              ? 'கடவுச்சொல்லை மறந்துவிட்டீர்களா?'
                              : 'Forget Password',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Color(0xff1A85EF),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                    _isLoading
                        ? CircularProgressIndicator(color: kred)
                        : button(isTamil ? 'உள்நுழையவும்' : 'Login', _login),
                    SizedBox(height: 20),
                    Text(
                      isTamil
                          ? 'உங்களிடம் கணக்கு இல்லையா?'
                          : "Don't you have an account?",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    signupbutton(() {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (_) => Signup()),
                      // );
                    }),
                    SizedBox(height: 60),
                    Text(
                      "Powered by Bluon Tech",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: kred,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: PopupMenuButton<String>(
                  color: Colors.white,
                  offset: const Offset(0, 40),
                  onSelected: (String newValue) {
                    setState(() {
                      selectedLanguage = newValue;
                    });
                    Provider.of<Languageprovider>(context, listen: false)
                        .setLanguage(newValue);
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem<String>(
                      value: 'English',
                      child: Text(
                        'English',
                        style: TextStyle(
                          fontSize: 15,
                          color: selectedLanguage == 'English'
                              ? kred
                              : Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Tamil',
                      child: Text(
                        'Tamil',
                        style: TextStyle(
                          fontSize: 15,
                          color: selectedLanguage == 'Tamil'
                              ? kred
                              : Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  child: Row(
                    children: [
                      Text(
                        '$selectedLanguage ▼',
                        style: TextStyle(
                          fontSize: 15,
                          color: kred,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget signupbutton(VoidCallback onTap) {
    final langProvider = Provider.of<Languageprovider>(context);
    final isTamil = langProvider.language == 'Tamil';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RawMaterialButton(
        onPressed: onTap,
        elevation: 2,
        constraints: BoxConstraints.tightFor(
          height: 55,
          width: double.infinity
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: kred,
            width: 1.5
          )
        ),
        child: Text(
          isTamil ? 'பதிவு செய்யவும்' : 'Sign-up',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: kred,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
