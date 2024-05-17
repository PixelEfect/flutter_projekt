import 'package:flutter/material.dart';
import 'package:projekt/profile_page.dart'; // Import the profile page
import 'package:projekt/visited_page.dart';

import 'scanner_page.dart'; // Import the visited page

class HomePage extends StatelessWidget {
  final String username; // Add username parameter

  const HomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noc w muzeum'),
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
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
                    MaterialPageRoute(builder: (context) => ProfilePage(username: username)), // Pass the username
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
                    MaterialPageRoute(builder: (context) => VisitedPage(username: username,)), // Navigate to VisitedPage
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
            MaterialPageRoute(builder: (context) => QRCodeScanner(username: username,), // Navigate to VisitedPage
          ));
            },
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
        child: const Icon(Icons.qr_code_2, color: Colors.black),
      ),
    );
  }
}
