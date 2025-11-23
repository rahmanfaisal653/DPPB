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
  int halamanSekarang = 0;

  List<Widget> daftarHalaman = [
    HomePage(),
    TrendingPage(),
    CommunityPage(),
    ProfilePage(),
  ];

  void gantiHalaman(int index) {
    setState(() {
      halamanSekarang = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: daftarHalaman[halamanSekarang],
        bottomNavigationBar: EduvoriaNavbar(
          indexSekarang: halamanSekarang,
          ketikaDiTekan: gantiHalaman,
        ),
      ),
    );
  }
}
