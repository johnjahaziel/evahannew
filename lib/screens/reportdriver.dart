import 'dart:convert';

import 'package:evahan/utility/customs.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Reportdriver extends StatefulWidget {
  const Reportdriver({super.key});

  @override
  State<Reportdriver> createState() => _ReportdriverState();
}

class _ReportdriverState extends State<Reportdriver> {
  bool isLoading = true;
  List<dynamic> alldata = [];

  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  Future<void> fetchdata() async{
    final url = Uri.parse('https://app.evahansevai.com/api/report-user');

    try{
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
          alldata = responseData['data'];
          isLoading = false;
        });

        // Fluttertoast.showToast(msg: responseData['message']);

      } else {
        print('Error: $response');

        Fluttertoast.showToast(msg: "Failed to load data");
        // Fluttertoast.showToast(msg: responseData['message']);
      }
    } catch (e) {
      print("Error: $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Scaffold(
      backgroundColor: bg,
      body: isLoading ?
        Center(child: CircularProgressIndicator(color: kred,)) :
        Column(
          children: [
            const SizedBox(height: 20),

            Expanded(
              child: Builder(
                builder: (context) {
                  final List adata = alldata;

                  return ListView.builder(
                    itemCount: adata.length,
                    itemBuilder: (context, index) {
                      final data = adata[index];
                      return homebox(
                        data['issue_description'],
                        data['user_id'].toString(),
                        data['user']['first_name'],
                        data['user']['last_name'],
                        data['user']['phone_number'].toString(),
                        data['created_at'],
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
}