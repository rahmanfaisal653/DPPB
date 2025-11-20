import 'package:flutter/material.dart';
import 'trending_detail_page.dart';
import '../components/user_dropdown.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    List data = [
      {
        'judul': 'Cara belajar cepat tanpa overthinking 🎯',
        'penulis': 'Arthur',
        'like': 320,
        'komentar': 45,
        'image':
            'https://images.pexels.com/photos/256541/pexels-photo-256541.jpeg',
        'caption':
            'Belajar cepat tanpa overthinking dapat dimulai dengan fokus pada satu tugas dalam satu waktu. '
                'Kurangi distraksi, gunakan teknik Pomodoro, dan jangan memaksakan otak bekerja berlebihan.',
      },
      {
        'judul': 'Belajar Flutter itu seru 🚀',
        'penulis': 'Diana',
        'like': 280,
        'komentar': 38,
        'image':
            'https://images.pexels.com/photos/2115217/pexels-photo-2115217.jpeg',
        'caption':
            'Flutter memungkinkan pengembangan aplikasi mobile yang cepat dan efisien. '
                'Dengan satu basis kode, kita bisa membuat aplikasi untuk Android dan iOS sekaligus.',
      },
      {
        'judul': 'Tips produktif untuk mahasiswa',
        'penulis': 'Lancelot',
        'like': 210,
        'komentar': 27,
        'image':
            'https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg',
        'caption':
            'Mahasiswa dapat meningkatkan produktivitas dengan membuat jadwal belajar, '
                'mengatur prioritas tugas, dan mengurangi penggunaan gadget saat belajar.',
      },
    ];

    return Scaffold(
       appBar: AppBar(
        title: const Text("Trending saya"),
        backgroundColor: Colors.blue,
        actions: const [
        UserDropdownButton(),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        itemBuilder: (context, index) {
          var post = data[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                  child: Image.network(
                    post['image'],
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['judul'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text('oleh ${post['penulis']}'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.favorite_border, size: 18),
                          const SizedBox(width: 4),
                          Text('${post['like']}'),
                          const SizedBox(width: 16),
                          const Icon(Icons.mode_comment_outlined, size: 18),
                          const SizedBox(width: 4),
                          Text('${post['komentar']}'),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TrendingDetailPage(
                                    judul: post['judul'],
                                    penulis: post['penulis'],
                                    like: post['like'],
                                    komentar: post['komentar'],
                                    image: post['image'],
                                    caption: post['caption'],
                                  ),
                                ),
                              );
                            },
                            child: const Text('Detail'),
                          )
                        ],
                      )
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
