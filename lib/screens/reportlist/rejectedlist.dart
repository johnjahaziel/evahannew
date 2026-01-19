import 'dart:convert';

import 'package:evahan/utility/customs.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Rejected extends StatefulWidget {
  const Rejected({super.key});

  @override
  State<Rejected> createState() => _RejectedState();
}

class _RejectedState extends State<Rejected> {
  bool isLoading = false;
  List<dynamic> alldata = [];

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> fetchdata() async{
    final url = Uri.parse('https://app.evahansevai.com/api/report-user/rejected');

    setState(() {
      isLoading = true;
    });

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

        final data = responseData['data'];

        setState(() {
          alldata = data;
          isLoading = false;
        });

        print(alldata);

        // Fluttertoast.showToast(msg: responseData['message']);

      } else {
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        setState(() {
          alldata = [];
          isLoading = false;
        });

        Fluttertoast.showToast(msg: "Failed to load data");
        // Fluttertoast.showToast(msg: responseData['message']);
      }
    } catch (e) {
      print("Error: $e");

      setState(() {
        alldata = [];
        isLoading = false;
      });
    } 
  }
  
  @override
  Widget build(BuildContext context) {
    final List adata = alldata;
    return isLoading ? Center(
        child: CircularProgressIndicator(color: kred),
      )
    : adata.isEmpty ? Center(
        child: Text(
          "No Data found",
          style: customtext(fs14, kblack),
        ),
      )
    : ListView.builder(
      itemCount: adata.length,
      itemBuilder: (context, index) {
        final data = adata[index];
        return reporttakenbox(
          data['issue_description'],
          data['user_id'].toString(),
          data['created_at'],
        );
      },
    );
  }
}