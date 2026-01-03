import 'package:flutter/material.dart';
import '../components/user_dropdown.dart';
import '../services/api_service.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // List untuk menyimpan postingan dari API
  List<Post> postinganSaya = [];
  bool isLoading = false;
  User? currentUser; // User yang sedang login

  // Controller untuk form - hanya konten saja
  TextEditingController kontenController = TextEditingController();
  Post? editingPost; // Track post yang sedang diedit

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // Load user data dan posts
  Future<void> loadUserData() async {
    print('=== ProfilePage: Mulai load user data ===');
    setState(() {
      isLoading = true;
    });

    try {
      // Load user info
      print('ProfilePage: Memanggil getCurrentUser...');
      User? user = await ApiService.getCurrentUser();
      print('ProfilePage: User loaded: ${user?.name ?? "null"}');

      // Load posts milik user yang login
      print('ProfilePage: Memanggil getMyPosts...');
      List<Post> posts = await ApiService.getMyPosts();
      print('ProfilePage: Posts loaded: ${posts.length} posts');

      setState(() {
        currentUser = user;
        postinganSaya = posts;
        isLoading = false;
      });

      print('=== ProfilePage: Load selesai ===');
    } catch (e) {
      print('❌ ProfilePage ERROR: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk menambah/update postingan
  Future<void> simpanPostingan() async {
    // Validasi: konten tidak boleh kosong
    if (kontenController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Konten postingan tidak boleh kosong!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    bool success;
    if (editingPost == null) {
      // Create new post
      success = await ApiService.createPost(kontenController.text);
    } else {
      // Update existing post
      success = await ApiService.updatePost(
        editingPost!.id,
        kontenController.text,
      );
    }

    if (success) {
      kontenController.clear();
      setState(() {
        editingPost = null;
      });
      loadUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            editingPost == null
                ? 'Postingan berhasil dibuat!'
                : 'Postingan berhasil diupdate!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan postingan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Fungsi untuk edit post
  void editPost(Post post) {
    setState(() {
      editingPost = post;
      kontenController.text = post.content;
    });
  }

  // Fungsi untuk cancel edit
  void cancelEdit() {
    setState(() {
      editingPost = null;
      kontenController.clear();
    });
  }

  // Fungsi untuk hapus post
  Future<void> hapusPost(Post post) async {
    // Ambil preview content (maksimal 50 karakter)
    String preview = post.content.length > 50
        ? post.content.substring(0, 50) + '...'
        : post.content;

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Postingan'),
        content: Text('Yakin ingin menghapus postingan ini?\n\n\"$preview\"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      bool success = await ApiService.deletePost(post.id);
      if (success) {
        loadUserData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Postingan berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus postingan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Saya"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: loadUserData,
            tooltip: 'Refresh',
          ),
          UserDropdownButton(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadUserData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade200,
                child: Text(
                  currentUser != null
                      ? currentUser!.name[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                currentUser?.name ?? "Loading...",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                currentUser?.email ?? "",
                style: TextStyle(color: Colors.grey),
              ),
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

              // Form CRUD Simple - hanya konten
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (editingPost != null)
                      Row(
                        children: [
                          Icon(Icons.edit, color: Colors.orange, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Edit Postingan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close, size: 20),
                            onPressed: cancelEdit,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),
                    TextField(
                      controller: kontenController,
                      decoration: InputDecoration(
                        hintText: "Apa yang kamu pikirkan?...",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: simpanPostingan,
                        icon: Icon(
                          editingPost == null ? Icons.send : Icons.save,
                        ),
                        label: Text(editingPost == null ? "Posting" : "Update"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: editingPost == null
                              ? Colors.blue
                              : Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),

              // Loading
              if (isLoading)
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                )
              // Empty State
              else if (postinganSaya.isEmpty)
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Belum ada postingan',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              // List Posts
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: postinganSaya.length,
                  itemBuilder: (context, index) {
                    Post post = postinganSaya[index];
                    return Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 5),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  post.content,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              // Tombol Edit & Hapus
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                onPressed: () => editPost(post),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () => hapusPost(post),
                                tooltip: 'Hapus',
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    kontenController.dispose();
    super.dispose();
  }
}
