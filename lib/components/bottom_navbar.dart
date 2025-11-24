import 'package:flutter/material.dart';


class EduvoriaNavbar extends StatelessWidget {
  // Variabel untuk menyimpan halaman yang sedang aktif (0, 1, 2, atau 3)
  final int indexSekarang;

  // Variabel untuk menyimpan fungsi yang akan dipanggil saat item di-tap
  final Function(int) ketikaDiTekan;

  // Constructor (pembuat widget)
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
