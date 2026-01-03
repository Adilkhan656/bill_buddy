import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Optional, or use Icon

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Assistant")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.smart_toy_rounded, size: 80, color: Theme.of(context).primaryColor.withOpacity(0.5)),
            const SizedBox(height: 20),
            const Text(
              "AI Chatbot Coming Soon!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Ask about your spending habits\nand get financial advice.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}