import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/post_model.dart';

class KelolaPostPage extends StatefulWidget {
  final List<String> posts;

  const KelolaPostPage({super.key, required this.posts});

  @override
  State<KelolaPostPage> createState() => _KelolaPostPageState();
}

class _KelolaPostPageState extends State<KelolaPostPage> {
  List<Post> daftarPost = [];
  bool sedangLoading = false;

  @override
  void initState() {
    super.initState();
    muatDataPost();
  }

  // Fungsi untuk muat data post dari API
  void muatDataPost() async {
    setState(() {
      sedangLoading = true;
    });

    List<Post> posts = await ApiService.getPosts();

    setState(() {
      daftarPost = posts;
      sedangLoading = false;
    });
  }

  // Fungsi untuk tambah post baru
  void tampilkanFormTambah() {
    TextEditingController kontenController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Post Baru'),
          content: TextField(
            controller: kontenController,
            decoration: InputDecoration(
              labelText: 'Konten Post',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                String konten = kontenController.text.trim();

                if (konten.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Konten harus diisi')));
                  return;
                }

                Navigator.pop(context);

                bool berhasil = await ApiService.createPost(konten);

                if (berhasil) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Post berhasil ditambahkan')),
                  );
                  muatDataPost(); // Reload data
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menambahkan post')),
                  );
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk edit post
  void tampilkanFormEdit(Post post) {
    TextEditingController kontenController = TextEditingController(
      text: post.content,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Post'),
          content: TextField(
            controller: kontenController,
            decoration: InputDecoration(
              labelText: 'Konten Post',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                String konten = kontenController.text.trim();

                if (konten.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Konten harus diisi')));
                  return;
                }

                Navigator.pop(context);

                bool berhasil = await ApiService.updatePost(post.id, konten);

                if (berhasil) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Post berhasil diupdate')),
                  );
                  muatDataPost(); // Reload data
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal mengupdate post')),
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk hapus post
  void hapusPost(Post post) async {
    bool? yakin = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus Post'),
          content: Text('Yakin ingin menghapus post ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (yakin == true) {
      bool berhasil = await ApiService.deletePost(post.id);

      if (berhasil) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Post berhasil dihapus')));
        muatDataPost(); // Reload data
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus post')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Post'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: sedangLoading
          ? Center(child: CircularProgressIndicator())
          : daftarPost.isEmpty
          ? Center(
              child: Text(
                'Belum ada post',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: daftarPost.length,
              itemBuilder: (context, index) {
                Post post = daftarPost[index];

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      post.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('By: ${post.userName ?? "Unknown"}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            tampilkanFormEdit(post);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            hapusPost(post);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: tampilkanFormTambah,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}
