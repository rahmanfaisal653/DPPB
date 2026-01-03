import 'package:flutter/material.dart';
import '../user_pages/bookmark_page.dart';
import '../user_pages/notification_page.dart';
import '../user_pages/settings_page.dart';
import '../user_pages/statistic_page.dart';
import '../pages/login_page.dart';
import '../services/api_service.dart';

class UserDropdownButton extends StatelessWidget {
  const UserDropdownButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.person),
      onPressed: () {
        // Tampilkan menu popup
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(1000, 80, 16, 0),
          items: [
            PopupMenuItem(value: "bookmark", child: Text("Bookmark")),
            PopupMenuItem(value: "notification", child: Text("Notifikasi")),
            PopupMenuItem(value: "statistic", child: Text("Statistik")),
            PopupMenuItem(value: "settings", child: Text("Settings")),
            PopupMenuItem(
              value: "logout",
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text("Logout", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ).then((hasilPilihan) async {
          if (!context.mounted) return;

          if (hasilPilihan != null) {
            if (hasilPilihan == "bookmark") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkPage()),
              );
            } else if (hasilPilihan == "notification") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            } else if (hasilPilihan == "statistic") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatisticPage()),
              );
            } else if (hasilPilihan == "settings") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            } else if (hasilPilihan == "logout") {
              // Tampilkan dialog konfirmasi logout
              bool? confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Apakah Anda yakin ingin logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: Text('Logout'),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                // Lakukan logout
                await ApiService.logout();

                // Navigasi ke halaman login dan hapus semua route sebelumnya
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                }
              }
            }
          }
        });
      },
    );
  }
}
