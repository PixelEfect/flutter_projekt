import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'exhibit_detail_page.dart';

class VisitedPage extends StatefulWidget {
  final String username;

  const VisitedPage({Key? key, required this.username}) : super(key: key);

  @override
  State<VisitedPage> createState() => _VisitedPageState();
}

class _VisitedPageState extends State<VisitedPage> {
  List<Map<String, dynamic>> visitedExhibits = [];
  int totalAvailablePoints = 0;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await fetchVisitedExhibits();
      await fetchUserData();
      await fetchTotalAvailablePoints();
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error gracefully, e.g., show error message to user
    }
  }

  Future<void> fetchVisitedExhibits() async {
    final response = await http.get(Uri.parse(
        '${AppConfig.baseUrl}/api/users/${widget.username}/visited-exhibits/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        visitedExhibits = data.map((item) {
          int exhibitPoints = item['points'] ??
              0; // Zliczanie punktów każdego eksponatu
          return {
            'id': item['id'],
            'name': item['name'],
            'description': item['description'],
            'points': exhibitPoints, // Dodanie punktów do mapy eksponatu
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load visited exhibits');
    }
  }

  Future<void> fetchUserData() async {
    final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/users/${widget.username}/id/'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print('User Data Response: $data');

      String userIdFromUserData = data['id'].toString();
      print('userIdFromUserData: $userIdFromUserData');

      if (userIdFromUserData != null) {
        userId = int.parse(userIdFromUserData);
        print('UserID: $userId');
      } else {
        print('Error: User ID is null or invalid');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }







  Future<void> fetchTotalAvailablePoints() async {
    final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/exhibits/total-points/'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        totalAvailablePoints = data['total_points'];
      });
    } else {
      throw Exception('Failed to load total available points');
    }
  }

  int totalVisitedExhibitsPoints() {
    return visitedExhibits.fold(0, (sum, exhibit) => sum + (exhibit['points'] ?? 0) as int);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Eksponaty'),
            Text(
              'Punkty: ${totalVisitedExhibitsPoints()}/$totalAvailablePoints',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
      ),
      body: ListView.builder(
        itemCount: visitedExhibits.length,
        itemBuilder: (BuildContext context, int index) {
          final exhibit = visitedExhibits[index];
          int exhibitPoints = exhibit['points'] ??
              0; // Zliczanie punktów każdego eksponatu
          return ListTile(
            title: Text(
              '${exhibit['name']} - ${exhibit['description']}',
              style: TextStyle(fontSize: 16.0),
            ),
            subtitle: Text(
              'Liczba punktów: $exhibitPoints',
              style: TextStyle(fontSize: 14.0),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ExhibitDetailPage(
                        exhibitName: exhibit['name'],
                        exhibitDescription: exhibit['description'],
                        exhibitId: exhibit['id'],
                        userId: userId,
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
