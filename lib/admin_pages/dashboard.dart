import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  // Menerima "Alat" (Fungsi) dari Bos (main.dart)
  final Function(String, String) fungsiSimpanUser;
  final Function(String, String) fungsiSimpanPost;

  const DashboardPage({
    super.key, 
    required this.fungsiSimpanUser, 
    required this.fungsiSimpanPost
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Controller = Alat untuk mengambil teks yang diketik pengguna
  final controllerNama = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerJudul = TextEditingController();
  final controllerIsi = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Input Data")),
      body: ListView( // Pakai ListView biar bisa discroll
        padding: const EdgeInsets.all(20),
        children: [
          
          // --- BAGIAN 1: FORM USER ---
          const Text("Tambah User Baru", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          
          // Kotak input Nama
          TextField(
            controller: controllerNama,
            decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          
          // Kotak input Email
          TextField(
            controller: controllerEmail,
            decoration: const InputDecoration(labelText: "Email User", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),

          // Tombol Simpan User
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Background Biru
              foregroundColor: Colors.white, // Teks Putih
            ),
            onPressed: () {
              // Panggil fungsi dari Bos untuk simpan data
              widget.fungsiSimpanUser(controllerNama.text, controllerEmail.text);
              
              // Bersihkan kotak input
              controllerNama.clear();
              controllerEmail.clear();
              
              // Tampilkan pesan kecil di bawah
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Berhasil Disimpan!")));
            },
            child: const Text("SIMPAN USER"),
          ),

          const Divider(height: 50, thickness: 2), // Garis pemisah

          // --- BAGIAN 2: FORM POSTINGAN ---
          const Text("Buat Postingan Baru", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),

          TextField(
            controller: controllerJudul,
            decoration: const InputDecoration(labelText: "Judul Postingan", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: controllerIsi,
            maxLines: 3, // Bisa 3 baris
            decoration: const InputDecoration(labelText: "Isi Konten", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),

          // Tombol Publish
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Background Biru
              foregroundColor: Colors.white, // Teks Putih
            ),
            onPressed: () {
              // Panggil fungsi simpan post
              widget.fungsiSimpanPost(controllerJudul.text, controllerIsi.text);
              
              controllerJudul.clear();
              controllerIsi.clear();
              
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Postingan Terbit!")));
            },
            child: const Text("PUBLISH POSTINGAN"),
          ),
        ],
      ),
    );
  }
}