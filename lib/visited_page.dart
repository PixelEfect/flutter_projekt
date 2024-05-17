import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import dart:convert for JSON decoding
import 'config.dart';

class VisitedPage extends StatefulWidget {
  final String username;

  const VisitedPage({super.key, required this.username});

  @override
  State<VisitedPage> createState() => _VisitedPageState();
}

class _VisitedPageState extends State<VisitedPage> {
  List<String> visitedExhibits = []; // List to store visited exhibits
  late int visitedExhibitsPoints = 0,totalAvailablePoints = 0;

  @override
  void initState() {
    super.initState();
    fetchVisitedExhibits(); // Fetch visited exhibits when the page initializes
    fetchVisitedExhibitsPoints();
    fetchTotalAvailablePoints();
  }


Future<void> fetchVisitedExhibits() async {
  final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/users/${widget.username}/visited-exhibits/'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    setState(() {
      visitedExhibits = data.map((item) => '${item['name']} - ${item['description']}').toList(); // Concatenate name and description
    });
  } else {
    throw Exception('Failed to load visited exhibits');
  }
}

  Future<void> fetchVisitedExhibitsPoints() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/users/${widget.username}'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        visitedExhibitsPoints = data['points'];
      });
    } else {
      throw Exception('Failed to load visited exhibits');
    }
  }


  Future<void> fetchTotalAvailablePoints() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/exhibits/total-points'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        totalAvailablePoints = data['total_points'];
      });
    } else {
      throw Exception('Failed to load total available points');
    }
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Odwiedzone Eksponaty'),
          Text(
            'Punkty: $visitedExhibitsPoints/$totalAvailablePoints',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),backgroundColor: const Color.fromARGB(255, 221, 206, 69),
    ),
    body: ListView.builder(
      itemCount: visitedExhibits.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(visitedExhibits[index]),
        );
      },
    ),
  );
}
}
