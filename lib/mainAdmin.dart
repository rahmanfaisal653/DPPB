import 'package:flutter/material.dart';
import 'componentsAdmin/bottom_navbar.dart';
import 'admin_pages/dashboard.dart';
import 'admin_pages/kelola_user.dart';
import 'admin_pages/kelola_post.dart';
import 'admin_pages/kelola_community.dart';
import 'admin_pages/login_page.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

// Widget utama untuk cek login status
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        // Cek apakah user sudah login
        future: ApiService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Tampilkan loading saat cek login status
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Jika sudah login, tampilkan AdminApp
          // Jika belum, tampilkan LoginPage
          if (snapshot.data == true) {
            return const AdminApp();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

class AdminApp extends StatefulWidget {
  const AdminApp({super.key});

  @override
  State<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  int currentIndex = 0;

  // ========== DATA (DUMMY + REAL) ==========
  List<Map<String, String>> userList = [
    {"username": "admin01", "password": "admin123"},
    {"username": "user_baru", "password": "password123"},
  ];

  List<String> postList = [
    "Selamat datang di platform admin!",
    "Pengumuman: Update fitur terbaru minggu depan.",
  ];

  List<Map<String, String>> communityList = [
    {
      "title": "Flutter Dev ID",
      "description": "Komunitas belajar Flutter bersama.",
      "members": "100"
    },
    {
      "title": "UI/UX Indonesia",
      "description": "Diskusi dan berbagi seputar design.",
      "members": "200"
    },
  ];

  // Fungsi untuk logout
  void handleLogout() async {
    // Tampilkan dialog konfirmasi
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Panggil API logout
      await ApiService.logout();

      // Pindah ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            // Button Logout
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: handleLogout,
            ),
          ],
        ),
        body: [
          // ==========================
          // DASHBOARD
          // ==========================
          DashboardPage(
            onUserSubmit: (u, p) {
              setState(() {
                userList.add({
                  "username": u,
                  "password": p,
                });
                currentIndex = 1; // pindah ke halaman user
              });
            },

            onPostSubmit: (post) {
              setState(() {
                postList.add(post);
                currentIndex = 2; // pindah ke halaman post
              });
            },

            onCommunitySubmit: (title, desc, members) {
              setState(() {
                communityList.add({
                  "title": title,
                  "description": desc,
                  "members": members,
                });
                currentIndex = 3; // pindah ke halaman komunitas
              });
            },
          ),

          // ==========================
          // HALAMAN LAIN
          // ==========================
          KelolaUserPage(users: userList),
          KelolaPostPage(posts: postList),
          KelolaCommunityPage(communities: communityList),
        ][currentIndex],

        bottomNavigationBar: EduvoriaNavbar(
          currentIndex: currentIndex,
          onTap: (i) {
            setState(() => currentIndex = i);
          },
        ),
      ),
    );
  }
}
