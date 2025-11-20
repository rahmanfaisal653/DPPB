import 'package:flutter/material.dart';
import '../components/user_dropdown.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Map<String, String>> posts = [
    {
      "title": "Cara belajar cepat tanpa overthinking 🎯",
      "image":
          "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f"
    },
    {
      "title": "Belajar Flutter itu seru banget 🚀",
      "image":
          "https://images.unsplash.com/photo-1517433456452-f9633a875f6f"
    },
    {
      "title": "Laravel adalah teman terbaik backend dev 🧠",
      "image":
          "https://images.unsplash.com/photo-1519389950473-47ba0277781c"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eduvoria — Home"),
        backgroundColor: Colors.blue,
        actions: const [
          UserDropdownButton(), // ❤️ Dipanggil di semua page
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final data = posts[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GAMBAR POST
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12)),
                  child: Image.network(
                    data["image"]!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // JUDUL
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    data["title"]!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // LIKE & COMMENT
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.favorite_border, color: Colors.red),
                          SizedBox(width: 6),
                          Text("Like"),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.comment_outlined, color: Colors.grey),
                          SizedBox(width: 6),
                          Text("Komentar"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
