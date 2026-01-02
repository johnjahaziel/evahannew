import 'package:evahan/navigation.dart';
import 'package:evahan/providers/languageprovider.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customappbar extends StatelessWidget implements PreferredSizeWidget {
  const Customappbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<Languageprovider>(context);
    final isTamil = langProvider.language == 'Tamil';
    
    return AppBar(
      backgroundColor: kred,
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
      title: GestureDetector(
        child: Text(
          isTamil ? 'E - வாகன் சேவை' : 'E - Vahan Sevai',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: [
        Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.only(right: 10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            border: Border.fromBorderSide(
              BorderSide(color: Colors.white, width: 1),
            ),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Navigation(initialIndex: 3,))
              );
            },
            icon: const Icon(
              Icons.person,
              color: Colors.white,
              size: 22,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }
}