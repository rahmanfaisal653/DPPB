import 'package:flutter/material.dart';
import 'community_detail_page.dart';
import '../components/user_dropdown.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    List komunitas = [
      {
        'nama': 'Komunitas Flutter Pemula',
        'deskripsi': 'Belajar Flutter dari dasar.',
        'anggota': 240,
        'image':
            'https://images.pexels.com/photos/1181671/pexels-photo-1181671.jpeg',
      },
      {
        'nama': 'Backend Laravel',
        'deskripsi': 'Diskusi API dan autentikasi.',
        'anggota': 180,
        'image':
            'https://images.pexels.com/photos/160107/pexels-photo-160107.jpeg',
      },
      {
        'nama': 'Mahasiswa Produktif',
        'deskripsi': 'Tips belajar dan karier.',
        'anggota': 320,
        'image':
            'https://images.pexels.com/photos/1181579/pexels-photo-1181579.jpeg',
      },
    ];

    return Scaffold(
       appBar: AppBar(
        title: const Text("Komunitas saya"),
        backgroundColor: Colors.blue,
        actions: const [
          UserDropdownButton(),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: komunitas.length,
        itemBuilder: (context, index) {
          var item = komunitas[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundImage: NetworkImage(item['image']),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['nama'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['deskripsi'],
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('${item['anggota']} anggota'),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommunityDetailPage(
                                nama: item['nama'],
                                deskripsi: item['deskripsi'],
                                anggota: item['anggota'],
                                image: item['image'],
                              ),
                            ),
                          );
                        },
                        child: const Text('Lihat'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
