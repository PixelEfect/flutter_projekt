import 'package:flutter/material.dart';
import 'package:projekt/profile_page.dart'; // Import the profile page
import 'package:projekt/visited_page.dart';
import 'package:projekt/login_page.dart'; // Import the login page
import 'scanner_page.dart'; // Import the scanner page

class HomePage extends StatelessWidget {
  final String username; // Add username parameter

  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Noc w muzeum',
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              onPressed: () {
                // Implement logout functionality here
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
        automaticallyImplyLeading: false, // This line hides the leading arrow
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55.0,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(username: username),
                    ),
                  );
                },
                label: const Text('MOJ PROFIL'),
                icon: const Icon(Icons.person),
                style: ElevatedButton.styleFrom(foregroundColor: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55.0,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisitedPage(username: username),
                    ),
                  );
                },
                label: const Text('ODWIEDZONE'),
                icon: const Icon(Icons.history),
                style: ElevatedButton.styleFrom(foregroundColor: Colors.black),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRCodeScanner(username: username)),
          );
        },
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
        child: const Icon(Icons.qr_code_2, color: Colors.black),
      ),
    );
  }
}
