import 'package:flutter/material.dart';
import '../components/user_dropdown.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi"),
        backgroundColor: Colors.blue,
        actions: const [
    UserDropdownButton(),  // selalu ada
  ],
      ),
      body: const Center(
        child: Text("Tidak ada notifikasi"),
      ),
    );
  }
}
