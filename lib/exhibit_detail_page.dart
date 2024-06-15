import 'package:flutter/material.dart';

class ExhibitDetailPage extends StatelessWidget {
  final String exhibitName;
  final String exhibitDescription;

  const ExhibitDetailPage({super.key, required this.exhibitName, required this.exhibitDescription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exhibitName),
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(exhibitDescription, style: const TextStyle(fontSize: 18.0)),
      ),
    );
  }
}
