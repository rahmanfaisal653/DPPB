import 'package:flutter/material.dart';
import 'componentsAdmin/bottom_navbar.dart';
import 'admin_pages/dashboard.dart';
import 'admin_pages/kelola_user.dart';
import 'admin_pages/kelola_post.dart';
import 'admin_pages/kelola_community.dart';

void main() {
  runApp(const AdminApp());
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
