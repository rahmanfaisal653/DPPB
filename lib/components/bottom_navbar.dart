import 'package:flutter/material.dart';


class EduvoriaNavbar extends StatelessWidget {

  final int indexSekarang;
  final Function(int) ketikaDiTekan;

  const EduvoriaNavbar({
    super.key,
    required this.indexSekarang,
    required this.ketikaDiTekan,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: indexSekarang,
      onTap: ketikaDiTekan,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: "Trending"),
        BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Komunitas"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ],
    );
  }
}
