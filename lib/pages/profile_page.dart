import 'dart:convert';
import '../config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final String username; // Define username as a class property

  const ProfilePage({super.key, required this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
  try {
    final apiUrl = Uri.parse('${AppConfig.baseUrl}/api/users/${widget.username}'); // Include the username in the URL

    final response = await http.get(
      apiUrl,
      headers: <String, String>{
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        userData = jsonDecode(response.body);
      });
    } else {
      _showErrorDialog('Failed to fetch user data');
    }
  } catch (error) {
    print('Error fetching user data: $error');
    _showErrorDialog('Error fetching user data');
  }
}


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
      ),
      body: Center(
        child: userData != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Username: ${userData!['username']}'),
                  Text('Email: ${userData!['email']}'),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
