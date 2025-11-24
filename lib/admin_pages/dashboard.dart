import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  final Function(String, String) onUserSubmit;
  final Function(String) onPostSubmit;
  // Callback baru untuk komunitas (Judul, Deskripsi, Anggota)
  final Function(String, String, String) onCommunitySubmit; 

  const DashboardPage({
    super.key,
    required this.onUserSubmit,
    required this.onPostSubmit,
    required this.onCommunitySubmit, // Wajib diisi
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // --- Controller untuk Input User ---
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  
  // --- Controller untuk Input Posting ---
  final postController = TextEditingController();
  
  // --- Controller BARU untuk Input Komunitas ---
  final communityTitleController = TextEditingController();
  final communityDescController = TextEditingController();
  final communityMembersController = TextEditingController();

  @override
  void dispose() {
    // Pastikan semua controller dibersihkan saat widget dihapus
    usernameController.dispose();
    passwordController.dispose();
    postController.dispose();
    communityTitleController.dispose();
    communityDescController.dispose();
    communityMembersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView( // Menggunakan SingleChildScrollView agar tidak overflow
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========================
            // Bagian 1: INPUT USER
            // ========================
            const Center(child: Text("Input User", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const Divider(),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.onUserSubmit(
                    usernameController.text,
                    passwordController.text,
                  );
                  // Bersihkan form setelah submit
                  usernameController.clear();
                  passwordController.clear();
                },
                icon: const Icon(Icons.person_add),
                label: const Text("Kirim Data User"),
              ),
            ),

            const SizedBox(height: 30),
            
            // ========================
            // Bagian 2: INPUT POSTING
            // ========================
            const Center(child: Text("Input Posting", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const Divider(),
            TextField(
              controller: postController,
              decoration: const InputDecoration(labelText: "Isi Postingan"),
              maxLines: 4,
            ),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.onPostSubmit(postController.text);
                  postController.clear();
                },
                icon: const Icon(Icons.send),
                label: const Text("Kirim Isi Post"),
              ),
            ),
            
            const SizedBox(height: 30),

            // ========================
            // Bagian 3: INPUT KOMUNITAS (BARU)
            // ========================
            const Center(child: Text("Input Komunitas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const Divider(),
            TextField(
              controller: communityTitleController,
              decoration: const InputDecoration(
                labelText: "Judul Komunitas",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: communityDescController,
              decoration: const InputDecoration(
                labelText: "Deskripsi Komunitas",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: communityMembersController,
              decoration: const InputDecoration(
                labelText: "Anggota Awal",
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.onCommunitySubmit(
                    communityTitleController.text,
                    communityDescController.text,
                    communityMembersController.text,
                  );
                  // Bersihkan form setelah submit
                  communityTitleController.clear();
                  communityDescController.clear();
                  communityMembersController.clear();
                },
                icon: const Icon(Icons.group_add),
                label: const Text("Buat Komunitas Baru"),
                style: ElevatedButton.styleFrom(
                  //style
                ),
              ),
            ),
            const SizedBox(height: 30), // Tambahkan ruang di bagian bawah
          ],
        ),
      ),
    );
  }
}