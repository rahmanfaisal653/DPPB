// Model untuk data User/Authentication
class User {
  final int id;
  final String name;
  final String email;
  final String token;
  final String role; // 'admin' atau 'user'

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    this.role = 'user',
  });

  // Fungsi untuk convert JSON dari API ke object User
  factory User.fromJson(Map<String, dynamic> json) {
    // Handle berbagai format response dari API:
    // Format 1: {"success": true, "data": {"user": {...}, "token": "..."}}
    // Format 2: {"data": {"user": {...}, "token": "..."}}
    // Format 3: {"user": {...}, "token": "..."}
    // Format 4: {"id": ..., "name": ..., "token": "..."}

    // Ekstrak data jika ada wrapper 'data'
    Map<String, dynamic> workingJson = json;
    if (json.containsKey('data') && json['data'] != null) {
      workingJson = json['data'];
    }

    // Ambil token
    String token = workingJson['token'] ?? json['token'] ?? '';

    // Ambil user data
    Map<String, dynamic> userData;
    if (workingJson.containsKey('user') && workingJson['user'] != null) {
      // Ada nested 'user' object
      userData = workingJson['user'];
    } else {
      // Flat structure
      userData = workingJson;
    }

    return User(
      id: userData['id'],
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      token: token,
      role: userData['role'] ?? 'user',
    );
  }

  // Fungsi untuk convert object User ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'role': role,
    };
  }

  // Helper function untuk cek apakah user adalah admin
  bool isAdmin() {
    return role == 'admin';
  }
}
