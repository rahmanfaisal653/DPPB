import 'package:flutter/material.dart';
import '../components/user_dropdown.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final List<Map<String, String>> userPosts = [
    {
      "title": "Postingan saya tentang Flutter 🎨",
      "image":
          "https://images.unsplash.com/photo-1517433456452-f9633a875f6f"
    },
    {
      "title": "Belajar desain UI modern ✨",
      "image":
          "https://images.unsplash.com/photo-1519389950473-47ba0277781c"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
        backgroundColor: Colors.blue,
        actions: const [
          UserDropdownButton(),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ============================
            //  FOTO PROFIL + NAMA + BIO
            // ============================
            const CircleAvatar(
              radius: 55,
              backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
            ),

            const SizedBox(height: 15),

            const Text(
              "Arthur Pendragon",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const Text(
              "@arthur",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Pembelajar yang suka berbagi dan bertumbuh bersama komunitas Eduvoria. 🔥",
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // ============================
            //       STATISTIK MEDSOS
            // ============================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                ProfileStat(label: "Posting", value: "2"),
                ProfileStat(label: "Followers", value: "150"),
                ProfileStat(label: "Following", value: "89"),
                ProfileStat(label: "Komunitas", value: "5"),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 1),

            // ============================
            //     POSTINGAN USER
            // ============================
            const SizedBox(height: 15),
            const Text(
              "Postingan Saya",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: userPosts.length,
              itemBuilder: (context, index) {
                final post = userPosts[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FOTO POST
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          post["image"]!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // JUDUL
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          post["title"]!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // LIKE + KOMEN
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: const [
                              Icon(Icons.favorite_border, color: Colors.red),
                              SizedBox(width: 6),
                              Text("Like"),
                            ]),
                            Row(children: const [
                              Icon(Icons.comment_outlined, color: Colors.grey),
                              SizedBox(width: 6),
                              Text("Komentar"),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

// ===== KOMPOEN STAT =====
class ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const ProfileStat({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
