import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config.dart'; // Ten plik powinien zawierać definicję AppConfig

class ExhibitDetailPage extends StatefulWidget {
  final String exhibitName;
  final String exhibitDescription;
  final int exhibitId;
  final int userId;

  const ExhibitDetailPage({
    Key? key,
    required this.exhibitName,
    required this.exhibitDescription,
    required this.exhibitId,
    required this.userId,
  }) : super(key: key);

  @override
  _ExhibitDetailPageState createState() => _ExhibitDetailPageState();
}

class _ExhibitDetailPageState extends State<ExhibitDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
    print('User ID in ExhibitDetailPage: ${widget.userId}');
  }

  Future<void> _fetchComments() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/comments/${widget.exhibitId}/'),
    );

    if (response.statusCode == 200) {
      setState(() {
        // Dekodowanie z UTF-8
        _comments = List<Map<String, dynamic>>.from(json.decode(utf8.decode(response.bodyBytes)));
      });
    } else {
      print('Failed to load comments');
      print('User ID: ${widget.userId}');
    }
  }

  Future<void> _addComment() async {
    final String commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      print('Adding comment - user_id: ${widget.userId}, exhibit_id: ${widget.exhibitId}, comment: $commentText');
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/add_comment/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'user_id': widget.userId.toString(),
          'exhibit_id': widget.exhibitId.toString(),
          'comment': commentText,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _commentController.clear();
        _fetchComments(); // Refresh comments after adding a new one
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Komentarz dodany pomyślnie')),
        );
      } else {
        print('Failed to add comment: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exhibitName),
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.exhibitDescription, style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return ListTile(
                    title: Text(comment['comment']),
                    subtitle: Text('User ID: ${comment['user']}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Dodaj komentarz',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _addComment,
              child: const Text('Dodaj komentarz'),
            ),
          ],
        ),
      ),
    );
  }
}
