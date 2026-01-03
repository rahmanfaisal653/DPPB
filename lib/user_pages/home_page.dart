import 'package:flutter/material.dart';
import '../components/user_dropdown.dart';
import '../services/api_service.dart';
import '../models/post_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> semuaPostingan = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    setState(() {
      isLoading = true;
    });

    List<Post> posts = await ApiService.getPosts();

    setState(() {
      semuaPostingan = posts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eduvoria — Home"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: loadPosts,
            tooltip: 'Refresh',
          ),
          UserDropdownButton(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadPosts,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : semuaPostingan.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.article_outlined, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Belum ada postingan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: semuaPostingan.length,
                itemBuilder: (context, index) {
                  Post post = semuaPostingan[index];
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
                        // Author info
                        if (post.userName != null && post.userName!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.blue.shade200,
                                  child: Text(
                                    post.userName![0].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.userName!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (post.userEmail != null)
                                      Text(
                                        post.userEmail!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        Divider(),
                        // Konten postingan
                        Text(post.content, style: TextStyle(fontSize: 14)),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text("Like", style: TextStyle(fontSize: 13)),
                            SizedBox(width: 20),
                            Icon(Icons.comment, color: Colors.grey, size: 18),
                            SizedBox(width: 5),
                            Text("Komentar", style: TextStyle(fontSize: 13)),
                            SizedBox(width: 20),
                            Icon(
                              Icons.bookmark_border,
                              color: Colors.blue,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text("Simpan", style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
