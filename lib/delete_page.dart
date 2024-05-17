import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import dart:convert for JSON decoding
import 'config.dart';

class DeletePage extends StatefulWidget {


  const DeletePage({super.key});

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  List<String> Exhibits = []; // List to store visited exhibits

  @override
  void initState() {
    super.initState();
    fetchExhibits(); // Fetch  exhibits when the page initializes

  }


  Future<void> fetchExhibits() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/exhibits/'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        Exhibits = data
            .map((item) => '${item['id']} - ${item['name']}')
            .toList(); // Concatenate ID, name, and description
      });
    } else {
      throw Exception('Failed to load visited exhibits');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usun eksponat'),
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: Exhibits.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(Exhibits[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Wprowadz ID eksponatu',
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Implement the delete functionality here
                  },
                  child: const Text('Usun'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
