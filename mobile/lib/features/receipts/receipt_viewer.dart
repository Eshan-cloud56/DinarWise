import 'dart:io';

import 'package:flutter/material.dart';

class ReceiptViewer extends StatelessWidget {
  const ReceiptViewer({required this.filePath, super.key});

  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5,
          child: Center(child: Image.file(File(filePath))),
        ),
      ),
    );
  }
}
