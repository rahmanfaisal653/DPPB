import 'package:flutter/material.dart';

class EduvoriaNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const EduvoriaNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
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
      ],
    );
  }
}
