import 'package:flutter/material.dart';
import '../components/user_dropdown.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // List untuk menyimpan postingan user
  List<String> postinganSaya = [
    "Postingan saya tentang Flutter 🎨",
    "Belajar desain UI modern ✨",
  ];

  // Controller untuk TextField
  TextEditingController kontrolerPostingan = TextEditingController();

  // Fungsi untuk menambah postingan baru
  void tambahPostingan() {
    if (kontrolerPostingan.text.isNotEmpty) {
      setState(() {
        postinganSaya.insert(0, kontrolerPostingan.text);
        semuaPostingan.insert(0, kontrolerPostingan.text);
        kontrolerPostingan.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil Saya"), 
      backgroundColor: Colors.blue,
      actions: [
        UserDropdownButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
            ),
            SizedBox(height: 10),
            Text(
              "Arthur Pendragon",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("@arthur", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            Text(
              "Pembelajar yang suka berbagi 🔥",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "${postinganSaya.length}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Posting"),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "150",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Followers"),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "89",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Following"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 15),
            Text(
              "Postingan Saya",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),

            // TextField untuk menambah postingan baru
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: kontrolerPostingan,
                      decoration: InputDecoration(
                        hintText: "Tulis postingan...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: tambahPostingan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text("Posting"),
                  ),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: postinganSaya.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postinganSaya[index],
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.favorite_border, color: Colors.red),
                          SizedBox(width: 5),
                          Text("Like"),
                          SizedBox(width: 20),
                          Icon(Icons.comment, color: Colors.grey),
                          SizedBox(width: 5),
                          Text("Komentar"),
                          SizedBox(width: 20),
                          Icon(Icons.bookmark_border, color: Colors.blue),
                          SizedBox(width: 5),
                          Text("Simpan"),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
