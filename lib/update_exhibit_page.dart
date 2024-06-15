import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'config.dart';
import 'add_exhibit_page.dart'; // Assuming Room class is defined here

class UpdateExhibit extends StatefulWidget {
  final String exhibitId;
  final String initialQrData;
  final String initialOpis;
  final String initialPoints;
  final String initialRoomNumber;

  const UpdateExhibit({
    Key? key,
    required this.exhibitId,
    required this.initialQrData,
    required this.initialOpis,
    required this.initialPoints,
    required this.initialRoomNumber,
  }) : super(key: key);

  @override
  State<UpdateExhibit> createState() => _UpdateExhibitState();
}

class _UpdateExhibitState extends State<UpdateExhibit> {
  final GlobalKey globalKey = GlobalKey(debugLabel: "QR2");
  late String qrData;
  late String opis;
  late String points;
  late String roomNumber;
  List<Room> rooms = [];

  @override
  void initState() {
    super.initState();
    qrData = widget.initialQrData;
    opis = widget.initialOpis;
    points = widget.initialPoints;
    roomNumber = widget.initialRoomNumber;
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
        title: const Text("Edytuj eksponat"),
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
                  controller: TextEditingController(text: qrData),
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
                  controller: TextEditingController(text: opis),
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
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Punkty eksponatu",
                    border: OutlineInputBorder(),
                    labelText: "Punkty (domyślnie 1)",
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: points),
                  onChanged: (value) {
                    setState(() {
                      points = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Numer pokoju",
                    border: OutlineInputBorder(),
                    labelText: "Numer pokoju (Wprowadź numer)",
                  ),
                  controller: TextEditingController(text: roomNumber),
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
                label: const Text('Zaktualizuj'),
                icon: const Icon(Icons.update),
              ),
              const SizedBox(height: 15),
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

  Future<void> _updateExhibit() async {
    // Ensure the room number exists
    if (rooms.any((room) => room.roomNumber == roomNumber)) {
      try {
        final exhibitData = {
          'name': qrData,
          'description': opis,
          'points': int.tryParse(points) ?? 1,
          'room': roomNumber,
        };

        print('Sending update request with data: $exhibitData');

        final response = await http.put(
          Uri.parse('${AppConfig.baseUrl}/api/exhibits/${widget.exhibitId}/update/'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(exhibitData),
        );

        if (response.statusCode == 200) {
          print('Exhibit updated successfully');
          // Optionally, navigate back or show a success message
        } else {
          print('Failed to update exhibit. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Network error: $e');
      }
    } else {
      print('Invalid room number: $roomNumber');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Pokój z numerem $roomNumber nie istnieje."),
      ));
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
