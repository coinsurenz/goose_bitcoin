import 'package:flutter/material.dart';

class BitcoinBuyForm extends StatefulWidget {
  final String dollarAmount;
  final ValueChanged<String> onAmountChanged;
  final VoidCallback onBuyPressed;

  const BitcoinBuyForm({
    super.key,
    required this.dollarAmount,
    required this.onAmountChanged,
    required this.onBuyPressed
  });

  @override
  State<BitcoinBuyForm> createState() => _BitcoinBuyFormState();
}

class _BitcoinBuyFormState extends State<BitcoinBuyForm> {
  String hintText = "Enter \$ amount to buy";

  void onClick() {
    if (double.tryParse(widget.dollarAmount) == null) {
      setState(() {
        hintText = "Check your input";
      });
    }
    widget.onBuyPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Enter \$ amount to buy',
            style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 20),
          ),
          const SizedBox(height: 20),
          FractionallySizedBox(
            widthFactor: 0.6,
            child: Stack(
              alignment:
                  Alignment.centerRight,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.0,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    onChanged: widget.onAmountChanged,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color:
                            hintText == "Check your input" ? Colors.red : null,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (hintText == "Check your input")
                  const Positioned(
                    right: 10,
                    child: Material(
                      color: Color(0xFFF44336),
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Invalid input',
                          style: TextStyle(color: Colors.white
                          )
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onClick,
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );
  }
}
