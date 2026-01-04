import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // ✅ Import dotenv

class ChatbotService {
  static const String _baseUrl = "https://api.groq.com/openai/v1/chat/completions";

  // 🧠 SYSTEM PROMPT: Teaches the AI about your app
  static const String _systemPrompt = """
You are the AI Assistant for 'Bill Buddy', a smart expense tracker app.
Your goal is to help users navigate the app and provide brief, practical financial advice.

**APP KNOWLEDGE BASE:**
1. **Home Screen:** Shows Dashboard (Graphs, Monthly/Weekly/Daily stats) and Transaction List.
   - Users can filter transactions by Date (Month/All Time) and Category.
   - To view details: Tap any transaction card.
2. **Add Expense:** accessible via the FAB (QR Icon). Supports Manual Entry or scanning.
3. **Deleting Transactions:** Go to Transaction Details -> Click 'Delete Transaction' -> Confirm dialog.
4. **Settings:** Dark Mode, Currency (₹, \$, €, £), Manage Custom Tags, Contact Support.

**CURRENT LIMITATIONS (Important):**
- **PDF Export:** NOT available yet. Tell users: "We will add PDF export soon!"
- **Bank Sync:** NOT available. Expenses must be added manually or via scan.

**RESPONSE GUIDELINES:**
- Keep answers **concise** (under 150 words) to save tokens.
- If asked about financial advice (e.g., "How to save money?"), give 3-4 bullet points max.
- Be friendly, professional, and motivating.
""";

  Future<String> getResponse(String userMessage) async {
    try {
      // ✅ 1. Get API Key from .env
      final apiKey = dotenv.env['GROQ_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty) {
        return "Error: API Key is missing. Please check your .env file.";
      }

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey', // ✅ Use the secure key
        },
        body: jsonEncode({
          "model": "llama-3.1-8b-instant",
          "messages": [
            {"role": "system", "content": _systemPrompt},
            {"role": "user", "content": userMessage}
          ],
          "temperature": 0.7,
          "max_tokens": 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        return "Error: ${response.statusCode}. Please try again later.";
      }
    } catch (e) {
      return "Network error. Please check your internet connection.";
    }
  }
}