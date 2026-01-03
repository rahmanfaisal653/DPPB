import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/post_model.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Post> bookmarkedPosts = [];
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
      bookmarkedPosts = posts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmark"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: loadPosts,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadPosts,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : bookmarkedPosts.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_border, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Belum ada bookmark',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: bookmarkedPosts.length,
                itemBuilder: (context, index) {
                  Post post = bookmarkedPosts[index];
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.bookmark, color: Colors.teal),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                post.content,
                                style: TextStyle(fontSize: 14),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
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
