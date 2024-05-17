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
  String qrData = "213";
  String opis = "";

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
              ElevatedButton.icon(
                onPressed: _addExhibit,
                label: const Text('Dodaj'),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addExhibit() async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/exhibits/create/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': qrData,
          'description': opis,
        }),
      );
      if (response.statusCode == 201) {
        // Handle success
        print('Exhibit added successfully');

        // Save QR code image
        await _saveQrImage();
      } else {
        // Handle failure
        print('Failed to add exhibit');
      }
    } catch (e) {
      // Handle network error
      print('Network error: $e');
    }
  }

  Future<void> _saveQrImage() async {
    try {
      RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      await ImageGallerySaver.saveImage(pngBytes);
      print('QR code image saved successfully');
    } catch (e) {
      print('Failed to save QR code image: $e');
    }
  }
}
