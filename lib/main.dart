import 'package:flutter/material.dart';
import 'components/bottom_navbar.dart';
import 'user_pages/home_page.dart';
import 'user_pages/trending_page.dart';
import 'user_pages/community_page.dart';
import 'user_pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  final pages = [
    HomePage(),
    const TrendingPage(),
    const CommunityPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: EduvoriaNavbar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
