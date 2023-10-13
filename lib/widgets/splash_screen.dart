import 'package:flutter/material.dart';
import 'package:goose_bitcoin/widgets/bitcoin_price_chart.dart';
import 'package:goose_bitcoin/widgets/buy_button.dart';
import 'package:goose_bitcoin/widgets/failure_screen.dart';
import 'package:goose_bitcoin/models/price_data.dart';

class SplashScreen extends StatelessWidget {
  final void Function() fetchAndRefresh;
  final String errorMessage;
  final void Function() onBuyPressed;
  final List<PricePoint> priceHistory;
  final String currentPrice;

  const SplashScreen(
      {super.key,
      required this.fetchAndRefresh,
      required this.errorMessage,
      required this.onBuyPressed,
      required this.priceHistory,
      required this.currentPrice});

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
            if (errorMessage.isNotEmpty)
              FailureScreen(errorMessage: errorMessage, fetchAndRefresh: fetchAndRefresh)
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BitcoinPriceChart(
                    priceHistory: priceHistory,
                    currentPrice: currentPrice,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: BuyButton(onBuyPressed: onBuyPressed),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
