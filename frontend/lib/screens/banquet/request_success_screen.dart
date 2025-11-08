import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class RequestSuccessScreen extends StatelessWidget {
  const RequestSuccessScreen({super.key});

  static const routeName = '/request-success';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Request Submitted'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Icon(
              Icons.check_circle_outline,
              size: 96,
              color: Color(0xFF2E7D32),
            ),
            const SizedBox(height: 24),
            const Text(
              'Success!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your banquet & venue request has been submitted. You will receive responses soon.',
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeScreen.routeName,
                    (route) => false,
                  );
                },
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

