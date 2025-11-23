import 'package:flutter/material.dart';
import '../user_pages/bookmark_page.dart';
import '../user_pages/notification_page.dart';
import '../user_pages/settings_page.dart';
import '../user_pages/statistic_page.dart';

class UserDropdownButton extends StatelessWidget {
  const UserDropdownButton({super.key});

  void bukaHalaman(BuildContext context, String pilihan) {
    if (pilihan == "bookmark") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return BookmarkPage();
          },
        ),
      );
    } else if (pilihan == "notification") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return NotificationPage();
          },
        ),
      );
    } else if (pilihan == "statistic") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return StatisticPage();
          },
        ),
      );
    } else if (pilihan == "settings") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SettingsPage();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.person, size: 28),
      onPressed: () {
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(1000, 80, 16, 0),
          items: [
            PopupMenuItem(value: "bookmark", child: Text("Bookmark")),
            PopupMenuItem(value: "notification", child: Text("Notifikasi")),
            PopupMenuItem(value: "statistic", child: Text("Statistik")),
            PopupMenuItem(value: "settings", child: Text("Settings")),
          ],
        ).then((pilihan) {
          if (pilihan != null) {
            bukaHalaman(context, pilihan);
          }
        });
      },
    );
  }
}
