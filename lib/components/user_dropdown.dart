import 'package:flutter/material.dart';
import '../user_pages/bookmark_page.dart';
import '../user_pages/notification_page.dart';
import '../user_pages/settings_page.dart';
import '../user_pages/statistic_page.dart';


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
          ],
        ).then((hasilPilihan) {

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
            }
          }
        });
      },
    );
  }
}
