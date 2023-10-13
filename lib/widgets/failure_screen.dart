import 'package:flutter/material.dart';

class FailureScreen extends StatelessWidget {
  final String errorMessage;
  final Function() fetchAndRefresh;

  const FailureScreen(
      {super.key, required this.errorMessage, required this.fetchAndRefresh});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(errorMessage,
          style: const TextStyle(color: Color(0xFFF44336), fontSize: 20)),
      ElevatedButton(
        onPressed: () async {
          await fetchAndRefresh();
        },
        child: const Text('Reload'),
      )
    ]);
  }
}
