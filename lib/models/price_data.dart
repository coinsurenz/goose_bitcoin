class PricePoint {
  final double timestamp;
  final double price;

  PricePoint({required this.timestamp, required this.price});

  factory PricePoint.fromJson(List<dynamic> data) {
    if (data.length != 6) {
      throw ArgumentError('Invalid data format');
    }

    return PricePoint(
      timestamp: (data[0] as int).toDouble(),
      price: (data[2] as int).toDouble(),
    );
  }

  static List<PricePoint> listFromJson(List<dynamic> jsonData) {
    return jsonData.map((data) => PricePoint.fromJson(data)).toList();
  }
}
