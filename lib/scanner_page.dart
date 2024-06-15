import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'config.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key, required this.username});
  final String username;

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final http.Client httpClient = http.Client();
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  String result = "";

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR skaner"),
        backgroundColor: const Color.fromARGB(255, 221, 206, 69),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Zeskanowany eksponat $result",
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final Uri url = Uri.parse(result);

                    if (result.isNotEmpty) {
                      String exhibitName = Uri.decodeFull(url.pathSegments.last);
                      String username = widget.username;
                      // Send exhibit name and username to backend
                      final response = await httpClient.post(
                        Uri.parse('${AppConfig.baseUrl}/api/users/$username/exhibits/$exhibitName/'),
                      );

                      if (response.statusCode == 200) {
                        // Handle success
                      } else {
                        // Handle failure
                      }
                    }
                  },
                  label: const Text("Dodaj"),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}