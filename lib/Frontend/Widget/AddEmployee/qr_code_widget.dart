import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWidget extends StatelessWidget {
  const QrCodeWidget({super.key, required this.data, required int size});

  final String data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: 250,
        padding: const EdgeInsets.all(10),

        backgroundColor: Colors.white,

        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Colors.black,
        ),

        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Colors.black,
        ),

        errorCorrectionLevel: QrErrorCorrectLevel.M,
      ),
    );
  }
}
