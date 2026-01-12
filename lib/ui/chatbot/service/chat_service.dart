// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart'; // ✅ Import dotenv

// class ChatbotService {
//   static const String _baseUrl = "https://api.groq.com/openai/v1/chat/completions";

//   // 🧠 SYSTEM PROMPT: Teaches the AI about your app
//   static const String _systemPrompt = """
// You are the AI Assistant for 'Bill Buddy', a smart expense tracker app.
// Your goal is to help users navigate the app and provide brief, practical financial advice.

// **APP KNOWLEDGE BASE:**
// 1. **Home Screen:** Shows Dashboard (Graphs, Monthly/Weekly/Daily stats) and Transaction List.
//    - Users can filter transactions by Date (Month/All Time) and Category.
//    - To view details: Tap any transaction card.
// 2. **Add Expense:** accessible via the FAB (QR Icon). Supports Manual Entry or scanning.
// 3. **Deleting Transactions:** Go to Transaction Details -> Click 'Delete Transaction' -> Confirm dialog.
// 4. **Settings:** Dark Mode, Currency (₹, \$, €, £), Manage Custom Tags, Contact Support.

// **CURRENT LIMITATIONS (Important):**
// - **PDF Export:** NOT available yet. Tell users: "We will add PDF export soon!"
// - **Bank Sync:** NOT available. Expenses must be added manually or via scan.

// **RESPONSE GUIDELINES:**
// - Keep answers **concise** (under 150 words) to save tokens.
// - If asked about financial advice (e.g., "How to save money?"), give 3-4 bullet points max.
// - Be friendly, professional, and motivating.
// """;

//   Future<String> getResponse(String userMessage) async {
//     try {
//       // ✅ 1. Get API Key from .env
//       final apiKey = dotenv.env['GROQ_API_KEY'];
      
//       if (apiKey == null || apiKey.isEmpty) {
//         return "Error: API Key is missing. Please check your .env file.";
//       }

//       final response = await http.post(
//         Uri.parse(_baseUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $apiKey', // ✅ Use the secure key
//         },
//         body: jsonEncode({
//           "model": "llama-3.1-8b-instant",
//           "messages": [
//             {"role": "system", "content": _systemPrompt},
//             {"role": "user", "content": userMessage}
//           ],
//           "temperature": 0.7,
//           "max_tokens": 500,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data['choices'][0]['message']['content'].toString().trim();
//       } else {
//         return "Error: ${response.statusCode}. Please try again later.";
//       }
//     } catch (e) {
//       return "Network error. Please check your internet connection.";
//     }
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart'; 

// class ChatbotService {
//   static const String _baseUrl = "https://api.groq.com/openai/v1/chat/completions";

//   // 🧠 SYSTEM PROMPT: Updated with Pie Chart & Budget Analytics info
//   static const String _systemPrompt = """
// You are the AI Assistant for 'Bill Buddy', a smart expense tracker app.
// Your goal is to help users navigate the app and provide brief, practical financial advice.

// **APP KNOWLEDGE BASE:**
// 1. **Home Screen (Dashboard):** - Features a **Pie Chart** to visualize spending by category.
//    - Shows "Total Spent", "Weekly Average", and "Daily Average".
//    - Users can filter transactions by Date (Specific Month or All Time) and Category.
   
// 2. **Budget & Analytics Screen:**
//    - **Spending Trends:** Displays a **Line Chart** with interactive **tooltips**.
//      - Blue line = Daily Spend.
//      - Red line = Weekly Trend.
//    - **Budget Limits:** Users can set monthly limits for specific categories (e.g., Food = ₹5000).
//    - **Smart Warnings:** Progress bars change color:
//      - 🟢 Green: Safe (< 70%)
//      - 🟠 Orange: Warning (70% - 99%)
//      - 🔴 Red: Exceeded (100%+)
//      - Users can slide-to-delete budgets or long-press to edit them.

// 3. **Add Expense:** Accessible via the FAB (QR Icon). Supports Manual Entry.
// 4. **Settings:** Dark Mode, Currency (₹, \$, €, £), Manage Custom Tags, Contact Support.

// **CURRENT LIMITATIONS (Important):**
// - **PDF Export:** NOT available yet. Tell users: "We will add PDF export soon!"
// - **Bank Sync:** NOT available. Expenses must be added manually.

// **RESPONSE GUIDELINES:**
// - Keep answers **concise** (under 150 words) to save tokens.
// - If asked about financial advice, give 3-4 bullet points max.
// - Be friendly, professional, and motivating.
// """;

//   Future<String> getResponse(String userMessage) async {
//     try {
//       final apiKey = dotenv.env['GROQ_API_KEY'];
      
//       if (apiKey == null || apiKey.isEmpty) {
//         return "Error: API Key is missing. Please check your .env file.";
//       }

//       final response = await http.post(
//         Uri.parse(_baseUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $apiKey', 
//         },
//         body: jsonEncode({
//           "model": "llama-3.1-8b-instant",
//           "messages": [
//             {"role": "system", "content": _systemPrompt},
//             {"role": "user", "content": userMessage}
//           ],
//           "temperature": 0.7,
//           "max_tokens": 500,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data['choices'][0]['message']['content'].toString().trim();
//       } else {
//         return "Error: ${response.statusCode}. Please try again later.";
//       }
//     } catch (e) {
//       return "Network error. Please check your internet connection.";
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

class ChatbotService {
  static const String _baseUrl = "https://api.groq.com/openai/v1/chat/completions";

  // 🧠 SYSTEM PROMPT: Updated with PDF Export Features
  static const String _systemPrompt = """
You are the AI Assistant for 'Bill Buddy', a smart expense tracker app.
Your goal is to help users navigate the app and provide brief, practical financial advice.

**APP KNOWLEDGE BASE:**
1. **Home Screen (Dashboard):** - Features a **Pie Chart** to visualize spending by category.
   - Shows "Total Spent", "Weekly Average", and "Daily Average".
   - Users can filter transactions by Date (Period) and Category.

2. **Budget & Analytics Screen:**
   - **Spending Trends:** Displays a **Line Chart** with interactive tooltips.
   - **Budget Limits:** Users can set monthly limits (e.g., Food = ₹5000).
   - **Smart Warnings:** 🟢 Safe (<70%), 🟠 Warning (70-99%), 🔴 Exceeded (100%+).
   - **Actions:** Slide-to-delete or Long-press to edit budgets.

3. **PDF Exports (New!):**
   - **Single Receipt:** Tap any transaction to view details -> Tap the **Print Icon** (top right) to download a detailed bill.
   - **Lifetime Report:** Go to **Settings** -> Tap **"Export Lifetime Data"** to download a full financial report with charts.

4. **Settings:** Dark Mode, Currency (₹, \$, €, £), Manage Custom Tags, Contact Support.

**CURRENT LIMITATIONS (Important):**
- **Bank Sync:** NOT available. Expenses must be added manually.
- **Cloud Backup:** Data is stored locally on the device (mostly).

**RESPONSE GUIDELINES:**
- Keep answers **concise** (under 150 words).
- If asked about financial advice, give 3-4 bullet points max.
- Be friendly, professional, and motivating.
""";

  Future<String> getResponse(String userMessage) async {
    try {
      final apiKey = dotenv.env['GROQ_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty) {
        return "Error: API Key is missing. Please check your .env file.";
      }

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey', 
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