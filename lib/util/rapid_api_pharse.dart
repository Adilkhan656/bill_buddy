import 'dart:convert';
import 'package:bill_buddy/util/recipt_logic.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class RapidApiParser {
  static Future<ReceiptData> parse(String rawText) async {
    // 1. Load values from .env
    final apiKey = dotenv.env['RAPID_API_KEY'] ?? "";
    final apiHost = dotenv.env['RAPID_API_HOST'] ?? "";
    final apiUrl = dotenv.env['RAPID_API_URL'] ?? "";

    if (apiKey.isEmpty) {
      print("❌ RapidAPI Key missing");
      return _emptyReceipt();
    }

    try {
      print("🚀 Sending request to RapidAPI...");

      // 2. Send POST Request with the Headers from your screenshot
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-RapidAPI-Key': apiKey,  // <--- The Key from your screenshot
          'X-RapidAPI-Host': apiHost, // <--- The Host from the Code Snippet
        },
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {
                  "text": '''
                    You are a receipt parser. Analyze this text and return JSON ONLY.
                    
                    Text: """$rawText"""
                    
                    Format:
                    {
                      "merchant": "String",
                      "date": "YYYY-MM-DD",
                      "total": 0.00,
                      "tax": 0.00,
                      "items": [{"name": "String", "amount": 0.00}]
                    }
                  '''
                }
              ]
            }
          ]
        }),
      );

      // 3. Handle Response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // RapidAPI usually wraps the exact Google response
        // Path: candidates -> content -> parts -> text
        String cleanJson = data['candidates'][0]['content']['parts'][0]['text'];
        
        // Clean Markdown formatting
        cleanJson = cleanJson.replaceAll('```json', '').replaceAll('```', '').trim();
        
        return _parseJson(cleanJson);
      } else {
        print("❌ RapidAPI Error: ${response.statusCode}");
        print("Body: ${response.body}");
        return _emptyReceipt();
      }

    } catch (e) {
      print("🚨 Connection Failed: $e");
      return _emptyReceipt();
    }
  }

  // --- Helper to convert JSON to ReceiptData ---
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