import 'package:flutter/material.dart';
import '../components/user_dropdown.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Komunitas"),
        backgroundColor: Colors.blue,
        actions: const [
    UserDropdownButton(),  // selalu ada
  ],
      ),
      body: const Center(
        child: Text("Daftar Komunitas"),
      ),
    );
  }
}
