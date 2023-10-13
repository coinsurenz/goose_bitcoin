import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String message;
  final VoidCallback onClick;
 

  const SuccessScreen({
    super.key,
    required this.message,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final boxHeight = screenHeight * 0.6;
    return Center(
      child: SizedBox(
        height: boxHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 18),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                onClick();
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
