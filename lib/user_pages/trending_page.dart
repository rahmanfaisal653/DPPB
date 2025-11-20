import 'package:flutter/material.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Postingan Trending"),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text("Belum ada trending post"),
      ),
    );
  }
}
