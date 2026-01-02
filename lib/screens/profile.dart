import 'dart:convert';

import 'package:evahan/providers/languageprovider.dart';
import 'package:evahan/screens/newsletter.dart';
import 'package:evahan/screens/reportdriver.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String userid;
  const Profile({
    super.key,
    required this.userid
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;
  bool isGenerating = false;

  String? firstname;
  String? lastname;
  String? email;
  String? number;
  String? aadhar;
  String? state;
  String? district;
  String? village;
  String? photo;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    print("Received User ID: ${widget.userid}");

    try {
      final url = Uri.parse('https://app.evahansevai.com/api/report-user/${widget.userid}');

      final response = await http.get(
        url,
        headers: {
          'Accept' : 'application/json',
          'Content-Type' : 'application/json'
        }
      );

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200) {

        setState(() {
          userData = responseData['data'];
          isLoading = false;

          firstname = userData['user']['first_name'];
          lastname = userData['user']['last_name'];
          email = userData['user']['email'];
          aadhar = userData['user']['aadhar'];
          number = userData['user']['phone_number'].toString();
          state = userData['user']['state_code'];
          district = userData['user']['district_code'];
          village = userData['user']['village_code'];
        });

        // Fluttertoast.showToast(msg: responseData['message']);

      } else {
        print('Error: $response');

        Fluttertoast.showToast(msg: "Failed to load data");
        // Fluttertoast.showToast(msg: responseData['message']);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<Languageprovider>(context);
    final isTamil = langProvider.language == 'Tamil';
    
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: isLoading ?
            Center(child: CircularProgressIndicator(color: kred))
            : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 190,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: Image.asset(
                        'images/profile.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RawMaterialButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.photo,
                                    ),
                                    title: Text(
                                      'View Profile Picture',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (_) => Dialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: photo != null
                                              ? AspectRatio(
                                                  aspectRatio: 1 / 1,
                                                  child: Image(
                                                    image: NetworkImage(
                                                      'https://app.evahansevai.com/$photo',
                                                    ),
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  )
                                                )
                                              : AspectRatio(
                                                  aspectRatio: 1 / 1,
                                                  child: Image(
                                                    image: AssetImage(
                                                      'images/user.jpg'
                                                    ),
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  )
                                                ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.camera_alt,
                                    ),
                                    title: Text(
                                      'Change Profile Picture',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onTap: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            )
                          );
                        },
                        shape: const CircleBorder(),
                        fillColor: Colors.white,
                        constraints: const BoxConstraints.tightFor(
                          width: 120,
                          height: 120,
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ClipOval(
                                child: photo != null ?
                                Image(
                                  image: NetworkImage(
                                    'https://app.evahansevai.com/$photo',
                                  ),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ) : Image(
                                  image: AssetImage(
                                    'images/user.jpg'
                                  ),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              ),
                              const Icon(
                                Icons.edit_square,
                                color: Color.fromARGB(255, 89, 89, 89),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  '$firstname $lastname',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: userData['is_verified'] == "1" ? verifiedy() : notverifiedy()
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 124, 124, 124),
                        blurRadius: 2,
                        offset: Offset(0, 2)
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      prof(
                        isTamil ? 'மின்னஞ்சல்' : 'Email',
                        '$email',
                      ),
                      Divider(),
                      prof(
                        isTamil ? 'கைபேசி' : 'Phone no.',
                        '$number',
                      ),
                      Divider(),
                      prof(
                        isTamil ? 'ஆதார்' : 'Aadhar',
                        '$aadhar',
                      ),
                      Divider(),
                      prof(
                        isTamil ? 'இடம்' : 'Location',
                        '$state > $district > $village',
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  isTamil ? 'விரைவு இணைப்புகள்' : 'Quick Links',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      buttonn(
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Newsletter())
                          );
                        },
                        isTamil ? 'செய்தி' : 'News',
                        Icons.newspaper,
                      ),
                      SizedBox(width: 10),
                      buttonn(
                        () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => Search())
                          // );
                        },
                        isTamil ? 'தேடு' : 'Search',
                        Icons.search,
                      ),
                      SizedBox(width: 10),
                      buttonn(
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Reportdriver())
                          );
                        },
                        isTamil ? 'புகார் பதிவு' : 'Report User',
                        Icons.person_remove_alt_1_outlined,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: ElevatedButton(
            onPressed: () {},
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(kred),
            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
          ),
          child: Text(
            isTamil ? 'அடையாள அட்டை உருவாக்கு' : 'Generate ID card',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

prof(String text1, String text2) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
  child: Row(
    children: [
      SizedBox(
        width: 120,
        child: Text(
          text1,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      Expanded(
        child: Text(
          text2,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontSize: 12
          ),
        ),
      ),
    ],
  ),
);

buttonn(VoidCallback onTap, String text, IconData icon) => RawMaterialButton(
  onPressed: onTap,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: BorderSide(
      color: kred,
      width: 1.5
    )
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      children: [
        Icon(
          icon,
          color: kred,
          size: 18,
        ),
        SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: kred,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500
          ),
        ),
      ],
    ),
  ),
);

notverifiedy() => Container(
  decoration: BoxDecoration(
    color: kred,
    borderRadius: BorderRadius.circular(15)
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.close,
          color: Colors.white,
          size: 12,
        ),
        SizedBox(
          width: 3,
        ),
        Text(
          'Not Verified',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500
          ),
        ),
        SizedBox(
          width: 2,
        ),
      ],
    ),
  ),
);

verifiedy() => Container(
  decoration: BoxDecoration(
    color: Colors.green,
    borderRadius: BorderRadius.circular(15)
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.verified,
          color: Colors.white,
          size: 12,
        ),
        SizedBox(
          width: 3,
        ),
        Text(
          'Verified',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500
          ),
        ),
        SizedBox(
          width: 2,
        ),
      ],
    ),
  ),
);