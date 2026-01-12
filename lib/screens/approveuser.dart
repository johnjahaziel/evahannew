// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:evahan/screens/userinformation.dart';
import 'package:evahan/utility/customappbar.dart';
import 'package:evahan/utility/customdrawer.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Approveuser extends StatefulWidget {
  const Approveuser({super.key});

  @override
  State<Approveuser> createState() => _ApproveuserState();
}

class _ApproveuserState extends State<Approveuser> {
  bool isSelected = true;
  bool _isLoading = true;
  List<dynamic> takendata = [];
  List<dynamic> pendingdata = [];

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> fetchdata() async{
    final takenurl = Uri.parse('https://app.evahansevai.com/api/approved-users');
    final pendingurl = Uri.parse('https://app.evahansevai.com/api/pending-users');

    try {
      final takenresponse = await http.get(takenurl);
      final pendingresponse = await http.get(pendingurl);

      if(takenresponse.statusCode == 200 && pendingresponse.statusCode == 200) {
        List<dynamic> takedata = jsonDecode(takenresponse.body);
        List<dynamic> pendindata = jsonDecode(pendingresponse.body);

        setState(() {
          takendata = takedata;
          pendingdata = pendindata;
          _isLoading = false;
        });
      } else {
        print('Failed to load data. Status Code: ${takenresponse.statusCode}');
        print('Failed to load data. Status Code: ${pendingresponse.statusCode}');
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
          drawer: Customdrawer(),
          appBar: Customappbar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0,2),
                      blurRadius: 2,
                      color: const Color.fromARGB(255, 206, 206, 206)
                    )
                  ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              isSelected = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected ? kred : Colors.transparent
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child: Text(
                                'Action Pending',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: isSelected ? Colors.white : kred,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              isSelected = false;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected ? Colors.transparent : kred,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child: Text(
                                'Action Taken',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: isSelected ? kred : Colors.white,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: kred,
                        ),
                      )
                    : isSelected
                      ? Builder(
                          builder: (context) {
                            final List<dynamic> userList = List.from(pendingdata).reversed.toList();

                            return ListView.builder(
                              itemCount: userList.length,
                              padding: const EdgeInsets.only(bottom: 20),
                              itemBuilder: (context, index) {
                                final user = userList[index];
                                return pending(
                                  context,
                                  user['first_name'] ?? '',
                                  user['last_name'] ?? '',
                                  user['email'] ?? '',
                                  user
                                );
                              },
                            );
                          },
                        )
                      : Builder(
                          builder: (context) {
                            final List<dynamic> userList = List.from(takendata).reversed.toList();

                            return ListView.builder(
                              itemCount: userList.length,
                              padding: const EdgeInsets.only(bottom: 20),
                              itemBuilder: (context, index) {
                                final user = userList[index];
                                return taken(
                                  user['first_name'] ?? '',
                                  user['last_name'] ?? '',
                                  user['email'] ?? '',
                                );
                              },
                            );
                          },
                        ),
              ),
            ],
          ),
      ),
    );
  }

  pending(BuildContext context, String firstname, String lastname, String email, Map<String, dynamic> user) => Padding(
    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
    child: Stack(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kblackgrey,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                color: const Color.fromARGB(255, 196, 196, 196),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$firstname $lastname',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: RawMaterialButton(
            fillColor: kred,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Userinformation(
                    firstname: firstname,
                    lastname: lastname,
                    uesrid: user['id'].toString(),
                    category: user['category_name'] ?? '',
                    state: user['state_name'] ?? '',
                    district: user['district_name'] ?? '',
                    taluk: user['village_name'] ?? '',
                    mobileno: user['phone_number'].toString(),
                    email: email,
                  ),
                ),
              );
            },
            shape: CircleBorder(),
            constraints: BoxConstraints.tightFor(
              width: 40,
              height: 40,
            ),
            child: Icon(
              Icons.chevron_right_sharp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );

  taken(String firstname, String lastname, String email) => Padding(
    padding: const EdgeInsets.only(left: 15, right: 15,bottom: 15),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          // height: 75,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 177, 227, 179),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                color: const Color.fromARGB(255, 196, 196, 196),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 15,bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$firstname $lastname',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}