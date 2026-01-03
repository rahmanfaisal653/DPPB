import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/post_model.dart';
import 'login_page.dart';

// Halaman Kelola Post dengan API
class KelolaPostPage extends StatefulWidget {
  final List<String> posts; // Masih terima props untuk backward compatibility

  const KelolaPostPage({super.key, required this.posts});

  @override
  State<KelolaPostPage> createState() => _KelolaPostPageState();
}

class _KelolaPostPageState extends State<KelolaPostPage> {
  List<Post> postList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load posts dari API saat halaman dibuka
    loadPosts();
  }

  // Fungsi untuk load posts dari API
  Future<void> loadPosts() async {
    setState(() {
      isLoading = true;
    });

    List<Post> posts = await ApiService.getPosts();

    setState(() {
      postList = posts;
      isLoading = false;
    });
  }

  // Fungsi untuk tambah post baru
  void showAddPostDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Post Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Konten',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty) {
                Navigator.pop(context);

                // Panggil API create post
                bool success = await ApiService.createPost(
                  titleController.text,
                  contentController.text,
                );

                if (success) {
                  // Reload posts
                  loadPosts();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post berhasil ditambahkan!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menambahkan post')),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk edit post
  void showEditPostDialog(Post post) {
    final titleController = TextEditingController(text: post.title);
    final contentController = TextEditingController(text: post.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Konten',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty) {
                Navigator.pop(context);

                // Panggil API update post
                bool success = await ApiService.updatePost(
                  post.id,
                  titleController.text,
                  contentController.text,
                );

                if (success) {
                  // Reload posts
                  loadPosts();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post berhasil diupdate!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal mengupdate post')),
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk hapus post
  void deletePost(Post post) async {
    // Konfirmasi hapus
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus post "${post.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Panggil API delete post
      bool success = await ApiService.deletePost(post.id);

      if (success) {
        // Reload posts
        loadPosts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post berhasil dihapus!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus post')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Post"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Button refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadPosts,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : postList.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada post',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: postList.length,
                  itemBuilder: (context, index) {
                    Post post = postList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(
                          post.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          post.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Button Edit
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => showEditPostDialog(post),
                            ),
                            // Button Delete
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deletePost(post),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddPostDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
