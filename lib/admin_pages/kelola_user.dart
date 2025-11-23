import 'package:flutter/material.dart';

class KelolaUserPage extends StatelessWidget {
  final List<Map<String, String>> users;

  const KelolaUserPage({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola User"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text("Username: ${users[index]["username"]}"),
              subtitle: Text("Password: ${users[index]["password"]}"),
            ),
          );
        },
      ),
    );
  }
}
