import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class KelolaUserPage extends StatefulWidget {
  const KelolaUserPage({super.key});

  @override
  State<KelolaUserPage> createState() => _KelolaUserPageState();
}

class _KelolaUserPageState extends State<KelolaUserPage> {
  List<User> daftarUser = [];
  bool sedangLoading = true;

  @override
  void initState() {
    super.initState();
    muatDataUser();
  }

  // Fungsi untuk muat data user dari API
  void muatDataUser() async {
    print('=== Mulai muat data user ===');
    setState(() {
      sedangLoading = true;
    });

    List<User> hasil = await ApiService.getAllUsers();
    print('Jumlah user yang didapat: ${hasil.length}');

    setState(() {
      daftarUser = hasil;
      sedangLoading = false;
    });
    print('=== Selesai muat data user ===');
  }

  // Fungsi untuk hapus user
  void hapusUser(User user) async {
    // Tampilkan dialog konfirmasi dulu
    bool? yakin = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus User'),
          content: Text('Yakin ingin menghapus user "${user.name}"?'),
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

    // Kalau user klik Hapus
    if (yakin == true) {
      bool berhasil = await ApiService.deleteUser(user.id);

      if (berhasil) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User berhasil dihapus')));
        muatDataUser(); // Reload data
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus user')));
      }
    }
  }

  // Fungsi untuk tambah user baru
  void tampilkanFormTambah() {
    TextEditingController namaController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    String roleTerpilih = 'user';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah User Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: roleTerpilih,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: 'user', child: Text('User')),
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  ],
                  onChanged: (value) {
                    roleTerpilih = value!;
                  },
                ),
              ],
            ),
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
                String nama = namaController.text.trim();
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                // Validasi input
                if (nama.isEmpty || email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Semua field harus diisi')),
                  );
                  return;
                }

                print('=== Mencoba buat user baru ===');
                print('Nama: $nama');
                print('Email: $email');
                print('Role: $roleTerpilih');

                // Panggil API create user
                bool berhasil = await ApiService.createUser(
                  nama,
                  email,
                  password,
                  roleTerpilih,
                );

                print('Hasil create user: $berhasil');

                Navigator.pop(context);

                if (berhasil) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User berhasil ditambahkan')),
                  );
                  print('Memanggil muatDataUser() untuk refresh...');
                  muatDataUser(); // Reload data
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menambahkan user')),
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

  // Fungsi untuk edit user
  void tampilkanFormEdit(User user) {
    TextEditingController namaController = TextEditingController(
      text: user.name,
    );
    TextEditingController emailController = TextEditingController(
      text: user.email,
    );
    String roleTerpilih = user.role;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit User'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: roleTerpilih,
                      decoration: InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: 'user', child: Text('User')),
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          roleTerpilih = value!;
                        });
                      },
                    ),
                  ],
                ),
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
                    String nama = namaController.text.trim();
                    String email = emailController.text.trim();

                    // Validasi input
                    if (nama.isEmpty || email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Nama dan email harus diisi')),
                      );
                      return;
                    }

                    print('=== Mencoba update user ===');
                    print('User ID: ${user.id}');
                    print('Nama: $nama');
                    print('Email: $email');
                    print('Role: $roleTerpilih');

                    // Panggil API update user
                    bool berhasil = await ApiService.updateUser(
                      user.id,
                      nama,
                      email,
                      roleTerpilih,
                    );

                    print('Hasil update user: $berhasil');

                    Navigator.pop(context);

                    if (berhasil) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User berhasil diupdate')),
                      );
                      muatDataUser(); // Reload data
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal mengupdate user')),
                      );
                    }
                  },
                  child: Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kelola User"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: sedangLoading
          ? Center(child: CircularProgressIndicator())
          : daftarUser.isEmpty
          ? Center(
              child: Text(
                'Belum ada user',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: daftarUser.length,
              itemBuilder: (context, index) {
                User user = daftarUser[index];

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: user.role == 'admin'
                          ? Colors.red
                          : Colors.blue,
                      child: Icon(
                        user.role == 'admin'
                            ? Icons.admin_panel_settings
                            : Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(user.name),
                    subtitle: Text('${user.email}\nRole: ${user.role}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            tampilkanFormEdit(user);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            hapusUser(user);
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
