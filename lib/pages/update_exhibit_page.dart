import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class UpdateExhibit extends StatefulWidget {
  const UpdateExhibit({Key? key}) : super(key: key);

  @override
  State<UpdateExhibit> createState() => _UpdateExhibitState();
}

class _UpdateExhibitState extends State<UpdateExhibit> {
  final GlobalKey globalKey = GlobalKey(debugLabel: "QR2");
  String selectedExhibitId = "";
  String qrData = "";
  String opis = "";
  String roomNumber = "";
  String points = "";
  List<Room> rooms = [];
  List<Exhibit> exhibits = [];

  @override
  void initState() {
    super.initState();
    _fetchRooms();
    _fetchExhibits();
  }

  Future<void> _fetchRooms() async {
    try {
      final response = await http.get(
          Uri.parse('${AppConfig.baseUrl}/api/rooms/'));
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

  Future<void> _fetchExhibits() async {
    try {
      final response = await http.get(
          Uri.parse('${AppConfig.baseUrl}/api/exhibits/'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        List<Exhibit> fetchedExhibits =
        data.map<Exhibit>((json) => Exhibit.fromJson(json)).toList();

        setState(() {
          exhibits = fetchedExhibits;
        });
        print('Exhibits loaded successfully: $exhibits');
      } else {
        print('Failed to load exhibits. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading exhibits: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aktualizuj eksponat"),
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "ID",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedExhibitId = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
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
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Punkty eksponatu",
                    border: OutlineInputBorder(),
                    labelText: "Punkty (domyślnie 1)",
                  ),
                  keyboardType: TextInputType.number,
                  // Dodatkowo ustal typ klawiatury
                  onChanged: (value) {
                    setState(() {
                      points = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
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
                onPressed: _updateExhibit,
                label: const Text('Zmień'),
                icon: const Icon(Icons.add),
              ),
              const SizedBox(height: 15),
              const Text(
                "Dostępne eksponaty:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                "(ID, nazwa (punkty) - pokój)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: exhibits.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        "${exhibits[index].id}. ${exhibits[index]
                            .name} (${exhibits[index]
                            .points}) - ${exhibits[index].roomNumber}",
                      ),
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

  Future<void> _updateExhibit() async {
    if (rooms.any((room) => room.roomNumber == roomNumber)) {
      try {
        final exhibitData = {
          'id': selectedExhibitId,
          'name': qrData,
          'description': opis,
          'points': int.tryParse(points) ?? 1,
          'room': roomNumber,
        };

        print('Sending request with data: $exhibitData');

        final response = await http.put(
          Uri.parse('${AppConfig.baseUrl}/api/exhibits/$selectedExhibitId/'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(exhibitData),
        );

        if (response.statusCode == 200) {
          print('Exhibit updated successfully');
        } else {
          print(
              'Failed to update exhibit. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Network error: $e');
      }
    } else {
      print('Invalid room number: $roomNumber');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pokój z numerem $roomNumber nie istnieje."),
        ),
      );
    }
  }
}

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

class Exhibit {
  final int id;
  final String name;
  final int points;
  final String roomNumber;

  Exhibit({required this.id, required this.name, required this.points, required this.roomNumber});

  factory Exhibit.fromJson(Map<String, dynamic> json) {
    return Exhibit(
      id: json['id'],
      name: json['name'],
      points: json['points'],
      roomNumber: json['room'],
    );
  }
}
