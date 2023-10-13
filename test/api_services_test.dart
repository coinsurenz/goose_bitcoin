import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:goose_bitcoin/services/app_services.dart';
import 'package:goose_bitcoin/models/price_data.dart';
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('Bitcoin Price Service Integration Tests', () {
    final apiProvider = ApiService();
    test('Fetch current Bitcoin price', () async {
      final fakeResponse = [
        26743,
        112.60307397,
        26744,
        15.38938318,
        -670,
        -0.02444007,
        26744,
        1865.46310079,
        27498,
        26562
      ];
      apiProvider.client = MockClient((request) async {
        return Response(json.encode(fakeResponse), 200);
      });
      final lastPriceString = await apiProvider.fetchPrice();
      expect(lastPriceString, fakeResponse[6].toString());
    });

    test('Throw error on failure when fetching current Bitcoin price',
        () async {
      const fakeResponse = 'Fake error';
      const errorMessage = 'Failed to load current Bitcoin price';
      apiProvider.client = MockClient((request) async {
        return Response(json.encode(fakeResponse), 400);
      });
      expect(() async {
        await apiProvider.fetchPrice();
      },
          throwsA(
            allOf(isA<Exception>(),
                predicate((e) => e.toString() == 'Exception: $errorMessage')),
          ));
    });

    test('Fetch Bitcoin price history for the past week', () async {
      final mockResponse = [
        [1696982400000, 27425, 26741, 27492, 26562, 1837.85552988],
        [1696896000000, 27624, 27414, 27752, 27325, 1274.53314975],
      ];
      apiProvider.client = MockClient((request) async {
        return Response(json.encode(mockResponse), 200);
      });
      final historyList = await apiProvider.fetchPriceHistory();

      expect(historyList[0].timestamp, mockResponse[0][0]);
      expect(historyList[0].price, mockResponse[0][2]);
      expect(historyList[1].timestamp, mockResponse[1][0]);
      expect(historyList[1].price, mockResponse[1][2]);
    });

    test('Throw error on failure when fetching Bitcoin price history',
        () async {
      const fakeResponse = 'Fake error';
      const errorMessage = 'Failed to load Bitcoin price history';
      apiProvider.client = MockClient((request) async {
        return Response(json.encode(fakeResponse), 400);
      });
      expect(() async {
        await apiProvider.fetchPriceHistory();
      },
          throwsA(
            allOf(
              isA<Exception>(),
              predicate((e) => e.toString() == 'Exception: $errorMessage'),
            ),
          ));
    });
  });
}
