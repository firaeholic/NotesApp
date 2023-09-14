// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class User {
//   final String id;
//   final String fullname;
//   final String username;
//   final String email;

//   User({required this.id, required this.fullname, required this.username, required this.email});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['_id'],
//       fullname: json['fullname'],
//       username: json['username'],
//       email: json['email'],
//     );
//   }
// }

// Future<void> getUsers() async {
//   final response = await http.get(Uri.parse('https://192.168.1.5:5001/users'));
//   print(response);

//   if (response.statusCode == 200) {
//     final List<dynamic> userJsonList = jsonDecode(response.body);
//     final List<User> userList = userJsonList
//         .map((userJson) => User.fromJson(userJson))
//         .toList(); 
//     print(userList);
//     return;
//   } else {
//     throw Exception('Failed to fetch users');
//   }
// }