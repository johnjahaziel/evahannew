import 'dart:convert';

import 'package:evahan/utility/customappbar.dart';
import 'package:evahan/utility/customdrawer.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  bool isLoading = true;

  Map<String, dynamic> fixedRoles = {};
  List<dynamic> coordinators = [];
  List<dynamic> members = [];

  @override
  void initState() {
    super.initState();
    fetchCommunity();
  }

  Future<void> fetchCommunity() async {
    final response = await http.get(
      Uri.parse("https://app.evahansevai.com/api/management/details"),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {

      setState(() {
        fixedRoles = data['details']['fixed_roles'] ?? {};
        coordinators = data['details']['coordinators'] ?? [];
        members = data['details']['members'] ?? [];
        isLoading = false;
      });
    } else {
      isLoading = false;

      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kwhite,
        appBar: Customappbar(),
        drawer: Customdrawer(),
        body: isLoading
            ? Center(child: CircularProgressIndicator(color: kred,))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _sectionTitle("Leadership"),
                    Row(
                      children: [
                        Expanded(
                          child: _bigRoleCard(
                            title: "President",
                            name: fixedRoles['president'],
                            color: Colors.orange,
                          ),
                        ),
                        Expanded(
                          child: _bigRoleCard(
                            title: "Secretary",
                            name: fixedRoles['secretary'],
                            color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: _bigRoleCard(
                            title: "Treasurer",
                            name: fixedRoles['treasurer'],
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle("Coordinators"),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: coordinators.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        return _nameCard(coordinators[index]);
                      },
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle("Members"),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: members.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3.2,
                      ),
                      itemBuilder: (context, index) {
                        return _memberTile(members[index]);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}


Widget _bigRoleCard({
  required String title,
  required String name,
  required Color color,
}) {
  return Card(
    elevation: 4,
    margin: const EdgeInsets.all(6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _nameCard(String name) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Center(
      child: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    ),
  );
}

Widget _memberTile(String name) {
  final String initial =
      name.isNotEmpty ? name[0].toUpperCase() : '?';

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        
        Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.indigo],
            ),
          ),
          child: Center(
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
