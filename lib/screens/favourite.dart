import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_app/providers/favourite_stocks_provider.dart';
import 'package:stock_app/screens/stock_details.dart';

class FavouriteScreen extends ConsumerWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteStocks = ref.watch(favouriteStocksProvider);

    Widget content = Center(
      child: Text(
        'No Favorites Added yet!',
        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );

    if (favoriteStocks.isNotEmpty) {
      content = ListView.builder(
        itemCount: favoriteStocks.length,
        itemBuilder: (context, index) {
          final symbol = favoriteStocks[index];
          return ListTile(
            title: Text(symbol),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StockDetailsScreen(
                    symbol: symbol,
                    description: symbol, // Replace with actual description
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      body: content,
    );
  }
}
