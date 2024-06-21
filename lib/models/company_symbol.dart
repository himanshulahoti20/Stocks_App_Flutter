class CompanySymbol {
  final String symbol;
  final String description;

  CompanySymbol({required this.symbol, required this.description});

  factory CompanySymbol.fromJson(Map<String, dynamic> json) {
    return CompanySymbol(
      symbol: json['symbol'],
      description: json['description'],
    );
  }
}
