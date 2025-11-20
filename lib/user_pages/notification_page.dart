import 'package:flutter/material.dart';
import '../components/user_dropdown.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    List notif = [
      {
        'isi': 'Arthur menyukai postingan Anda',
        'image':
            'https://images.pexels.com/photos/712513/pexels-photo-712513.jpeg',
      },
      {
        'isi': 'Diana mulai mengikuti Anda',
        'image':
            'https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg',
      },
      {
        'isi': 'Komentar baru pada postingan Anda',
        'image':
            'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
      },
    ];

    return Scaffold(
       appBar: AppBar(
        title: const Text("Notifikasi saya"),
        backgroundColor: Colors.blue,
        actions: const [
          UserDropdownButton(),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notif.length,
        itemBuilder: (context, index) {
          var item = notif[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(item['image']),
              ),
              title: Text(item['isi']),
            ),
          );
        },
      ),
    );
  }
}
