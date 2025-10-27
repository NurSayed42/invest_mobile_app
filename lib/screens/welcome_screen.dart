import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const deepGreen = Color(0xFF006400); // Deep Green color

    return Scaffold(
      backgroundColor: Colors.white, // background white
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Investment Inspection and Monitoring System',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: deepGreen, // deep green title
                  ),
                ),
                const SizedBox(height: 16),

                // Subtitle
                const Text(
                  'Track investments and manage users',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: deepGreen),
                ),
                const SizedBox(height: 40),

                // Get Started Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: deepGreen, // button deep green
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // button text white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
