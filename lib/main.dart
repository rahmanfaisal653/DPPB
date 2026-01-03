import 'package:flutter/material.dart';
import 'components/bottom_navbar.dart' as user_navbar;
import 'componentsAdmin/bottom_navbar.dart' as admin_navbar;
import 'user_pages/home_page.dart';
import 'user_pages/trending_page.dart';
import 'user_pages/community_page.dart';
import 'user_pages/profile_page.dart';
import 'admin_pages/dashboard.dart';
import 'admin_pages/kelola_user.dart';
import 'admin_pages/kelola_post.dart';
import 'admin_pages/kelola_community.dart';
import 'pages/login_page.dart';
import 'services/api_service.dart';
import 'models/user_model.dart';

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
            // Cek role user
            return FutureBuilder<User?>(
              future: ApiService.getCurrentUser(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                // Jika user ada
                if (userSnapshot.hasData && userSnapshot.data != null) {
                  User user = userSnapshot.data!;

                  // Cek role: kalau admin tampilkan AdminPage, kalau user tampilkan MainPage
                  if (user.role == 'admin') {
                    return const AdminPage();
                  } else {
                    return const MainPage();
                  }
                } else {
                  // Kalau ga ada user data, logout
                  return const LoginPage();
                }
              },
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

// ============================================
// HALAMAN UNTUK USER BIASA
// ============================================
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
      bottomNavigationBar: user_navbar.EduvoriaNavbar(
        indexSekarang: halamanSekarang,
        ketikaDiTekan: gantiHalaman,
      ),
    );
  }
}

// ============================================
// HALAMAN UNTUK ADMIN
// ============================================
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int halamanSekarang = 0;

  // Data dummy untuk post dan community
  List<String> postList = [
    "Selamat datang di platform admin!",
    "Pengumuman: Update fitur terbaru minggu depan.",
  ];

  List<Map<String, String>> communityList = [
    {
      "title": "Flutter Dev ID",
      "description": "Komunitas belajar Flutter bersama.",
      "members": "100",
    },
    {
      "title": "UI/UX Indonesia",
      "description": "Diskusi dan berbagi seputar design.",
      "members": "200",
    },
  ];

  void gantiHalaman(int index) {
    setState(() {
      halamanSekarang = index;
    });
  }

  void handleLogout() async {
    bool? yakin = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Logout'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );

    if (yakin == true) {
      await ApiService.logout();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: handleLogout),
        ],
      ),
      body: [
        // Dashboard
        DashboardPage(
          onUserSubmit: (u, p) {
            setState(() {
              halamanSekarang = 1;
            });
          },
          onPostSubmit: (post) {
            setState(() {
              postList.add(post);
              halamanSekarang = 2;
            });
          },
          onCommunitySubmit: (title, desc, members) {
            setState(() {
              communityList.add({
                "title": title,
                "description": desc,
                "members": members,
              });
              halamanSekarang = 3;
            });
          },
        ),
        KelolaUserPage(),
        KelolaPostPage(posts: postList),
        KelolaCommunityPage(communities: communityList),
      ][halamanSekarang],
      bottomNavigationBar: admin_navbar.EduvoriaNavbar(
        currentIndex: halamanSekarang,
        onTap: gantiHalaman,
      ),
    );
  }
}
