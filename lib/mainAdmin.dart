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

  // ========== DATA ==========
  List<Map<String, String>> userList = [];
  List<String> postList = [];
  List<Map<String, String>> communityList = []; 

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
                currentIndex = 1;
              });
            },

            onPostSubmit: (post) {
              setState(() {
                postList.add(post);
                currentIndex = 2;
              });
            },

            onCommunitySubmit: (title, desc, members) {
              setState(() {
                communityList.add({
                  "title": title,
                  "description": desc,
                  "members": members,
                });
                currentIndex = 3; // pindah ke halaman community
              });
            },
          ),

          // ==========================
          // KELAS LAIN
          // ==========================
          KelolaUserPage(users: userList),
          KelolaPostPage(posts: postList),
          KelolaCommunityPage(communities: communityList),
        ][currentIndex],

        bottomNavigationBar: EduvoriaNavbar(
          currentIndex: currentIndex,
          onTap: (i) => setState(() => currentIndex = i),
        ),
      ),
    );
  }
}
