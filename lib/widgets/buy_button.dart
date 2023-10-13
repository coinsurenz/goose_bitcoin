import 'package:flutter/material.dart';

class BuyButton extends StatelessWidget {
  final void Function() onBuyPressed;

  const BuyButton({super.key, required this.onBuyPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          'Lets buy some Bitcoin!',
          style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 25),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            onBuyPressed();
          },
          child: const Text('Buy Bitcoin'),
        ),
      ],
    ));
  }
}
