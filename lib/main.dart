import 'package:evahan/login.dart';
import 'package:evahan/navigation.dart';
import 'package:evahan/providers/languageprovider.dart';
import 'package:evahan/providers/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userid') ?? '';
  final roleId = prefs.getString('roleid') ?? '';
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Userprovider()..setUserId(userId, roleId),
        ),
        ChangeNotifierProvider(
          create: (_) => Languageprovider()
        )
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}
class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({
    super.key,
    required this.isLoggedIn
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isLoggedIn ? const Navigation() : const Login(),
        theme: ThemeData(
          fontFamily: 'Poppins'
        ),
      ),
    );
  }
}