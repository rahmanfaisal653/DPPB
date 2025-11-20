import 'package:flutter/material.dart';

class TrendingDetailPage extends StatelessWidget {
  final String judul;
  final String penulis;
  final int like;
  final int komentar;
  final String image;
  final String caption;

  const TrendingDetailPage({
    super.key,
    required this.judul,
    required this.penulis,
    required this.like,
    required this.komentar,
    required this.image,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Postingan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16)),
              child: Image.network(
                image,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'oleh $penulis',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.favorite, size: 18),
                      const SizedBox(width: 4),
                      Text('$like'),
                      const SizedBox(width: 16),
                      const Icon(Icons.mode_comment_outlined, size: 18),
                      const SizedBox(width: 4),
                      Text('$komentar'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Isi Postingan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    caption,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
