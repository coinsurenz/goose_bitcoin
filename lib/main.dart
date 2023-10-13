import 'package:flutter/material.dart';
import 'package:goose_bitcoin/app/app.dart';

void main() {
  runApp(const BitcoinApp());
}

class BitcoinApp extends StatelessWidget {
  const BitcoinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: App(),
    );
  }
}
