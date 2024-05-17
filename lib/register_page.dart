import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key, Key? keys});

  Future<void> _register(BuildContext context, String username, String email, String password) async {
    final String apiUrl = '${AppConfig.baseUrl}/api/register/';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // Registration successful
      // You can handle success as per your app's requirement
      // For example, navigate to another page or show a success dialog.
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Registration Successful'),
          content: const Text('You have successfully registered.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Registration failed
      // You can handle failure as per your app's requirement
      // For example, show an error message.
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Registration Failed'),
          content: const Text('Failed to register. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String username = '';
    String email = '';
    String password = '';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
        title: const Text("Noc w muzem"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 70.0,
            ),
            SizedBox(
              width: 300.0,
              child: TextField(
                onChanged: (value) => username = value,
                decoration: const InputDecoration(
                  labelText: 'Nazwa użytkownika',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: 300.0,
              child: TextField(
                onChanged: (value) => email = value,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: 300.0,
              child: TextField(
                onChanged: (value) => password = value,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Hasło',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: 300.0,
              child: ElevatedButton(
                onPressed: () {
                  _register(context, username, email, password);
                },
                child: const Text('Zarejestruj'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
