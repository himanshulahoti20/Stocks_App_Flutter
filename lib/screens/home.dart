import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:stock_app/models/company_details.dart';
import 'package:stock_app/screens/favourite.dart';
import 'package:stock_app/screens/news.dart';
import 'package:stock_app/services/api.dart';
import 'package:stock_app/widgets/main_drawer.dart';
import 'package:stock_app/widgets/stock.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  Widget _buildAppBarTitle() {
    if (_isSearching) {
      return TextField(
        controller: _searchController,
        autocorrect: false,
        autofocus: true,
        style: const TextStyle(color: Colors.black, fontSize: 18),
        decoration: const InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.black38),
          border: InputBorder.none,
        ),
        onChanged: _onSearchTextChanged,
      );
    } else {
      switch (_selectedIndex) {
        case 0:
          return const Text('Flutter Stocks');
        case 1:
          return const Text('Favorites');
        case 2:
          return const Text('News');
        default:
          return const Text('Flutter Stocks');
      }
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const Stock();
      case 1:
        return const FavouriteScreen();
      case 2:
        return const NewsScreen();
      default:
        return const Stock(); // Default to Stock screen
    }
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  void _onSearchTextChanged(String text) {
    fetchCompanyDetails(text);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<CompanyDetails> fetchCompanyDetails(String symbol) async {
    final String url = API.symbolUrl + 'symbol$symbol';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 226, 9, 226),
        title:_buildAppBarTitle(),
        actions: _selectedIndex == 0
            ? [
                _isSearching
                    ? IconButton(
                        onPressed: _stopSearch,
                        icon: const Icon(Icons.clear),
                      )
                    : IconButton(
                        onPressed: _startSearch,
                        icon: const Icon(Icons.search),
                      ),
              ]
            : [],
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Stocks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 10,
          right: 10,
          left: 10,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(
                  _selectedIndex == 0
                      ? 'Stocks'
                      : _selectedIndex == 1
                          ? 'Favorites'
                          : _selectedIndex == 2
                              ? 'News'
                              : 'Profile',
                  textAlign: TextAlign
                      .center, // Update section title based on selected tab
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child:_buildBody(),
            ),
          ],
        ),
      ),
    );
  }
}
