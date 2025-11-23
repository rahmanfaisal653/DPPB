import 'package:flutter/material.dart';
import '../models/post_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eduvoria — Home"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: PostData.allPosts.length,
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
                Text(PostData.allPosts[index], style: TextStyle(fontSize: 16)),
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
    );
  }
}
