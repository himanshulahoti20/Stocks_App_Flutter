import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:stock_app/models/company_details.dart';
import 'package:stock_app/services/api.dart';
import 'package:stock_app/providers/favourite_stocks_provider.dart';

class StockDetailsScreen extends  ConsumerStatefulWidget{
  final String symbol;
  final String description;

  const StockDetailsScreen({
    super.key,
    required this.symbol,
    required this.description,
  });

  @override
  ConsumerState<StockDetailsScreen> createState() => _StockDetailsScreenState();
}

class _StockDetailsScreenState extends ConsumerState<StockDetailsScreen> {
  final String apiKey = API.apiKey;

  Future<List<FlSpot>> fetchStockHistory() async {
    final String url =
        'https://finnhub.io/api/v1/stock/candle?symbol=${widget.symbol}&resolution=D&from=1615298999&to=1646834999&token=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> closes = json['c'];
      List<dynamic> timestamps = json['t'];
      return List.generate(closes.length, (index) {
        return FlSpot(timestamps[index].toDouble(), closes[index].toDouble());
      });
    } else {
      throw Exception('Failed to load stock history');
    }
  }

  Future<CompanyDetails> fetchCompanyDetails() async {
    final String url =
        'https://finnhub.io/api/v1/quote?symbol=${widget.symbol}&token=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonValue = json.decode(response.body);
      return CompanyDetails.fromJson(jsonValue);
    } else {
      throw Exception('Failed to load company details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteStocks = ref.read(favouriteStocksProvider);

    bool _isFavorite = favoriteStocks.contains(widget.symbol);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.description),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_isFavorite) {
                  favoriteStocks.remove(widget.symbol);
                } else {
                  favoriteStocks.add(widget.symbol);
                }
                _isFavorite = !_isFavorite;
              });
            },
            icon: _isFavorite
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: FutureBuilder<CompanyDetails>(
        future: fetchCompanyDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No data found'),
            );
          }

          var details = snapshot.data!;
          bool isPositive = details.change >= 0;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.description,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text('Current Price: ${details.currentPrice}'),
                    subtitle: Text('Change: ${details.percentChange}%'),
                    trailing: Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<FlSpot>>(
                  future: fetchStockHistory(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: Text('No data found'),
                      );
                    }

                    List<FlSpot> spots = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: const Color(0xff37434d)),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 2,
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}