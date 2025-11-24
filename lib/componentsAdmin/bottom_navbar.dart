import 'package:flutter/material.dart';

class EduvoriaNavbar extends StatelessWidget {
  final int currentIndex; // menentukan tab mana yang sedang aktif (0, 1, atau 2).
  final Function(int) onTap; // dipanggil ketika user men-tap item navbar

  const EduvoriaNavbar({
    super.key,
    required this.currentIndex, 
    required this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, //tab mana yang sedang aktif 
      onTap: onTap,
      selectedItemColor: Colors.indigo,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "User",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: "Postingan",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups),
          label: "Komunitas",
        ),
      ],
    );
  }
}
