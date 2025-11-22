import 'package:flutter/material.dart';

class CommunityDetailPage extends StatefulWidget {
  final String nama;
  final String deskripsi;
  final int anggota;

  const CommunityDetailPage({
    super.key,
    required this.nama,
    required this.deskripsi,
    required this.anggota,
  });

  @override
  State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  late int jumlahAnggota;

  @override
  void initState() {
    super.initState();
    jumlahAnggota = widget.anggota;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nama),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.nama,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Jumlah anggota: $jumlahAnggota'),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi Komunitas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(widget.deskripsi),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    jumlahAnggota++;
                  });
                },
                child: const Text('Gabung Komunitas'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
