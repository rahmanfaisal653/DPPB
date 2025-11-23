import 'package:flutter/material.dart';
import '../models/post_data.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController kontrolerText = TextEditingController();

  void kirimPostingan() {
    if (kontrolerText.text.isNotEmpty) {
      PostData.addPost(kontrolerText.text);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buat Postingan Baru"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Apa yang ingin kamu bagikan?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: kontrolerText,
              decoration: InputDecoration(
                hintText: "Tulis postingan kamu di sini...",
                border: OutlineInputBorder(),
              
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: kirimPostingan,
              child: Text("Posting"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
