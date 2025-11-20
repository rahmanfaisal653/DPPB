import 'package:flutter/material.dart';
import '../components/user_dropdown.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context) {
    int posting = 12;
    int like = 450;
    int komentar = 128;
    int komunitas = 5;

    return Scaffold(
       appBar: AppBar(
        title: const Text("Statistik Saya"),
        backgroundColor: Colors.blue,
        actions: const [
          UserDropdownButton(), 
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aktivitas Saya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: 200,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 80,
                            width: 24,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Posting',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 160,
                            width: 24,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Like',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 110,
                            width: 24,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Komentar',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 60,
                            width: 24,
                            color: Colors.purple,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Komunitas',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                title: const Text('Total Posting'),
                trailing: Text('$posting'),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Total Like'),
                trailing: Text('$like'),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Total Komentar'),
                trailing: Text('$komentar'),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Komunitas Diikuti'),
                trailing: Text('$komunitas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
