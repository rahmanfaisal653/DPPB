import 'package:flutter/material.dart';
import '../components/user_dropdown.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blue,
        actions: const [
    UserDropdownButton(),  // selalu ada
  ],
      ),
      body: const Center(
        child: Text("Halaman Settings"),
      ),
    );
  }
}
