import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class AddRoom extends StatefulWidget {
  const AddRoom({super.key});

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  String roomNumber = "";
  String roomName = "";
  String roomDescription = "";
  List<Room> rooms = []; // List to store fetched rooms

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/rooms/'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          rooms = data.map<Room>((json) => Room.fromJson(json)).toList();
        });
        print('Rooms loaded successfully: $rooms');
      } else {
        print('Failed to load rooms. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading rooms: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dodaj pokój"),
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Numer pokoju",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      roomNumber = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Nazwa pokoju",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      roomName = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 100,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Opis pokoju",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  expands: true,
                  onChanged: (value) {
                    setState(() {
                      roomDescription = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: _addRoom,
                label: const Text('Dodaj'),
                icon: const Icon(Icons.add),
              ),
              const SizedBox(height: 15),
              // ListView to display available rooms
              const Text(
                "Dostępne pokoje:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                height: 400,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          "${rooms[index].roomNumber} - ${rooms[index].name}"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addRoom() async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/rooms/create/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'room_number': roomNumber,
          'name': roomName,
          'description': roomDescription,
        }),
      );
      if (response.statusCode == 201) {
        // Refresh the list of rooms after adding a new room
        _fetchRooms();
        // Handle success
        print('Room added successfully');
      } else {
        // Handle failure
        print('Failed to add room');
      }
    } catch (e) {
      // Handle network error
      print('Network error: $e');
    }
  }
}

// Model Room
class Room {
  final String roomNumber;
  final String name;

  Room({required this.roomNumber, required this.name});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomNumber: json['room_number'],
      name: json['name'],
    );
  }
}
