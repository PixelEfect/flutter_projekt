import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projekt/pages/home_page.dart';
import 'home_page_mod.dart';
import 'register_page.dart';
import '../config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isAdmin = false;

  Future<void> _login() async {
    final String apiUrl = '${AppConfig.baseUrl}/api/login/';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _usernameController.text.trim(),
        'password': _passwordController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String username = _usernameController.text.trim();
      isAdmin = await fetchIsAdmin(username); // Fetch isAdmin status separately

      if (isAdmin) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageMod(username: username),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(username: username),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Logowanie zakonczone niepowodzeniem'),
          content: const Text('Nieprawidlowa nazwa lub haslo'),
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

  Future<bool> fetchIsAdmin(String username) async {
    final apiUrl = '${AppConfig.baseUrl}/api/users/$username';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['is_admin'] ?? false;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
        title: const Text("Noc w muzeum"),
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
                controller: _usernameController,
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
                controller: _passwordController,
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
                onPressed: _login,
                child: const Text('Zaloguj'),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: 300.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
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