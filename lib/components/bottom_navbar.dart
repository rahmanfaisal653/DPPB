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
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: "Trending",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups),
          label: "Komunitas",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profil",
        ),
      ],
    );
  }
}
