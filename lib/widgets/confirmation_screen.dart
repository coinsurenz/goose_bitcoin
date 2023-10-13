import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  final String bitcoinAmount;
  final VoidCallback onBuyPressed;
  final VoidCallback onBack;

  const ConfirmationScreen({
    super.key,
    required this.bitcoinAmount,
    required this.onBuyPressed,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Confirm you want to buy $bitcoinAmount Bitcoin?',
            style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 20),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: onBuyPressed,
                child: const Text('Buy Now'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFF44336)),
                ),
                onPressed: onBack,
                child: const Text('Go Back'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
