import 'dart:convert';

import 'package:evahan/utility/customs.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Approved extends StatefulWidget {
  const Approved({super.key});

  @override
  State<Approved> createState() => _ApprovedState();
}

class _ApprovedState extends State<Approved> {
  bool isLoading = false;
  List<dynamic> alldata = [];

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> fetchdata() async{
    final url = Uri.parse('https://app.evahansevai.com/api/reports/accepted');

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
        print('Error: $response');

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
        return reporttakenbox(adata[index], context , () {});
      },
    );
  }
}

Widget reporttakenbox(Map data, BuildContext context, VoidCallback onTap, {bool isbuttonshow = false}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: data['photos'] != null &&
                      data['photos'].isNotEmpty
                  ? NetworkImage(data['photos'][0])
                  : const AssetImage('images/user.jpg') as ImageProvider,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    data['driver_name'] ?? '-',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    "S/O ${data['father_name'] ?? '-'}",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${data['state']} > ${data['district']} > ${data['village']}",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            const Icon(Icons.access_time, size: 14, color: Colors.grey),
            const SizedBox(width: 6),
            if(isbuttonshow == true)
            Text(
              formatDateTime(data['created_at'] ?? ''),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: Color(0xFF666666),
              ),
            ),
            if(isbuttonshow == false)
            Text(
              data['created_at'] ?? '',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: Color(0xFF666666),
              ),
            )
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  data['reason'] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            ),
            if(isbuttonshow == true)
            const SizedBox(width: 12),
            if(isbuttonshow == true)
            RawMaterialButton(
              onPressed: onTap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              fillColor: klightred,
              child: Text(
                'Take Action',
                style: textmedium10.copyWith(
                  color: kwhite
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
