// File ini untuk test API secara langsung
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  await testLogin();
  await Future.delayed(Duration(seconds: 2));
  await testGetPosts();
  await Future.delayed(Duration(seconds: 2));
  await testGetUser();
  await Future.delayed(Duration(seconds: 2));
  await testGetMyPosts();
}

String? token;

// Test Login
Future<void> testLogin() async {
  print('\n===== TEST LOGIN =====');
  try {
    final response = await http.post(
      Uri.parse('https://eduvoria.kolab.top/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': 'faisal@eduvoria.com',
        'password': 'password123',
      }),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body:');
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);

      // Coba berbagai cara ambil token
      if (data['token'] != null) {
        token = data['token'];
        print('\n✅ Token found: $token');
      } else if (data['data'] != null && data['data']['token'] != null) {
        token = data['data']['token'];
        print('\n✅ Token found in data: $token');
      }
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}

// Test Get All Posts
Future<void> testGetPosts() async {
  print('\n===== TEST GET POSTS =====');
  if (token == null) {
    print('❌ Token not available');
    return;
  }

  try {
    final response = await http.get(
      Uri.parse('https://eduvoria.kolab.top/api/posts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body:');
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Cek format response
      if (data is Map && data.containsKey('data')) {
        print('\n✅ Format: {"data": [...]}');
        print('Jumlah posts: ${data['data'].length}');
      } else if (data is List) {
        print('\n✅ Format: [...]');
        print('Jumlah posts: ${data.length}');
      } else {
        print('\n❓ Format unknown');
      }
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}

// Test Get Current User
Future<void> testGetUser() async {
  print('\n===== TEST GET USER =====');
  if (token == null) {
    print('❌ Token not available');
    return;
  }

  try {
    final response = await http.get(
      Uri.parse('https://eduvoria.kolab.top/api/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body:');
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Cek format response
      if (data is Map && data.containsKey('user')) {
        print('\n✅ Format: {"user": {...}}');
        print('Name: ${data['user']['name']}');
        print('Email: ${data['user']['email']}');
      } else if (data is Map && data.containsKey('name')) {
        print('\n✅ Format: {name, email, ...}');
        print('Name: ${data['name']}');
        print('Email: ${data['email']}');
      } else if (data is Map && data.containsKey('data')) {
        print('\n✅ Format: {"success": ..., "data": {...}}');
        if (data['data'].containsKey('name')) {
          print('Name: ${data['data']['name']}');
          print('Email: ${data['data']['email']}');
        }
      } else {
        print('\n❓ Format unknown');
      }
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}

// Test Get My Posts (postingan user yang login)
Future<void> testGetMyPosts() async {
  print('\n===== TEST GET MY POSTS =====');
  if (token == null) {
    print('❌ Token not available');
    return;
  }

  try {
    final response = await http.get(
      Uri.parse('https://eduvoria.kolab.top/api/posts/my'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body:');
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Cek format response
      if (data is Map && data.containsKey('data')) {
        print('\n✅ Format: {"data": [...]}');
        print('Jumlah my posts: ${data['data'].length}');

        // Tampilkan sample post
        if (data['data'].length > 0) {
          print('\nSample post:');
          print('ID: ${data['data'][0]['id']}');
          print('Content: ${data['data'][0]['content']}');
          if (data['data'][0]['user'] != null) {
            print('Author: ${data['data'][0]['user']['name']}');
          }
        }
      } else if (data is List) {
        print('\n✅ Format: [...]');
        print('Jumlah my posts: ${data.length}');
      } else {
        print('\n❓ Format unknown');
      }
    } else if (response.statusCode == 404) {
      print('\n⚠️ Endpoint /posts/my tidak ditemukan (404)');
      print('Mungkin harus pakai /posts saja dengan filter?');
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}
