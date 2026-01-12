import 'dart:convert';

import 'package:evahan/providers/userprovider.dart';
import 'package:evahan/screens/news.dart';
import 'package:evahan/utility/customs.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Newsletter extends StatefulWidget {
  const Newsletter({super.key});

  @override
  State<Newsletter> createState() => _NewsletterState();
}

class _NewsletterState extends State<Newsletter> {
  bool isLoading = true;
  Map<String, dynamic> alldata = {};

  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  Future<void> fetchdata() async{
    final url = Uri.parse('https://app.evahansevai.com/api/newsletters');

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
          alldata = responseData;
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
    final userrole = Provider.of<Userprovider>(context,listen: false).roleId;
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
                  final List adata = alldata['data'];

                  return ListView.builder(
                    itemCount: adata.length,
                    itemBuilder: (context, index) {
                      final data = adata[index];
                      return homebox(
                        data['heading'],
                        data['content'],
                        data['user']['first_name'],
                        data['user']['last_name'],
                        data['created_at'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: userrole == 1 ? FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => News()),
            );
          },
          shape: CircleBorder(),
          backgroundColor: kred,
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ) : null,
      ),
    );
  }
}