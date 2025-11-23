import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  final Function(String, String) onUserSubmit;
  final Function(String) onPostSubmit;

  const DashboardPage({
    super.key,
    required this.onUserSubmit,
    required this.onPostSubmit,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Admin"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Input User", style: TextStyle(fontSize: 18)),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                widget.onUserSubmit(
                  usernameController.text,
                  passwordController.text,
                );
              },
              child: const Text("Kirim ke Kelola User"),
            ),

            const SizedBox(height: 30),

            const Text("Input Posting", style: TextStyle(fontSize: 18)),
            TextField(
              controller: postController,
              decoration: const InputDecoration(labelText: "Isi Postingan"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                widget.onPostSubmit(postController.text);
              },
              child: const Text("Kirim ke Kelola Post"),
            ),
          ],
        ),
      ),
    );
  }
}
