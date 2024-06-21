import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stock_app/screens/home.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stocks App'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/stock.json',
              width: 300,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Welcome to Stocks App',
              style: TextStyle(
                color: Color.fromARGB(255, 71, 10, 226),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const HomeScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 216, 192, 207),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
