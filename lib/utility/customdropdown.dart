
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';

class CustomDropdownDropdown extends StatelessWidget {
  final String title;
  final String? selectedCustomDropdown;
  final List<Map<String, String>> customDropdowndropdownItems;
  final Function(String?) onChanged;

  const CustomDropdownDropdown({
    super.key,
    required this.title,
    required this.selectedCustomDropdown,
    required this.customDropdowndropdownItems,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xff919EAB)
                ),
              ),
              // Text(
              //   '*',
              //   style: TextStyle(
              //     fontFamily: 'Poppins',
              //     color: kred
              //   ),
              // ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25,top: 10),
          child: Container(
            height: 55,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: kblackgrey
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCustomDropdown,
                hint: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    title,
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
                items: customDropdowndropdownItems.map((item) {
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
                onChanged: onChanged,
              ),
            ),
          ),
        )
      ],
    );
  }
}