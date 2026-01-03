import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';

// Service untuk handle semua API calls
class ApiService {
  // Base URL API Laravel
  static const String baseUrl = 'https://eduvoria.kolab.top/api';

  // ========== AUTHENTICATION FUNCTIONS ==========

  // Fungsi untuk login dan dapat token
  static Future<User?> login(String email, String password) async {
    try {
      print('Attempting login to: $baseUrl/login');
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        User user = User.fromJson(data);
        // Simpan token setelah login berhasil
        await saveToken(user.token);
        print('Login successful, token saved');
        return user;
      } else {
        print('Login failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error login: $e');
      return null;
    }
  }

  // Fungsi untuk register
  static Future<User?> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      print('Attempting register to: $baseUrl/register');
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        User user = User.fromJson(data);
        // Simpan token setelah register berhasil
        await saveToken(user.token);
        print('Register successful, token saved');
        return user;
      } else {
        print('Register failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error register: $e');
      return null;
    }
  }

  // Fungsi untuk logout
  static Future<bool> logout() async {
    try {
      String? token = await getToken();
      if (token == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Hapus token dari storage
      await removeToken();
      return response.statusCode == 200;
    } catch (e) {
      print('Error logout: $e');
      // Tetap hapus token meskipun API error
      await removeToken();
      return false;
    }
  }

  // Fungsi untuk simpan token ke SharedPreferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Fungsi untuk ambil token dari SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Fungsi untuk hapus token
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Fungsi untuk cek apakah user sudah login
  static Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null;
  }

  // GET - Ambil info user yang sedang login
  static Future<User?> getCurrentUser() async {
    try {
      String? token = await getToken();
      if (token == null) {
        print('Token tidak ditemukan');
        return null;
      }

      print('Fetching current user from: $baseUrl/user');
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get user response status: ${response.statusCode}');
      print('Get user response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Response format: {"success": true, "data": {"id": ..., "name": ..., "email": ...}}
        Map<String, dynamic> userData;

        if (jsonData.containsKey('data') && jsonData['data'] != null) {
          // Format: {"success": true, "data": {...}}
          userData = {'user': jsonData['data'], 'token': token};
        } else if (jsonData.containsKey('user')) {
          // Format: {"user": {...}}
          userData = {'user': jsonData['user'], 'token': token};
        } else {
          // Format: {"id": ..., "name": ..., "email": ...}
          userData = {'user': jsonData, 'token': token};
        }

        User user = User.fromJson(userData);
        print('Berhasil load user: ${user.name}');
        return user;
      } else {
        print('Error: status code ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error get current user: $e');
      return null;
    }
  }

  // ========== CRUD FUNCTIONS (dengan token) ==========

  // GET - Ambil semua posts
  static Future<List<Post>> getPosts() async {
    try {
      String? token = await getToken();
      if (token == null) {
        print('Token tidak ditemukan');
        return [];
      }

      print('Fetching posts from: $baseUrl/posts');
      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get posts response status: ${response.statusCode}');
      print('Get posts response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Cek apakah response punya key 'data'
        List<dynamic> postsList;
        if (jsonData is Map && jsonData.containsKey('data')) {
          postsList = jsonData['data'];
        } else if (jsonData is List) {
          postsList = jsonData;
        } else {
          print('Format response tidak sesuai');
          return [];
        }

        // Convert setiap item jadi Post object
        List<Post> posts = [];
        for (var item in postsList) {
          posts.add(Post.fromJson(item));
        }

        print('Berhasil load ${posts.length} posts');
        return posts;
      } else {
        print('Error: status code ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error get posts: $e');
      return [];
    }
  }

  // GET - Ambil posts milik user yang login saja
  // Karena endpoint /posts/my tidak ada, kita filter dari /posts dengan is_owner=true
  static Future<List<Post>> getMyPosts() async {
    try {
      String? token = await getToken();
      if (token == null) {
        print('Token tidak ditemukan');
        return [];
      }

      print('Fetching my posts from: $baseUrl/posts (filter is_owner)');
      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get my posts response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Cek format response
        List<dynamic> postsList;
        if (jsonData is Map && jsonData.containsKey('data')) {
          postsList = jsonData['data'];
        } else if (jsonData is List) {
          postsList = jsonData;
        } else {
          print('Format response tidak sesuai');
          return [];
        }

        // Convert ke Post objects dan filter hanya yang is_owner = true
        List<Post> myPosts = [];
        for (var item in postsList) {
          // Cek apakah post ini milik user yang login
          if (item['is_owner'] == true) {
            myPosts.add(Post.fromJson(item));
          }
        }

        print(
          'Berhasil load ${myPosts.length} posts milik saya dari total ${postsList.length}',
        );
        return myPosts;
      } else {
        print('Error: status code ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error get my posts: $e');
      return [];
    }
  }

  // POST - Tambah post baru
  static Future<bool> createPost(String content) async {
    try {
      String? token = await getToken();
      if (token == null) {
        print('Token tidak ditemukan');
        return false;
      }

      print('Creating post...');
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'content': content}),
      );

      print('Create post response status: ${response.statusCode}');
      print('Create post response: ${response.body}');

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error create post: $e');
      return false;
    }
  }

  // PUT - Update post
  static Future<bool> updatePost(int id, String content) async {
    try {
      String? token = await getToken();
      if (token == null) {
        print('Token tidak ditemukan');
        return false;
      }

      print('Updating post $id...');
      final response = await http.put(
        Uri.parse('$baseUrl/posts/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'content': content}),
      );

      print('Update post response status: ${response.statusCode}');
      print('Update post response: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error update post: $e');
      return false;
    }
  }

  // DELETE - Hapus post
  static Future<bool> deletePost(int id) async {
    try {
      String? token = await getToken();
      if (token == null) return false;

      final response = await http.delete(
        Uri.parse('$baseUrl/posts/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error delete post: $e');
      return false;
    }
  }

  // ========== USER MANAGEMENT FUNCTIONS ==========

  // GET - Ambil semua users
  static Future<List<User>> getAllUsers() async {
    try {
      String? token = await getToken();
      if (token == null) {
        print('GET ALL USERS: Token tidak ditemukan');
        return [];
      }

      print('GET ALL USERS: Fetching from $baseUrl/admin/users');
      final response = await http.get(
        Uri.parse('$baseUrl/admin/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('GET ALL USERS: Status code = ${response.statusCode}');
      print('GET ALL USERS: Response body = ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Handle paginated response dari Laravel
        List<dynamic> usersData;
        if (jsonData.containsKey('data')) {
          if (jsonData['data'] is Map && jsonData['data'].containsKey('data')) {
            usersData = jsonData['data']['data'];
          } else if (jsonData['data'] is List) {
            usersData = jsonData['data'];
          } else {
            usersData = [];
          }
        } else {
          usersData = jsonData;
        }

        print('GET ALL USERS: Jumlah data = ${usersData.length}');

        List<User> users = usersData.map((userData) {
          return User(
            id: userData['id'],
            name: userData['name'] ?? '',
            email: userData['email'] ?? '',
            role: userData['role'] ?? 'user',
            token: '',
          );
        }).toList();

        print('GET ALL USERS: Berhasil parse ${users.length} users');
        return users;
      } else {
        print('GET ALL USERS: Error status ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('GET ALL USERS Error: $e');
      return [];
    }
  }

  // POST - Create user baru
  static Future<bool> createUser(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      String? token = await getToken();
      if (token == null) return false;

      print('CREATE USER: Posting to $baseUrl/admin/users');
      final response = await http.post(
        Uri.parse('$baseUrl/admin/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      print('CREATE USER: Status = ${response.statusCode}');
      print('CREATE USER: Response = ${response.body}');

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error create user: $e');
      return false;
    }
  }

  // PUT - Update user
  static Future<bool> updateUser(
    int userId,
    String name,
    String email,
    String role,
  ) async {
    try {
      String? token = await getToken();
      if (token == null) return false;

      print('UPDATE USER: Putting to $baseUrl/admin/users/$userId');
      final response = await http.put(
        Uri.parse('$baseUrl/admin/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'name': name, 'email': email, 'role': role}),
      );

      print('UPDATE USER: Status = ${response.statusCode}');
      print('UPDATE USER: Response = ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error update user: $e');
      return false;
    }
  }

  // DELETE - Hapus user
  static Future<bool> deleteUser(int userId) async {
    try {
      String? token = await getToken();
      if (token == null) return false;

      print('DELETE USER: Deleting $baseUrl/admin/users/$userId');
      final response = await http.delete(
        Uri.parse('$baseUrl/admin/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('DELETE USER: Status = ${response.statusCode}');
      print('DELETE USER: Response = ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error delete user: $e');
      return false;
    }
  }
}
