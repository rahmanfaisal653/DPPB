import 'package:flutter/material.dart';
import '../user_pages/bookmark_page.dart';
import '../user_pages/notification_page.dart';
import '../user_pages/settings_page.dart';

class UserDropdownButton extends StatelessWidget {
  const UserDropdownButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person, size: 28),
      onPressed: () async {
        final result = await showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(1000, 80, 16, 0),
          items: const [
            PopupMenuItem(value: "bookmark", child: Text("Bookmark")),
            PopupMenuItem(value: "notification", child: Text("Notifikasi")),
            PopupMenuItem(value: "settings", child: Text("Settings")),
          ],
        );

        if (result == "bookmark") {
          Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BookmarkPage()));
        } else if (result == "notification") {
          Navigator.push(context,
            MaterialPageRoute(builder: (_) => const NotificationsPage()));
        } else if (result == "settings") {
          Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SettingsPage()));
        }
      },
    );
  }
}
