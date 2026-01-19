import 'dart:convert';
import 'dart:io';

import 'package:evahan/navigation.dart';
import 'package:evahan/providers/languageprovider.dart';
import 'package:evahan/signup.dart';
import 'package:evahan/utility/customdropdown.dart';
import 'package:evahan/utility/customs.dart' hide textfield2;
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Reportform extends StatefulWidget {
  const Reportform({super.key});

  @override
  State<Reportform> createState() => _ReportformState();
}

class _ReportformState extends State<Reportform> {
  final TextEditingController drivername = TextEditingController();
  final TextEditingController fathername = TextEditingController();
  final TextEditingController mobileno = TextEditingController();
  List<Map<String, String>> statedropdownItems = [];
  List<Map<String, String>> districtdropdownItems = [];
  List<Map<String, String>> talukdropdownItems = [];
  String? selectedState;
  String? selectedDistrict;
  String? selectedtaluk;

  final reasonitems = reasonItems;

  String? selectedreasonitems;

  File? selectedImage;

  String drivernamee = '';
  String fathernamee = '';
  String mobilenoe = '';
  String selectedStatee = '';
  String selectedDistricte = '';
  String selectedtaluke = '';
  String selectedImagee = '';
  String reasonItemse = '';

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
    final stateurl =
        Uri.parse('https://app.evahansevai.com/api/states');

    try {
      final stateresponse = await http.get(stateurl);

      if (stateresponse.statusCode == 200) {

        final Map<String, dynamic> stateresponses = jsonDecode(stateresponse.body);

        final List<dynamic> statedata = stateresponses['data'];

        setState(() {
          statedropdownItems = statedata.map((item) {
            return {
              'id': item['state_code'].toString(),
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
    final districtUrl = Uri.parse('https://app.evahansevai.com/api/districts');

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

  Future<void> fetchtaluk(String districtCode, String stateCode) async {
    final talukurl = Uri.parse('https://app.evahansevai.com/api/villages');

    try{
      final response = await http.post(
        talukurl,
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({
          'state_code' : stateCode,
          'district_code': districtCode
        })
      );

      if(response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> talukdata = data['data'];

        setState(() {
          talukdropdownItems = talukdata.map((item) {
            return {
              'id': item['village_code'].toString(),
              'name': item['name'].toString(),
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> reportdriver() async {
    try {
      var uri = Uri.parse('https://app.evahansevai.com/api/driver-reports/store');
      var request = http.MultipartRequest('POST', uri);

      request.headers['Accept'] = 'application/json';

      request.fields['driver_name'] = drivername.text;
      request.fields['father_name'] = fathername.text;
      request.fields['phone_number'] = mobileno.text;
      request.fields['state_code'] = selectedState.toString();
      request.fields['district_code'] = selectedDistrict.toString();
      request.fields['village_code'] = selectedtaluk.toString();
      request.fields['reason'] = selectedreasonitems.toString();

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
            'photo[]',
            selectedImage!.path,
            contentType: http.MediaType('image', mimeType.split('/').last),
          ),
        );
      }

      var response = await request.send();

      final responseBody = await response.stream.bytesToString();
      final jsonResp = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: jsonResp['message']);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Navigation(initialIndex: 2,)
          )
        );

        print(jsonResp);
      } else if (response.statusCode == 422) {

        print(responseBody);

        final errors = jsonResp['errors'];

        setState(() {
          drivernamee = errors['driver_name']?.toString() ?? '';
          fathernamee = errors['father_name']?.toString() ?? '';
          mobilenoe = errors['phone_number']?.toString() ?? '';
          selectedStatee = errors['state_code']?.toString() ?? '';
          selectedDistricte = errors['district_code']?.toString() ?? '';
          selectedtaluke = errors['village_code']?.toString() ?? '';
          reasonItemse = errors['reason']?.toString() ?? '';
          selectedImagee = errors['photo']?.toString() ?? '';
        });

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
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          isTamil ? 'ஓட்டுநர் புகார்' : 'Report Driver',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            textfield2(
              isTamil ? 'டிரைவர் பெயர்' : 'Driver Name',
              'Eg. John',
              drivername
            ),
            if (drivernamee.isNotEmpty)
            errortext(drivernamee),
            const SizedBox(height: 12,),
            textfield2(
              isTamil ? 'தந்தை பெயர்' : 'Father Name',
              'Eg. John',
              fathername
            ),
            if (fathernamee.isNotEmpty)
            errortext(fathernamee),
            const SizedBox(height: 12,),
            textfield2(
              isTamil ? 'கைபேசி' : 'Mobile',
              '1234567890',
              mobileno,
              numpad: true
            ),
            if (mobilenoe.isNotEmpty)
            errortext(mobilenoe),
            const SizedBox(height: 12,),
            texty(
              isTamil ? 'இடம்' : 'Location'
            ),
            statedropdown(),
            if (selectedStatee.isNotEmpty)
            errortext(selectedStatee),
            const SizedBox(height: 12,),
            districtDropdown(),
            if (selectedDistricte.isNotEmpty)
            errortext(selectedDistricte),
            const SizedBox(height: 12,),
            talukDropdown(),
            if (selectedtaluke.isNotEmpty)
            errortext(selectedtaluke),
            CustomDropdownDropdown(
              title: 'Reason',
              selectedCustomDropdown: selectedreasonitems,
              customDropdowndropdownItems: reasonitems,
              onChanged: (newValue) {
                setState(() {
                  selectedreasonitems = newValue;
                });
              },
            ),
            if (reasonItemse.isNotEmpty)
            errortext(reasonItemse),
            const SizedBox(height: 12,),
            upload(),
            if (selectedImagee.isNotEmpty)
            errortext(selectedImagee),
            const SizedBox(height: 30),
            button(
              isTamil ? 'சமர்ப்பிக்க' : 'Submit',
              () {
                reportdriver();
              }
            ),
            const SizedBox(height: 30),
          ],
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
          // color: Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: kblackgrey
          )
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
          border: Border.all(
            color: kblackgrey
          ),
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
            fetchtaluk(newValue!, selectedState.toString());
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
          border: Border.all(
            color: kblackgrey
          ),
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