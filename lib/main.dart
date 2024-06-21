import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_app/screens/launch.dart';

void main() {
  runApp(
    const ProviderScope(
      child:  MyApp(),
    ),
  );
}

//W5URAX0WNISEPCU8

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Stocks',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 10, 132, 213),
          ),
          useMaterial3: true,
        ),
        home: const LaunchScreen());
  }
}
