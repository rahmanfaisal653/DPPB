import 'package:flutter/material.dart';
import 'components/bottom_navbar.dart';
import 'user_pages/home_page.dart';
import 'user_pages/trending_page.dart';
import 'user_pages/community_page.dart';
import 'user_pages/profile_page.dart';
import 'user_pages/login_page.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: ApiService.isLoggedIn(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Cek apakah sudah login
          if (snapshot.hasData && snapshot.data == true) {
            return const MainPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
    return Scaffold(
      body: daftarHalaman[halamanSekarang],
      bottomNavigationBar: EduvoriaNavbar(
        indexSekarang: halamanSekarang,
        ketikaDiTekan: gantiHalaman,
      ),
    );
  }
}
