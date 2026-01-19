import 'dart:convert';

import 'package:evahan/utility/customs.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Pending extends StatefulWidget {
  const Pending({super.key});

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  bool isLoading = false;
  List<dynamic> alldata = [];

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> _updateDriverStatus(
    String userId,
    String status,
  ) async {

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
      'https://app.evahansevai.com/api/report-user/update-status',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "report_id": userId,
          "status": status,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: responseData['message'] ?? "Status updated",
        );

        setState(() {
          isLoading = false;
        });

        print(responseData);

        fetchdata();
      } else {
        Fluttertoast.showToast(
          msg: responseData['message'] ?? "Action failed",
        );

        print(responseData);

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      debugPrint("API Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _approveDriver(String userid) {
    _updateDriverStatus(userid, "1");
  }

  void _rejectDriver(String userid) {
    _updateDriverStatus(userid, "3");
  }

  Future<void> fetchdata() async{
    final url = Uri.parse('https://app.evahansevai.com/api/report-user/pending');

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
        final data = adata[index];
        return reportbox(
          data['issue_description'],
          data['user_id'].toString(),
          data['created_at'],
          () {
            _showActionSheet(
              context,
              () {
                Navigator.pop(context);
                _approveDriver(adata[index]['id'].toString(),);
              },
              () {
                Navigator.pop(context);
                _rejectDriver(adata[index]['id'].toString(),);
              },
            );
          },
        );
      },
    );
  }
}

void _showActionSheet(BuildContext context, VoidCallback onapprove, VoidCallback onreject) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                "Take Action",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kblack,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text("Approve"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onapprove
              ),

              const SizedBox(height: 12),

              ElevatedButton.icon(
                icon: const Icon(Icons.cancel, color: Colors.white),
                label: const Text("Reject"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onreject
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }