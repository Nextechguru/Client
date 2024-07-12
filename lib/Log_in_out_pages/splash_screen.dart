import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roshan_dastak_client/Log_in_out_pages/Login_Page.dart';
import 'package:roshan_dastak_client/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      getValue_Prefs();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo2.png'),
              radius: 70,
              backgroundColor: Colors.black,
            ),
            Text(
              '\nBank of the Future',
              style: TextStyle(fontSize: 17, color: Colors.white),
            )
          ],
        ),
      ),
    ));
  }

  getValue_Prefs() async {
    var pref = await SharedPreferences.getInstance();
    var getId = pref.getString('CNIC');

    print(getId);
    if (getId != 'LOG OUT' && getId != null) {
      Get.off(() => MainScreen(user: getId),
          transition: Transition.topLevel,
          duration: const Duration(seconds: 2));
    } else {
      Get.off(() => const LoginPage(),
          transition: Transition.topLevel,
          duration: const Duration(seconds: 2));
    }
  }
}
