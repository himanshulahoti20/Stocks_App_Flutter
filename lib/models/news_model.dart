class NewsModel {
  Category? category;
  int? datetime;
  String? headline;
  int? id;
  String? image;
  String? related;
  Source? source;
  String? summary;
  String? url;
  String? companySymbol; // Added field for company symbol

  NewsModel({
    this.category,
    this.datetime,
    this.headline,
    this.id,
    this.image,
    this.related,
    this.source,
    this.summary,
    this.url,
    this.companySymbol,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      category: _parseCategory(json['category']),
      datetime: json['datetime'],
      headline: json['headline'],
      id: json['id'],
      image: json['image'],
      related: json['related'],
      source: _parseSource(json['source']),
      summary: json['summary'],
      url: json['url'],
      companySymbol: json['companySymbol'], // Parse company symbol from JSON
    );
  }

  static Category? _parseCategory(String? category) {
    switch (category?.toUpperCase()) {
      case 'BUSINESS':
        return Category.BUSINESS;
      case 'TOP_NEWS':
        return Category.TOP_NEWS;
      default:
        return null;
    }
  }

  static Source? _parseSource(String? source) {
    switch (source?.toUpperCase()) {
      case 'BLOOMBERG':
        return Source.BLOOMBERG;
      case 'CNBC':
        return Source.CNBC;
      case 'MARKET_WATCH':
        return Source.MARKET_WATCH;
      default:
        return null;
    }
  }
}

enum Category {
  BUSINESS,
  TOP_NEWS
}

enum Source {
  BLOOMBERG,
  CNBC,
  MARKET_WATCH
}
