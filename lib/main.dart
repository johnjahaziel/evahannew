import 'package:evahan/navigation.dart';
import 'package:evahan/providers/languageprovider.dart';
import 'package:evahan/providers/numberprovider.dart';
import 'package:evahan/providers/userprovider.dart';
import 'package:evahan/screens/demohomepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userid') ?? '';
  final roleId = prefs.getString('roleid') ?? '';
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final bool isDemoSession = prefs.getBool('is_demo_session') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Userprovider()..setUserId(userId, roleId),
        ),
        ChangeNotifierProvider(create: (_) => Languageprovider()),
        ChangeNotifierProvider(create: (_) => Numberprovider()),
      ],
      child: MyApp(
        isAuthenticated: isLoggedIn && !isDemoSession,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  const MyApp({super.key, required this.isAuthenticated});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Android
        statusBarBrightness: Brightness.dark, // iOS -> white icons
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isAuthenticated ? const Navigation() : const DemoHomePage(),
        theme: ThemeData(fontFamily: 'Poppins'),
      ),
    );
  }
}
