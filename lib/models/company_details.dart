class CompanyDetails {
  final double currentPrice;
  final double change;
  final double percentChange;

  CompanyDetails({
    required this.currentPrice,
    required this.change,
    required this.percentChange,
  });

  factory CompanyDetails.fromJson(Map<String, dynamic> json) {
    return CompanyDetails(
      currentPrice: (json['c'] ?? 0).toDouble(),
      change: (json['d'] ?? 0).toDouble(),
      percentChange: (json['dp'] ?? 0).toDouble(),
    );
  }
}
