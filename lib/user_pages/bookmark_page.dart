import 'package:flutter/material.dart';
import 'home_page.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bookmark"), backgroundColor: Colors.teal),
      body: ListView.builder(
        itemCount: semuaPostingan.length,
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
                Row(
                  children: [
                    Icon(Icons.bookmark, color: Colors.teal),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        semuaPostingan[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
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
