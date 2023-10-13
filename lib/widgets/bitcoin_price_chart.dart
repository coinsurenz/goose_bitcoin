import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:goose_bitcoin/models/price_data.dart';

class BitcoinPriceChart extends StatelessWidget {
  final String currentPrice;
  final List<PricePoint> priceHistory;
  final double oneDayinUnix = 86400000;

  const BitcoinPriceChart({
    super.key,
    required this.currentPrice,
    required this.priceHistory,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final boxHeight = screenHeight * 0.2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Column(
                  children: [
                    Text('Current Bitcoin Price: \$$currentPrice',
                        style: const TextStyle(
                            color: Color(0xFFCCCCCC), fontSize: 25)),
                    const SizedBox(height: 20),
                    Card(
                      color: const Color(0xFFCECECE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: Column(
                        children: [
                          const Text('Bitcoin Price History for the Past Week:',
                              style: TextStyle(fontSize: 15)),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              height: boxHeight,
                              child: LineChart(
                                LineChartData(
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  gridData: FlGridData(
                                    show: false,
                                  ),
                                  titlesData: FlTitlesData(
                                    bottomTitles: SideTitles(
                                      showTitles: true,
                                      interval: oneDayinUnix,
                                      getTextStyles: (BuildContext context,
                                          double value) {
                                        return const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        );
                                      },
                                      margin: 15,
                                      getTitles: (double value) {
                                        return timeStampToDate(value.toInt());
                                      },
                                    ),
                                    leftTitles: SideTitles(
                                      showTitles: true,
                                      interval: chartInterval(priceHistory),
                                      getTextStyles: (BuildContext context,
                                          double value) {
                                        return const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        );
                                      },
                                      margin: 15,
                                      getTitles: (double value) {
                                        final roundedValue =
                                            (value / 1000).toStringAsFixed(1);
                                        return "$roundedValue K";
                                      },
                                    ),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: flChartData(priceHistory),
                                      isCurved: true,
                                      colors: const [Color(0xFF002C7E)],
                                      dotData: FlDotData(show: false),
                                      belowBarData: BarAreaData(show: false),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String timeStampToDate(int timestamp) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return '${dateTime.day}-${dateTime.month}';
}

List<FlSpot> flChartData(List<PricePoint> priceHistoryList) {
  return priceHistoryList.map((item) {
    final timestamp = item.timestamp;
    final price = item.price;
    return FlSpot(timestamp, price);
  }).toList();
}

double chartInterval(List<PricePoint> prices) {
  final lowestPrice = prices.reduce((curr, next) {
    if (curr.price < next.price) {
      return curr;
    } else {
      return next;
    }
  });

  final highestPrice = prices.reduce((curr, next) {
    if (curr.price > next.price) {
      return curr;
    } else {
      return next;
    }
  });
  return ((highestPrice.price - lowestPrice.price) / 5);
}
