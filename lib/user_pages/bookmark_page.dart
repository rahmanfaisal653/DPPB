import 'package:flutter/material.dart';
import '../components/user_dropdown.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> bookmarks = [
      "Tips Belajar Efektif 🎯",
      "Cara membuat UI Flutter seperti Laravel",
      "Belajar Backend Laravel Dasar",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmark"),
        backgroundColor: Colors.teal,
        actions: const [
          UserDropdownButton(), // wajib
        ],
      ),

      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari Bookmark...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          // LIST BOOKMARK
          Expanded(
            child: ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.bookmark),
                  title: Text(bookmarks[index]),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
