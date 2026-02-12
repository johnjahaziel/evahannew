import 'package:evahan/size_config.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Dateofbirthfield extends StatefulWidget {
  final String title;
  final TextEditingController datecontroller;
  final bool padding;
  final bool star;
  final bool readOnly;

  const Dateofbirthfield({
    super.key,
    required this.title,
    required this.datecontroller,
    this.padding = false,
    this.star = true,
    this.readOnly = false,
    });

  @override
  State<Dateofbirthfield> createState() => _DateofbirthfieldState();
}

class _DateofbirthfieldState extends State<Dateofbirthfield> {

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kred,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kred,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String displayDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      setState(() {
        widget.datecontroller.text = displayDate;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Padding(
      padding: widget.padding == true ? EdgeInsets.symmetric(horizontal: SizeConfig.w(20)) : EdgeInsets.zero,
      child: Opacity(
        opacity: widget.readOnly ? 0.6 : 1,
        child: IgnorePointer(
          ignoring: widget.readOnly,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xff919EAB)
                    ),
                  ),
                  // if(widget.star)
                  // Text(
                  //   '*',
                  //   style: TextStyle(
                  //     fontFamily: 'Poppins',
                  //     color: kred
                  //   ),
                  // ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TextField(
                  controller: widget.datecontroller,
                  keyboardType: TextInputType.datetime,
                  maxLines: 1,
                  inputFormatters: [
                    DateInputFormatter()
                  ],
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: kblackgrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: kblackgrey),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: _selectDate,
                    ),
                    hintText: "dd-MM-yyyy",
                    hintStyle: TextStyle(
                      fontSize: fs10
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length == 10) {
                      try {
                        DateTime dob = DateFormat("dd-MM-yyyy").parseStrict(value);
                        if (dob.isAfter(DateTime.now())) {
                          Fluttertoast.showToast(msg: "Date cannot be in the future");
                          widget.datecontroller.clear();
                        }
                      } catch (e) {
                        Fluttertoast.showToast(msg: "Invalid date format or value");
                        widget.datecontroller.clear();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Followupdate extends StatefulWidget {
  final String title;
  final TextEditingController datecontroller;
  final bool padding;
  final bool star;
  final bool readOnly;

  const Followupdate({
    super.key,
    required this.title,
    required this.datecontroller,
    this.padding = false,
    this.star = true,
    this.readOnly = false,
    });

  @override
  State<Followupdate> createState() => _FollowupdateState();
}

class _FollowupdateState extends State<Followupdate> {

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 5)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kred,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kred,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        widget.datecontroller.text = formattedDate;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding == true ? EdgeInsets.symmetric(horizontal: SizeConfig.w(20)) : EdgeInsets.zero,
      child: Opacity(
        opacity: widget.readOnly ? 0.6 : 1,
        child: IgnorePointer(
          ignoring: widget.readOnly,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xff919EAB)
                    ),
                  ),
                  if(widget.star)
                  Text(
                    '*',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: kred
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TextField(
                  controller: widget.datecontroller,
                  keyboardType: TextInputType.datetime,
                  maxLines: 1,
                  inputFormatters: [
                    DateInputFormatter()
                  ],
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: kblackgrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: kblackgrey),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: _selectDate,
                    ),
                    hintText: "yyyy-MM-dd",
                    hintStyle: TextStyle(
                      fontSize: fs10
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length == 10) {
                      try {
                        DateTime dob = DateFormat("yyyy-MM-dd").parseStrict(value);
          
                        if (dob.isAfter(DateTime.now())) {
                          Fluttertoast.showToast(msg: "Date cannot be in the future");
                          widget.datecontroller.clear();
                        }
                      } catch (e) {
                        Fluttertoast.showToast(msg: "Invalid date format or value");
                        widget.datecontroller.clear();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String input = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (input.length > 8) return oldValue;

    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < input.length; i++) {
      buffer.write(input[i]);

      // dd-MM-yyyy
      if (i == 1 || i == 3) buffer.write('-');
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}