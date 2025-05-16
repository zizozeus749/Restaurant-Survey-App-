import 'package:flutter/material.dart';

class ThankYouPage extends StatelessWidget {
  final String userName;

  const ThankYouPage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sentiment_satisfied_alt,
                size: 120,
                color: Color(0xFFFFB300),
              ),
              const SizedBox(height: 30),
              Text(
                'Thank you, $userName!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFB300),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Text(
                'We appreciate your visit to our restaurant.\nHope to see you again soon!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFB300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
