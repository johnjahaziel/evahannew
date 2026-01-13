// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:evahan/providers/languageprovider.dart';
import 'package:evahan/utility/customappbar.dart';
import 'package:evahan/utility/customdrawer.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Adminusersettings extends StatefulWidget {
  final String userid;
  const Adminusersettings({
    super.key,
    required this.userid
  });

  @override
  State<Adminusersettings> createState() => _AdminusersettingsState();
}

class _AdminusersettingsState extends State<Adminusersettings> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isGenerating = false;
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController phonecontroller = TextEditingController();

  File? selectedImage;
  bool isEditingEmail = false;
  bool isEditingPhone = false;

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

  Future<void> pickerImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadphoto() async{
    final url = Uri.parse('https://app.evahansevai.com/api/user/update-photo');

    final userid = widget.userid;

    try {
      final request = await http.MultipartRequest('POST', url);

      request.fields['user_id'] = userid;

      print('Form Fields:');
      request.fields.forEach((key, value) {
        print('$key: $value');
      });

      if (selectedImage != null) {
        final fileExtension = selectedImage!.path.split('.').last.toLowerCase();
        String mimeType = 'image/jpeg';

        if (fileExtension == 'png') {
          mimeType = 'image/png';
        } else if (fileExtension != 'jpg' && fileExtension != 'jpeg') {
          Fluttertoast.showToast(msg: "Unsupported image format. Use JPG, JPEG, or PNG.");
          return;
        }

        final file = File(selectedImage!.path);
        if (!await file.exists()) {
          Fluttertoast.showToast(msg: "Image file not found.");
          return;
        }

        print('Uploading image: ${selectedImage!.path}');
        print('Image size: ${await file.length()} bytes');

        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            selectedImage!.path,
            contentType: MediaType('image', mimeType.split('/').last),
          ),
        );
      }

      var response = await request.send();

      final responseBody = await response.stream.bytesToString();

      final responseData = jsonDecode(responseBody);

      if(response.statusCode == 200) {
        Fluttertoast.showToast(msg: responseData['message']);
        await fetchUserData();
      } else {
        Fluttertoast.showToast(msg: responseData['message']);

        print(responseData);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchUserData() async {
    print("Received User ID: ${widget.userid}");

    try {
      final url = Uri.parse('https://app.evahansevai.com/api/users');

      final response = await http.get(
        url,
        headers: {
          'Accept' : 'application/json',
          'Content-Type' : 'application/json'
        }
      );

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200) {

      final List<dynamic> users = responseData;

      final Map<String, dynamic> matchedUser = users
          .cast<Map<String, dynamic>>()
          .firstWhere(
            (user) => user['id'].toString() == widget.userid.toString(),
            orElse: () => {},
          );

      print("Matched User: $matchedUser");

      if (matchedUser.isEmpty) {
        Fluttertoast.showToast(msg: "User not found");
        return;
      }

      setState(() {
        userData = matchedUser;

        firstname = matchedUser['first_name'];
        lastname  = matchedUser['last_name'];
        email     = matchedUser['email'];
        aadhar    = matchedUser['aadhar'];
        number    = matchedUser['phone_number'].toString();
        state     = matchedUser['state_name'];
        district  = matchedUser['district_name'];
        village   = matchedUser['village_name'];
        photo     = matchedUser['photo'];

        isLoading = false;
      });

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

  Future<void> genertateid() async{
    final url = Uri.parse('https://app.evahansevai.com/api/user/${widget.userid}/generate-id-card');

    setState(() {
      isGenerating = true;
    });

    try {

      final response = await http.get(
        url,
        headers: {
          'Accept' : 'application/json',
          'Content-Type' : 'application/json'
        }
      );

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200) {
        Fluttertoast.showToast(msg: responseData['message']);

        print(responseData);

      } else {
        Fluttertoast.showToast(msg: responseData['message']);
      }

    } catch (e) {
      print(e);
    } finally {
      setState(() {
      isGenerating = false;
    });
    }
  }

  // Future<void> updateuser() async {
  //   final url = Uri.parse('https://app.hopetuti.com/api.php/user/update/admin');

  //   final userId = widget.userid;

  //   try {
  //     final request = http.MultipartRequest('POST', url);

  //     request.fields['userId'] = userId;
  //     request.fields['email'] = emailcontroller.text;
  //     request.fields['phone_number'] = phonecontroller.text;

  //     final streamedResponse = await request.send();

  //     final response = await http.Response.fromStream(streamedResponse);

  //     final responseData = jsonDecode(response.body);

  //     if (response.statusCode == 200) {

  //       Fluttertoast.showToast(msg: responseData['msg']);

  //       await fetchUserData();

  //       setState(() {
  //         isEditingEmail = false;
  //         isEditingPhone = false;
  //       });
  //     } else {
  //       Fluttertoast.showToast(msg: 'Error: ${responseData['msg']}');
  //     }
  //   } catch (e) {
  //     print('Update error: $e');
  //     Fluttertoast.showToast(msg: 'An error occurred');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<Languageprovider>(context);
    final isTamil = langProvider.language == 'Tamil';
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Customdrawer(),
        appBar: Customappbar(),
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
                                    isTamil ? '' : 'View Profile Picture',
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
                                          child: photo != null && photo.toString().isNotEmpty
                                            ? AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: Image.network(
                                                  '$photo',
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Image.asset(
                                                      'images/user.jpg',
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                            )
                                            : AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: Image.asset(
                                                  'images/user.jpg',
                                                  fit: BoxFit.cover,
                                                ),
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
                                    isTamil ? '' : 'Change Profile Picture',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    await pickerImage();
                                    if (selectedImage != null) {
                                      await uploadphoto();
                                    } else {
                                      Fluttertoast.showToast(msg: "No image selected");
                                    }
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
                            CircleAvatar(
                              radius: 100,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: (photo != null && photo.toString().isNotEmpty)
                                  ? NetworkImage(photo!)
                                  : const AssetImage('images/user.jpg') as ImageProvider,
                              onBackgroundImageError: (_, __) {
                              },
                              child: (photo == null || photo.toString().isEmpty)
                                  ? ClipOval(
                                      child: Image.asset(
                                        'images/user.jpg',
                                        fit: BoxFit.cover,
                                        width: 200,
                                        height: 200,
                                      ),
                                    )
                                  : null,
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
            // SizedBox(height: 5),
            // Center(
            //   child: userData?['is_verified'] == "1" ? verifiedy() : notverifiedy()
            // ),
            SizedBox(height: 10),
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
            // if(isEditingEmail == true || isEditingPhone == true)
            // Padding(
            //   padding: const EdgeInsets.only(top: 20,left: 10),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       updateuser();
            //     },
            //     style: ButtonStyle(
            //       backgroundColor: WidgetStatePropertyAll(kred)
            //     ),
            //     child: Text(
            //       "Update User",
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontFamily: 'Poppins',
            //         fontWeight: FontWeight.bold
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
        floatingActionButton: ElevatedButton(
        onPressed: isGenerating ? null : genertateid,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(kred),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
        ),
        child: isGenerating
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
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

  Widget profwithedit(String text1, String text2, TextEditingController controller, bool isEditingField, VoidCallback onEditTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              text1,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: isEditingField
                ? TextField(
                    controller: controller,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 72, 0, 0)
                        )
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kred
                        )
                      )
                    ),
                  )
                : Text(
                    text2,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
          ),
          RawMaterialButton(
            onPressed: onEditTap,
            shape: CircleBorder(),
            constraints: BoxConstraints.tightFor(height: 35, width: 35),
            child: Icon(
              Icons.edit_note,
              size: 30,
            ),
          ),
        ],
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

// notverifiedy() => Container(
//   decoration: BoxDecoration(
//     color: kred,
//     borderRadius: BorderRadius.circular(15)
//   ),
//   child: Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           Icons.close,
//           color: Colors.white,
//           size: 12,
//         ),
//         SizedBox(
//           width: 3,
//         ),
//         Text(
//           'Not Verified',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w500
//           ),
//         ),
//         SizedBox(
//           width: 2,
//         ),
//       ],
//     ),
//   ),
// );

// verifiedy() => Container(
//   decoration: BoxDecoration(
//     color: Colors.green,
//     borderRadius: BorderRadius.circular(15)
//   ),
//   child: Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           Icons.verified,
//           color: Colors.white,
//           size: 12,
//         ),
//         SizedBox(
//           width: 3,
//         ),
//         Text(
//           'Verified',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w500
//           ),
//         ),
//         SizedBox(
//           width: 2,
//         ),
//       ],
//     ),
//   ),
// );