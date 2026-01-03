// Model untuk data Post
class Post {
  final int id;
  final String content; // Isi postingan
  final int userId;
  final String? createdAt;
  final String? updatedAt;
  final String? userName; // Nama author
  final String? userEmail; // Email author

  Post({
    required this.id,
    required this.content,
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.userEmail,
  });

  // Fungsi untuk convert JSON dari API ke object Post
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'] ?? '', // Default empty string jika null
      userId: json['user_id'] ?? json['user']['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userName: json['user'] != null ? json['user']['name'] : null,
      userEmail: json['user'] != null ? json['user']['email'] : null,
    );
  }

  // Fungsi untuk convert object Post ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
