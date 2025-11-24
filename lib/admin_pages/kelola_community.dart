import 'package:flutter/material.dart';

class KelolaCommunityPage extends StatelessWidget {
  final List<Map<String, String>> communities;

  const KelolaCommunityPage({super.key, required this.communities});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Komunitas"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: communities.length,
        itemBuilder: (context, index) {
          final c = communities[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(c["title"] ?? ""),
              subtitle: Text("${c["description"]}\nAnggota: ${c["members"]}"),
            ),
          );
        },
      ),
    );
  }
}
