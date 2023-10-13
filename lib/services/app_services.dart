import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:goose_bitcoin/models/price_data.dart';

class ApiService {
  Client client = Client();

  Future<String> fetchPrice() async {
    // Fetch current Bitcoin price
    // https://docs.bitfinex.com/reference/rest-public-ticker
    final currentPriceResponse = await client
        .get(Uri.parse('https://api.bitfinex.com/v2/ticker/tBTCUSD'));

    if (currentPriceResponse.statusCode == 200) {
      final currentPriceData = json.decode(currentPriceResponse.body);
      final lastPrice = currentPriceData[6];

      return lastPrice.toString();
    } else {
      throw Exception('Failed to load current Bitcoin price');
    }
  }

  Future<List<PricePoint>> fetchPriceHistory() async {
    // Fetch Bitcoin price history for the past week
    // https://docs.bitfinex.com/reference/rest-public-candles
    final historyResponse = await client.get(Uri.parse(
        'https://api.bitfinex.com/v2/candles/trade:1D:tBTCUSD/hist?limit=7'));

    if (historyResponse.statusCode == 200) {
      final historyData = json.decode(historyResponse.body);
      final List<PricePoint> historyList = (historyData as List).map((item) {
        return PricePoint.fromJson(item);
      }).toList();
      return historyList;
    } else {
      throw Exception('Failed to load Bitcoin price history');
    }
  }
}
