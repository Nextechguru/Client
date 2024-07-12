// ignore_for_file: depend_on_referenced_packages, unnecessary_import

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roshan_dastak_client/Log_in_out_pages/splash_screen.dart';
import 'package:roshan_dastak_client/Main_Pages/dashboard_page.dart';
import 'package:roshan_dastak_client/Main_Pages/home_page.dart';
import 'package:roshan_dastak_client/Main_Pages/User%20Profile/user_profile.dart';

import 'services_pages/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(GetMaterialApp(
    title: 'Roshan Dastard',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      useMaterial3: true,
    ),
    home: const MyApp(), // Your main app widget
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roshan Dastard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Creating Variables that will used in code further
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;
  final items = <Widget>[
    const Icon(
      Icons.home,
      size: 30,
      color: Colors.white,
    ),
    const Icon(Icons.dashboard, size: 30, color: Colors.white),
    const Icon(Icons.person, size: 30, color: Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: index,
        children: [
          MyHomePage(user: widget.user), // Pass widget.user to MyHomePage
          DashboardPage(user: widget.user),
          Profile(user: widget.user),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: Colors.green,
          height: 60,
          key: navigationKey,
          index: index,
          items: items,
          onTap: (index) => setState(() {
                this.index = index;
              })),
    );
  }
}
