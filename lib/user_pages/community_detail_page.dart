import 'package:flutter/material.dart';


class CommunityDetailPage extends StatelessWidget {
  final String nama;
  final String deskripsi;
  final int anggota;
  final String image;

  const CommunityDetailPage({
    super.key,
    required this.nama,
    required this.deskripsi,
    required this.anggota,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nama),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                nama,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$anggota anggota',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'Deskripsi Komunitas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(deskripsi),
              const SizedBox(height: 24),
              const Text(
                'Aktivitas Terbaru',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.post_add),
                  title: const Text('Diskusi: Tips belajar Flutter untuk pemula'),
                  subtitle: const Text('3 jam yang lalu'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.post_add),
                  title:
                      const Text('Sharing: Pengalaman membuat proyek Laravel'),
                  subtitle: const Text('Kemarin'),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Gabung Komunitas'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
