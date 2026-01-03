// Model untuk data Community
class Community {
  final int id;
  final String name;
  final String? description;
  final String? category;
  final int? memberCount;
  final String? createdAt;
  final String? updatedAt;
  final int? userId; // User yang membuat community
  final String? userName; // Nama user yang membuat
  final String? userEmail; // Email user yang membuat

  Community({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.memberCount,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.userName,
    this.userEmail,
  });

  // Fungsi untuk convert JSON dari API ke object Community
  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      category: json['category'],
      memberCount: json['member_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
      userName: json['user'] != null ? json['user']['name'] : null,
      userEmail: json['user'] != null ? json['user']['email'] : null,
    );
  }

  // Fungsi untuk convert object Community ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'user_id': userId,
    };
  }
}
