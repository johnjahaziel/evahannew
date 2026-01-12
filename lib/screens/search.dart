// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:evahan/providers/userprovider.dart';
import 'package:evahan/screens/profile.dart';
import 'package:evahan/utility/customappbar.dart';
import 'package:evahan/utility/customdrawer.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<dynamic> searchdata = [];
  bool isLoading = true;
  List<dynamic> allUsers = [];
  List<dynamic> filteredUsers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchsearchdata();
    searchController.addListener(_onsearchChanged);
  }

  Future<void> fetchsearchdata() async {
    final url = Uri.parse('https://app.evahansevai.com/api/users');

    try{
      final response = await http.get(
        url,
        headers: {
          'Accept' : 'application/json',
          'Content-Type' : 'application/json'
        }
      );

      if(response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<dynamic> users = data;

        setState(() {
          searchdata = data;
          allUsers = users;
          filteredUsers = users;
          isLoading = false;
        });
      } else {
        print('Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _onsearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = allUsers.where((users) {
        final fullname = '${users['first_name'] ?? ''} ${users['last_name'] ?? ''}'.toLowerCase();
        final businessname = (users['business_name'] ?? '').toLowerCase();
        final location = (users['location'] ?? '').toLowerCase();
        return fullname.contains(query) || businessname.contains(query) || location.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userrole = Provider.of<Userprovider>(context,listen: false).roleId;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Customdrawer(),
        appBar: Customappbar(),
        body: isLoading ? Center(
          child: CircularProgressIndicator(
            color: kred,
          ),
        ) : Column(
          children: [
            searchfield(
              'Search',
              searchController
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return searchbox(
                    user['first_name'] ?? '',
                    user['last_name'] ?? '',
                    user['business_name'] ?? '',
                    user['category_name'] ?? '',
                    user['id']?.toString() ?? '',
                    user['email'] ?? '',
                    user['phone_number']?.toString() ?? '',
                    user['state_name']?.toString() ?? '',
                    user['district_name']?.toString() ?? '',
                    user['village_name']?.toString() ?? '',
                    () {
                      if (userrole == '1') {
                        Navigator.push(
                          context,
                          // MaterialPageRoute(builder: (context) => Adminusersettings(userid: user['id'].toString()))
                          MaterialPageRoute(builder: (context) => Profile(userid: user['id'].toString()))
                        );
                      } else {
                        return;
                      }
                    }
                  );
                },
              ),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     showModalBottomSheet(
        //       isScrollControlled: true,
        //       context: context,
        //       builder: (context) {
        //         return Filter();
        //       }
        //     );
        //   },
        //   backgroundColor: kred,
        //   child: Icon(
        //     Icons.filter_alt,
        //     color: Colors.white,
        //   ),
        // ),
      )
    );
  }
    
  Widget searchfield(String title, TextEditingController searchController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: kgrey,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              color: const Color.fromARGB(255, 191, 191, 191),
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: title,
            hintStyle: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff9B7F7F),
              fontSize: 14,
            ),
            filled: true,
            fillColor: kgrey,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: searchController.text.isEmpty
                ? Icon(Icons.search, color: Colors.black54)
                : IconButton(
                    icon: Icon(Icons.clear, color: Colors.black54),
                    onPressed: () {
                      searchController.clear();
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget searchbox(
    String firstname,
    String lastname,
    String businessname,
    String category,
    String userid,
    String email,
    String mobile,
    String state,
    String district,
    String taluk,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          RawMaterialButton(
            onPressed: onTap,
            fillColor: kblackgrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 15, left: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$firstname $lastname',
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  sizedBox(),
                  Text(
                    'Business Name: $businessname',
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                  sizedBox(),
                  Text(
                    'Category: $category',
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                  sizedBox(),
                  Text(
                    'User ID: $userid',
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                  sizedBox(),
                  Text(
                    'Email: $email',
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                  sizedBox(),
                  Text(
                    'Mobile: $mobile',
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                  sizedBox(),
                  Text(
                    'Location: $state > $district > $taluk',
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 12,
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

  sizedBox() => SizedBox(height: 10);
}
