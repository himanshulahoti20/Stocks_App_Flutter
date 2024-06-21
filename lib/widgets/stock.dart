import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_app/models/company_details.dart';
import 'package:stock_app/models/company_symbol.dart';
import 'package:stock_app/screens/stock_details.dart';
import 'package:stock_app/services/api.dart';

class Stock extends StatefulWidget {
  const Stock({super.key});

  @override
  State<Stock> createState() {
    return _StockState();
  }
}

class _StockState extends State<Stock> {
  Future<List<CompanySymbol>> fetchTopCompanies() async {
    final String url = API.companiesUrl;
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      print(jsonList);
      return jsonList.map((json) => CompanySymbol.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top companies');
    }
  }

  Future<CompanyDetails> fetchCompanyDetails(String symbol) async {
    final String url = API.symbolUrl + 'symbol=$symbol';
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonValue = json.decode(response.body);
      print(jsonValue);
      return CompanyDetails.fromJson(jsonValue);
    } else {
      throw Exception('Failed to load company details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CompanySymbol>>(
      future: fetchTopCompanies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data found'));
        }

        List<CompanySymbol> companies = snapshot.data!;

        return ListView.builder(
          itemCount: companies.length,
          itemBuilder: (context, index) {
            var company = companies[index];
            return FutureBuilder<CompanyDetails>(
              future: fetchCompanyDetails(company.symbol),
              builder: (context, detailsSnapshot) {
                if (detailsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return ListTile(
                    title: Text(company.description),
                    subtitle:const  Text('Loading details...'),
                  );
                } else if (detailsSnapshot.hasError) {
                  return ListTile(
                    title: Text(company.description),
                    subtitle: const Text('Error loading details'),
                  );
                } else if (!detailsSnapshot.hasData) {
                  return ListTile(
                    title: Text(company.description),
                    subtitle: const Text('No details available'),
                  );
                }

                var details = detailsSnapshot.data!;
                bool isPositive = details.change >= 0;

                return Card(
                  child: ListTile(
                    title: Text(company.description),
                    subtitle: Text(
                        '\$ ${details.currentPrice}\n ${details.percentChange}%'),
                    trailing: Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => StockDetailsScreen(
                              symbol: company.symbol,
                              description: company.description),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
