// Model data postingan yang bisa di-share antar halaman
class PostData {
  static final List<String> allPosts = [
    "Cara belajar cepat tanpa overthinking 🎯",
    "Belajar Flutter itu seru banget 🚀",
    "Laravel adalah teman terbaik backend dev 🧠",
  ];

  static final List<String> userPosts = [
    "Postingan saya tentang Flutter 🎨",
    "Belajar desain UI modern ✨",
  ];

  // Fungsi untuk menambah postingan baru
  static void addPost(String title) {
    // Tambahkan ke postingan user
    userPosts.insert(0, title);

    // Tambahkan juga ke semua postingan (homepage)
    allPosts.insert(0, title);
  }
}
