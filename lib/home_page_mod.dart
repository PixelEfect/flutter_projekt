import 'package:flutter/material.dart';
import 'package:projekt/profile_page.dart'; // Import the profile page
import 'package:projekt/visited_page.dart';

import 'add_exhibit_page.dart';
import 'delete_page.dart';
import 'scanner_page.dart'; // Import the visited page

class HomePageMod extends StatelessWidget {
  final String username; // Add username parameter

  const HomePageMod({super.key, required this.username});

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
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55.0,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddExhibit()), // Navigate to AddExhibit
                  );
                },
                label: const Text('DODAJ'),
                icon: const Icon(Icons.add),
                style: ElevatedButton.styleFrom(foregroundColor: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55.0,
              child: ElevatedButton.icon(
                label: const Text('USUN'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DeletePage(),),);// Navigate to AddExhibit;
                },
                icon: const Icon(Icons.remove),
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
            MaterialPageRoute(
              builder: (context) => QRCodeScanner(username: username,), // Navigate to QRCodeScanner
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
        child: const Icon(Icons.qr_code_2, color: Colors.black),
      ),
    );
  }
}