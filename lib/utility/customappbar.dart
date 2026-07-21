import 'package:evahan/providers/languageprovider.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customappbar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;

  const Customappbar({super.key, this.actions});

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
      actions: actions,
    );
  }
}