import 'package:evahan/custombottomnavigation.dart';
import 'package:evahan/providers/userprovider.dart';
import 'package:evahan/screens/homescreen.dart';
import 'package:evahan/screens/newsletter.dart';
import 'package:evahan/screens/profile.dart';
import 'package:evahan/screens/reportuser.dart';
import 'package:evahan/screens/reportview.dart';
import 'package:evahan/size_config.dart';
import 'package:evahan/utility/customappbar.dart';
import 'package:evahan/utility/customdrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Navigation extends StatefulWidget {
  final int initialIndex;
  const Navigation({
    super.key,
    this.initialIndex = 0
  });

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late PageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: currentIndex);
  }

  void _onNavTap(int index) {
    setState(() {
      currentIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userid = Provider.of<Userprovider>(context).userId;
    final userrole = Provider.of<Userprovider>(context,listen: false).roleId;
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: Customappbar(),
        drawer: Customdrawer(),
        drawerEnableOpenDragGesture: false,
        body: PageView(
          controller: pageController,
          onPageChanged: _onNavTap,
          children: [
            Homescreen(),
            Newsletter(),
            if(userrole == '1')
            Reportdriver(),
            if(userrole != '1')
            Reportuser(),
            Profile(userid: userid)
          ],
        ),
        bottomNavigationBar: Custombottomnavigation(
          selectedIndex: currentIndex,
          onNavTap: _onNavTap,
        ),
      ),
    );
  }
}