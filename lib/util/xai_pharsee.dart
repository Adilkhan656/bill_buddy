import 'dart:convert';
import 'package:bill_buddy/util/recipt_logic.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Ensure this matches your file structure

class XAIParser {
  static Future<ReceiptData> parse(String rawText) async {
    final apiKey = dotenv.env['XAI_API_KEY'] ?? "";
    const apiUrl = "https://api.x.ai/v1/chat/completions";

    if (apiKey.isEmpty) {
      print("❌ xAI Key missing");
      return _emptyReceipt();
    }

    try {
      print("🚀 Asking xAI (Grok-4)...");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey', // The official xAI header
        },
        body: jsonEncode({
          "model": "grok-4-latest", // Using the model from your screenshot
          "messages": [
            {
              "role": "system",
              "content": "You are a receipt parsing assistant. You strictly output only valid JSON. No markdown, no explanations."
            },
            {
              "role": "user",
              "content": '''
                Analyze this receipt text and extract the details into JSON.
                
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
          ],
          "temperature": 0.1 // Keep it precise
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        // Clean any potential Markdown
        final cleanJson = content.replaceAll('```json', '').replaceAll('```', '').trim();
        
        return _parseJson(cleanJson);
      } else {
        print("❌ xAI Error: ${response.statusCode}");
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