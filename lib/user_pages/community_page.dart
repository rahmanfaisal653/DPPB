import 'package:flutter/material.dart';
import 'community_detail_page.dart';
import 'create_community_page.dart';
import '../components/user_dropdown.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List komunitas = [
    {
      'nama': 'Komunitas Flutter Pemula',
      'deskripsi': 'Belajar Flutter dari dasar.',
      'anggota': 240,
    },
    {
      'nama': 'Backend Laravel',
      'deskripsi': 'Diskusi API dan autentikasi.',
      'anggota': 180,
    },
    {
      'nama': 'Mahasiswa Produktif',
      'deskripsi': 'Tips belajar dan karier.',
      'anggota': 320,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
            child: ListTile(
              title: Text(item['nama']),
              subtitle: Text(item['deskripsi']),
              trailing: Text("${item['anggota']} org"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CommunityDetailPage(
                      nama: item['nama'],
                      deskripsi: item['deskripsi'],
                      anggota: item['anggota'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, size: 28),
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateCommunityPage(),
            ),
          );

          if (result != null) {
            setState(() {
              komunitas.add({
                'nama': result['nama'],
                'deskripsi': result['deskripsi'],
                'anggota': 0, 
              });
            });
          }
        },
      ),
    );
  }
}
