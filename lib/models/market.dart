class Market {
  final String name;
  final String code;
  final String flag;
  final Currency currency;

  Market({
    required this.name,
    required this.code,
    required this.flag,
    required this.currency,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      name: json['name'],
      code: json['code'],
      flag: json['flag'],
      currency: Currency.fromJson(json['currency']),
    );
  }
}

class Currency {
  final String code;
  final String name;
  final String symbol;

  Currency({
    required this.code,
    required this.name,
    required this.symbol,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'],
      name: json['name'],
      symbol: json['symbol'],
    );
  }
}
