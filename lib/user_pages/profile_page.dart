import 'package:flutter/material.dart';
import '../models/post_data.dart';
import 'add_post_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void bukaHalamanTambahPost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddPostPage();
        },
      ),
    ).then((value) {
      if (value == true) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil Saya"), backgroundColor: Colors.blue),
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
                      "${PostData.userPosts.length}",
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

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: PostData.userPosts.length,
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
                        PostData.userPosts[index],
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
      floatingActionButton: FloatingActionButton(
        onPressed: bukaHalamanTambahPost,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}
