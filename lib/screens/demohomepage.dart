import 'package:evahan/login.dart';
import 'package:evahan/providers/userprovider.dart';
import 'package:evahan/screens/homescreen.dart';
import 'package:evahan/utility/authservice.dart';
import 'package:evahan/utility/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  static const String _demoUsername = '12345678';
  static const String _demoPassword = '12345678';

  @override
  void initState() {
    super.initState();
    _ensureDemoSession();
  }

  Future<void> _ensureDemoSession() async {
    final bool hasValidSession = await Authservice.hasValidDemoSession();

    if (hasValidSession) {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      Provider.of<Userprovider>(context, listen: false).setUserId(
        prefs.getString('userid') ?? '',
        prefs.getString('roleid') ?? '',
      );
      return;
    }

    if (!mounted) return;
    try {
      await Authservice.login(
        username: _demoUsername,
        password: _demoPassword,
        userprovider: Provider.of<Userprovider>(context, listen: false),
        isDemo: true,
      );
    } catch (e) {
      debugPrint('Demo login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Customappbar(
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
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              icon: const Icon(Icons.person, color: Colors.white, size: 22),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
      body: const Homescreen(),
    );
  }
}
