import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'config.dart';

class AddExhibit extends StatefulWidget {
  const AddExhibit({super.key});

  @override
  State<AddExhibit> createState() => _AddExhibitState();
}

class _AddExhibitState extends State<AddExhibit> {
  final GlobalKey globalKey = GlobalKey(debugLabel: "QR2");
  String qrData = "";
  String opis = "";
  String roomNumber = "";
  String points = ""; // Nowa zmienna do przechowywania liczby punktów
  List<Room> rooms = []; // Zaktualizowana lista pokojów

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/rooms/'));
      if (response.statusCode == 200) {
        // Ensure that the response body is decoded in UTF-8
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
        title: const Text("Dodaj eksponat"),
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              RepaintBoundary(
                key: globalKey,
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Nazwa",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      qrData = value;
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
                    hintText: "Opis",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  expands: true,
                  onChanged: (value) {
                    setState(() {
                      opis = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              // TextField for entering points
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Punkty eksponatu",
                    border: OutlineInputBorder(),
                    labelText: "Punkty (domyślnie 1)",
                  ),
                  keyboardType: TextInputType.number, // Dodatkowo ustal typ klawiatury
                  onChanged: (value) {
                    setState(() {
                      points = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              // TextField for entering room number
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Numer pokoju",
                    border: OutlineInputBorder(),
                    labelText: "Numer pokoju (Wprowadź numer)",
                  ),
                  onChanged: (value) {
                    setState(() {
                      roomNumber = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: _addExhibit,
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
                height: 200,
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

  Future<void> _addExhibit() async {
    // Before sending, ensure that the room number exists
    if (rooms.any((room) => room.roomNumber == roomNumber)) {
      try {
        final exhibitData = {
          'name': qrData,
          'description': opis,
          'points': int.tryParse(points) ?? 1, // Uwzględnione punkty, domyślnie 1 jeśli jest brak lub błędne dane
          'room': roomNumber, // Uwzględnij wpisany numer pokoju
        };

        print('Sending request with data: $exhibitData');

        final response = await http.post(
          Uri.parse('${AppConfig.baseUrl}/api/exhibits/create/'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(exhibitData),
        );

        if (response.statusCode == 201) {
          print('Exhibit added successfully');
        } else {
          print('Failed to add exhibit. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Network error: $e');
      }
    } else {
      print('Invalid room number: $roomNumber');
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Pokój z numerem $roomNumber nie istnieje."),
      ));
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
