// ignore_for_file: use_build_context_synchronously

import 'package:evahan/login.dart';
import 'package:evahan/navigation.dart';
import 'package:evahan/providers/languageprovider.dart';
import 'package:evahan/providers/userprovider.dart';
import 'package:evahan/screens/search.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Customdrawer extends StatefulWidget {
  const Customdrawer({super.key});

  @override
  State<Customdrawer> createState() => _CustomdrawerState();
}

class _CustomdrawerState extends State<Customdrawer> {
  String selectedLanguage = 'English';
  String selectedMenu = 'Home';

  @override
  void initState() {
    super.initState();
    final lang = Provider.of<Languageprovider>(context, listen: false).language;
    selectedLanguage = lang;
  }
  
  @override
  Widget build(BuildContext context) {
    final userrole = Provider.of<Userprovider>(context,listen: false).roleId;
    final langProvider = Provider.of<Languageprovider>(context);
    final isTamil = langProvider.language == 'Tamil';

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          drawerlist(
            Icons.home_outlined,
            isTamil ? 'முகப்பு' : 'Home',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Navigation())
              );
            }
          ),
          if(userrole == '1') ...[
            drawerlist(
              Icons.person_add_alt,
              isTamil ? 'புதிய பயனர்' : 'New User',
              () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Signup())
                // );
              }
            ),
          ],
          if(userrole == '1') ...[
            drawerlist(
              Icons.person_add_alt,
              isTamil ? 'பயனரை ஒப்புதல்' : 'Approve User',
              () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Approveuser())
                // );
              }
            ),
          ],
          drawerlist(
            Icons.person_search_outlined,
            isTamil ? 'தேடு' : 'Search',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Search())
              );
            }
          ),
          drawerlist(
            Icons.person_remove_alt_1_outlined,
            isTamil ? 'புகார் பதிவு' : 'Report User',
            () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Reportuser())
              // );
            }
          ),
          if(userrole == '1') ...[
            drawerlist(
              Icons.person_remove_alt_1_outlined,
              isTamil ? '	புகார்களின் பட்டியல்' :  'Report List',
              () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Reportlist())
                // );
              }
            ),
          ],
          logout(
            Icons.logout,
            isTamil ? 'வெளியேறு' : 'Logout',
            () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              
              Provider.of<Userprovider>(context, listen: false).logout();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false,
              );
            }
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: PopupMenuButton<String>(
              offset: const Offset(0, 40),
              onSelected: (String newValue) {
                setState(() {
                  selectedLanguage = newValue;
                });
                Provider.of<Languageprovider>(context, listen: false).setLanguage(newValue);
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'English',
                  child: Text(
                    'English',
                    style: TextStyle(
                      fontSize: 15,
                      color: selectedLanguage == 'English' ? kred : Colors.black,
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
                      color: selectedLanguage == 'Tamil' ? kred : Colors.black,
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
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 25),
            child: Text(
              'Powered by Bluon Tech',
              style: TextStyle(
                fontSize: 15,
                color: kred,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

drawerlist(IconData icon, String title, VoidCallback onTap) => RawMaterialButton(
  constraints: BoxConstraints.tightFor(height: 70),
  onPressed: onTap,
  child: Padding(
    padding: const EdgeInsets.only(left: 20),
    child: Row(
      children: [
        Icon(icon, size: 25),
        const SizedBox(width: 15),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: kmenu,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  ),
);

logout(IconData icon, String title, VoidCallback onTap) => RawMaterialButton(
  constraints: BoxConstraints.tightFor(height: 70),
  onPressed: onTap,
  child: Padding(
    padding: const EdgeInsets.only(left: 20),
    child: Row(
      children: [
        Icon(icon, size: 25, color: kred),
        const SizedBox(width: 15),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: kred,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  ),
);
