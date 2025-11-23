import 'package:flutter/material.dart';

class KelolaPostPage extends StatelessWidget {
  final List<String> posts;

  const KelolaPostPage({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Post"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(posts[index]),
            ),
          );
        },
      ),
    );
  }
}
