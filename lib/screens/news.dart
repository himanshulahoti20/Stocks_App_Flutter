import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:stock_app/models/news_model.dart';
import 'package:stock_app/screens/web_view_screen.dart';
import 'package:stock_app/services/api.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

Future<List<NewsModel>> fetchCurrentNews() async {
  final String url = API.newUrl;
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> jsonValue = json.decode(response.body);
    return jsonValue.map((json) => NewsModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsModel>>(
      future: fetchCurrentNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No data found');
        }

        var details = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 8),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var news = details[index];

              return ListTile(
                onTap: () {
                 Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: news.url ?? '',
                        title: news.headline ?? 'News',
                      ),
                    ),
                  );
                },
                trailing: Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(news.image ?? 'https://via.placeholder.com/150'),
                      fit: BoxFit.fill,
                      ),
                  ),
                ),
                title: Text(
                  news.headline ?? 'No Headline',
                  style: GoogleFonts.roboto(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  news.summary ?? '',
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 12, fontWeight: FontWeight.normal),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
