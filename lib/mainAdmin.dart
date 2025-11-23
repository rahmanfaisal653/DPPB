import 'package:flutter/material.dart';
import 'componentsAdmin/bottom_navbar.dart';
import 'admin_pages/dashboard.dart';
import 'admin_pages/kelola_user.dart';
import 'admin_pages/kelola_post.dart';

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

  List<Map<String, String>> userList = [];
  List<String> postList = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: [
          DashboardPage(
            onUserSubmit: (u, p) {
              setState(() {
                userList.add({"username": u, "password": p});
                currentIndex = 1;
              });
            },
            onPostSubmit: (post) {
              setState(() {
                postList.add(post);
                currentIndex = 2;
              });
            },
          ),
          KelolaUserPage(users: userList),
          KelolaPostPage(posts: postList),
        ][currentIndex],
        bottomNavigationBar: EduvoriaNavbar(
          currentIndex: currentIndex,
          onTap: (i) {
            setState(() {
              currentIndex = i;
            });
          },
        ),
      ),
    );
  }
}
