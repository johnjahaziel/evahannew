// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:evahan/login.dart';
import 'package:evahan/providers/languageprovider.dart';
import 'package:evahan/utility/customdatefield.dart';
import 'package:evahan/utility/customdropdown.dart';
import 'package:evahan/utility/customs.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isPassword = false;

  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController passwordtext = TextEditingController();
  final TextEditingController aadhar = TextEditingController();
  final TextEditingController businessname = TextEditingController();
  final TextEditingController businessaddress = TextEditingController();
  final TextEditingController datecontroller = TextEditingController();
  final TextEditingController insurancedate = TextEditingController();
  final TextEditingController insuranceid = TextEditingController();

  final bloodgroupitems = bloodgroupItems;

  String? selectedbloodgroupitems;

  List<Map<String, dynamic>> categorydropdownItems = [];
  List<Map<String, String>> statedropdownItems = [];
  List<Map<String, String>> districtdropdownItems = [];
  List<Map<String, String>> talukdropdownItems = [];
  String? selectedCategory;
  String? selectedState;
  String? selectedDistrict;
  String? selectedtaluk;

  File? selectedImage;

  @override
  void initState() {
    super.initState();
    dropdowndata();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> dropdowndata() async {
    final categoryurl =
        Uri.parse('https://app.evahansevai.com/api/categories');
    final stateurl =
        Uri.parse('https://app.hopetuti.com/general.php/states');

    try {
      final categoryresponse = await http.get(categoryurl);
      final stateresponse = await http.get(stateurl);

      if (categoryresponse.statusCode == 200 &&
          stateresponse.statusCode == 200) {

        final Map<String, dynamic> categoryresponses =
            jsonDecode(categoryresponse.body);
        final Map<String, dynamic> stateresponses =
            jsonDecode(stateresponse.body);

        final List<dynamic> categorydata = categoryresponses['data'];
        final List<dynamic> statedata = stateresponses['data'];

        setState(() {
          categorydropdownItems = categorydata
              .where((item) => item['id'] != 1 && item['id'] != 2)
              .map((item) {
                return {
                  'value': item['id'].toString(),
                  'label': item['name'].toString(),
                };
              }).toList();

          statedropdownItems = statedata.map((item) {
            return {
              'id': item['code'].toString(),
              'name': item['name'].toString(),
            };
          }).toList();
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> fetchDistricts(String stateCode) async {
    final districtUrl = Uri.parse('https://app.hopetuti.com/general.php/districts');

    try {
      final response = await http.post(
        districtUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'state_code': stateCode
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> districts = data['data'];

        setState(() {
          districtdropdownItems = districts.map((item) {
            return {
              'id': item['district_code'].toString(),
              'name': item['name'].toString(),
            };
          }).toList();
          selectedDistrict = null;
        });
      } else {
        print("Failed to load districts. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("District fetch error: $e");
    }
  }

  Future<void> fetchtaluk(String districtCode) async {
    final talukurl = Uri.parse('https://app.hopetuti.com/general.php/taluks');

    try{
      final response = await http.post(
        talukurl,
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({
          'district_code': districtCode
        })
      );

      if(response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> talukdata = data['data'];

        setState(() {
          talukdropdownItems = talukdata.map((item) {
            return {
              'id': item['id'].toString(),
              'name': item['name'].toString(),
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> newuser() async {
    try {
      var uri = Uri.parse('https://app.evahansevai.com/api/register');
      var request = http.MultipartRequest('POST', uri);

      request.fields['first_name'] = firstname.text;
      request.fields['last_name'] = lastname.text;
      request.fields['email'] = email.text;
      request.fields['phone_number'] = mobile.text;
      request.fields['password'] = passwordtext.text;
      request.fields['category_id'] = selectedCategory.toString();
      request.fields['state_code'] = selectedState.toString();
      request.fields['district_code'] = selectedDistrict.toString();
      request.fields['village_code'] = selectedtaluk.toString();
      request.fields['aadhar'] = aadhar.text;
      request.fields['business_name'] = businessname.text;
      request.fields['business_address'] = businessaddress.text;
      request.fields['blood_group'] = selectedbloodgroupitems!.toString();
      request.fields['dob'] = datecontroller.text;
      request.fields['insurance_id'] = insuranceid.text;
      request.fields['insurance_exp_date'] = insurancedate.text;

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
      final jsonResp = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: jsonResp['message']);

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Registration is Successful',
                style: TextStyle(
                  fontFamily: 'Poppins'
                ),
              ),
              content: Text(
                'our admin will contact you through Email',
                style: TextStyle(
                  fontFamily: 'Poppins'
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login()
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold
                    ),
                  )
                )
              ],
            );
          }
        );

        print(jsonResp);
      } else {
        Fluttertoast.showToast(msg: jsonResp['message'] ?? "Sign Up Failed");

        print(jsonResp);
      }
    } catch (e) {
      print("Error: $e");
      Fluttertoast.showToast(msg: "Error occurred during registration");
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<Languageprovider>(context);
    final isTamil = langProvider.language == 'Tamil';

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            isTamil ? 'பயனர் பதிவு' : 'User Registration',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12,),
              textfield2(
                isTamil ? 'முதல் பெயர்' : 'First Name',
                'Eg. John',
                firstname
              ),
              const SizedBox(height: 12,),
              textfield2(
                isTamil ? 'கடைசி பெயர்' : 'Last Name',
                'Eg. Wick',
                lastname
              ),
              const SizedBox(height: 12,),
              textfield2(
                isTamil ? 'மின்னஞ்சல்' : 'Email',
                'evahann@gmail.com',
                email
              ),
              const SizedBox(height: 12,),
              textfield2(
                isTamil ? 'கைபேசி' : 'Mobile',
                '1234567890',
                mobile
              ),
              const SizedBox(height: 12,),
              passwordsignup(
                isTamil ? 'கடவுச்சொல்' : 'Password',
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                    icon: isPassword ? Icon(
                      FontAwesomeIcons.solidEyeSlash,
                      color: Colors.black,
                      size: 20,
                    ) : Icon(
                      FontAwesomeIcons.solidEye,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                isPassword,
                passwordtext,
              ),
              const SizedBox(height: 12,),
              CustomDropdownDropdown(
                title: 'Blood Group',
                selectedCustomDropdown: selectedbloodgroupitems,
                customDropdowndropdownItems: bloodgroupitems,
                onChanged: (newValue) {
                  setState(() {
                    selectedbloodgroupitems = newValue;
                  });
                },
              ),
              const SizedBox(height: 12,),
              Dateofbirthfield(
                title: 'Date of Birth',
                datecontroller: datecontroller,
                star: false,
                padding: true,
              ),
              const SizedBox(height: 12,),
              textfield2(
                isTamil ? 'காப்பீட்டு அடையாள எண்' : 'Insurance ID',
                '1234567890',
                insuranceid
              ),
              const SizedBox(height: 12,),
              Followupdate(
                title: 'Insurance Exp',
                datecontroller: insurancedate,
                star: false,
                padding: true,
              ),
              const SizedBox(height: 12,),
              texty(
                isTamil ? 'வகை' : 'Category'
              ),
              categorydropdowm(),
              const SizedBox(height: 12,),
              texty(
                isTamil ? 'இடம்' : 'Location'
              ),
              statedropdown(),
              const SizedBox(height: 12,),
              districtDropdown(),
              const SizedBox(height: 12,),
              talukDropdown(),
              const SizedBox(height: 12,),
              textfield2(
                isTamil ? 'ஆதார்' : 'Aadhaar',
                'Eg. 416526786532',
                aadhar
              ),
              const SizedBox(height: 12,),
              textfield2(
                isTamil ? 'வணிகத்தின் பெயர்' : 'Business Name',
                'Enterprise',
                businessname
              ),
              const SizedBox(height: 12,),
              textfield2(
                isTamil ? 'வணிக முகவரி' : 'Business Address',
                'Eg. no 40 , bharathi street',
                businessaddress
              ),
              const SizedBox(height: 12,),
              upload(),
              const SizedBox(height: 30),
              button(
                isTamil ? 'சமர்ப்பிக்க' : 'Submit',
                () {
                  newuser();
                }
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      )
    );
  }

  Widget categorydropdowm() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Container(
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedCategory,
            hint: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'Select Category',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color.fromARGB(255, 137, 137, 137),
                  fontSize: 12,
                ),
              ),
            ),
            dropdownColor: Colors.white,
            isExpanded: true,
            borderRadius: BorderRadius.circular(10),
            icon: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Icon(Icons.arrow_drop_down),
            ),
            items: categorydropdownItems.map((item) {
              return DropdownMenuItem<String>(
                value: item['value'],
                child: Text(
                  '${item['label']}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue!;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget statedropdown() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Container(
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedState,
            hint: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'Select State',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color.fromARGB(255, 137, 137, 137),
                  fontSize: 12,
                ),
              ),
            ),
            dropdownColor: Colors.white,
            isExpanded: true,
            borderRadius: BorderRadius.circular(10),
            icon: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Icon(Icons.arrow_drop_down),
            ),
            items: statedropdownItems.map((item) {
              return DropdownMenuItem<String>(
                value: item['id'],
                child: Text(
                  item['name']!,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedState = newValue!;
              });
              fetchDistricts(newValue!);
            },
          ),
        ),
      ),
    );
  }

  Widget districtDropdown() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Container(
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String>(
          value: selectedDistrict,
          hint: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              'Select District',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromARGB(255, 137, 137, 137),
                fontSize: 12,
              ),
            ),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          icon: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Icon(Icons.arrow_drop_down),
          ),
          items: districtdropdownItems.map((item) {
            return DropdownMenuItem<String>(
              value: item['id'],
              child: Text(
                item['name']!,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedDistrict = newValue!;
              selectedtaluk = null;
            });
            fetchtaluk(newValue!);
          },
        ),
      ),
    );
  }

  Widget talukDropdown() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Container(
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String>(
          value: selectedtaluk,
          hint: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              'Select Taluk',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromARGB(255, 137, 137, 137),
                fontSize: 12,
              ),
            ),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          icon: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Icon(Icons.arrow_drop_down),
          ),
          items: talukdropdownItems.map((item) {
            return DropdownMenuItem<String>(
              value: item['id'],
              child: Text(
                item['name']!,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedtaluk = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget upload() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 25),
        child: Text(
          'Profile Photo',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xff919EAB),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 2),
                color: Colors.grey,
                blurRadius: 2,
              )
            ],
            border: Border.all(color: Colors.black),
          ),
          child: RawMaterialButton(
            onPressed: _pickImage,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          selectedImage!,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.cloud_upload_outlined),
                const SizedBox(height: 10),
                Text(
                  selectedImage != null ? 'Image Uploaded' : 'Upload a image',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Max Image size 2 mb',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff939292),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

textfield2(String title, String title2, TextEditingController controller) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xff919EAB)
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 25,right: 25,top: 10),
      child: TextField(
        maxLines: 1,
        controller: controller,
        decoration: InputDecoration(
          hintText: title2,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xff6C5B5B),
            fontSize: 11,
          ),
          filled: true,
          fillColor: Color(0xffD9D9D9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none
          )
        )
      ),
    ),
  ],
);

fieldbox(String title, TextEditingController controller) => Padding(
  padding: const EdgeInsets.only(left: 25,right: 25),
  child: TextField(
    maxLines: 1,
    decoration: InputDecoration(
      hintText: title,
      hintStyle: TextStyle(
        fontFamily: 'Poppins',
        color: Color(0xff6C5B5B),
        fontSize: 11,
      ),
      filled: true,
      fillColor: Color(0xffD9D9D9),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none
      )
    )
  ),
);

texty(String title) => Column(
  children: [
    Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xff919EAB)
        ),
      ),
    ),
    const SizedBox(height: 10,),
  ],
);

passwordsignup(String title, suffixIcon,bool isPassword,TextEditingController controller) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 25),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xff919EAB)
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: TextField(
          maxLines: 1,
          controller: controller,
          obscureText: !isPassword,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: kgrey
              )
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: kgrey
              )
            ),
            filled: true,
            fillColor: Color(0xffD9D9D9),
            suffixIcon: suffixIcon
          ),
        ),
      ),
    ],
  ),
);