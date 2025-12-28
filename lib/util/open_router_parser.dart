import 'dart:convert';
import 'package:bill_buddy/util/recipt_logic.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
 // Make sure this path is correct

class OpenRouterParser {
  static Future<ReceiptData> parse(String rawText) async {
    final apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? "";
    const apiUrl = "https://openrouter.ai/api/v1/chat/completions";

    if (apiKey.isEmpty) {
      print("❌ OpenRouter API Key missing");
      return _emptyReceipt();
    }

    try {
      // 1. Choose your model
      // 'openai/gpt-4o' is Paid.
      // 'google/gemini-2.0-flash-exp:free' is Free on OpenRouter.
      const modelName = 'google/gemini-2.0-flash-exp:free'; 

      print("🚀 Asking OpenRouter ($modelName)...");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'HTTP-Referer': 'https://billbuddy.app', // Optional: Your site URL
          'X-Title': 'Bill Buddy', // Optional: Your app name
        },
        body: jsonEncode({
          "model": modelName,
          "messages": [
            {
              "role": "system",
              "content": "You are a receipt parsing assistant. Return ONLY valid JSON. No markdown."
            },
            {
              "role": "user",
              "content": '''
                Analyze this receipt text and return JSON.
                
                RAW TEXT:
                """
                $rawText
                """

                REQUIRED JSON FORMAT:
                {
                  "merchant": "Store Name",
                  "date": "YYYY-MM-DD",
                  "total": 0.00,
                  "tax": 0.00,
                  "items": [
                    { "name": "Item Name", "amount": 0.00 }
                  ]
                }
              '''
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // OpenRouter follows OpenAI format: choices[0].message.content
        String content = data['choices'][0]['message']['content'];
        
        // Clean Markdown (gpt-4o loves adding ```json)
        content = content.replaceAll('```json', '').replaceAll('```', '').trim();
        
        return _parseJson(content);
      } else {
        print("❌ OpenRouter Error: ${response.statusCode}");
        print("Body: ${response.body}");
        return _emptyReceipt();
      }

    } catch (e) {
      print("🚨 Connection Failed: $e");
      return _emptyReceipt();
    }
  }

  static ReceiptData _parseJson(String jsonString) {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      
      List<ReceiptItem> items = [];
      if (data['items'] is List) {
        items = (data['items'] as List).map((i) => ReceiptItem(
          i['name']?.toString() ?? "Item", 
          (i['amount'] is num) ? (i['amount'] as num).toDouble() : 0.0
        )).toList();
      }

      return ReceiptData(
        merchant: data['merchant']?.toString() ?? "Unknown",
        date: DateTime.tryParse(data['date']?.toString() ?? ""),
        totalAmount: (data['total'] is num) ? (data['total'] as num).toDouble() : 0.0,
        taxAmount: (data['tax'] is num) ? (data['tax'] as num).toDouble() : 0.0,
        category: "General",
        items: items,
      );
    } catch (e) {
      print("❌ JSON Parse Error: $e");
      return _emptyReceipt();
    }
  }

  static ReceiptData _emptyReceipt() {
    return ReceiptData(merchant: "Scan Failed", totalAmount: 0.0, taxAmount: 0.0, items: [], category: "General");
  }
}