import 'dart:convert';
import 'package:bill_buddy/util/recipt_logic.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


class GeminiParser {
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? "";

  static Future<ReceiptData> parse(String rawText) async {
    if (_apiKey.isEmpty) {
      print("❌ Gemini API key missing in .env");
      return _emptyReceipt();
    }


    try {
      return await _tryParseWithModel('gemini-2.0-flash', rawText);
    } catch (e) {
      print("⚠️ Gemini 2.0 failed (likely region/preview issue): $e");
    }

  
    try {
      return await _tryParseWithModel('gemini-1.5-flash', rawText);
    } catch (e) {
      print("⚠️ Gemini 1.5 Flash also failed: $e");
    }

    // 3. If all models fail, return empty receipt
    return _emptyReceipt();
  }

  static Future<ReceiptData> _tryParseWithModel(String modelName, String text) async {
    print("🤖 Asking Gemini Model: $modelName");

    final model = GenerativeModel(
      model: modelName,
      apiKey: _apiKey,
    );

    final prompt = '''
      You are a receipt parser. Analyze this raw OCR text.
      
      RAW TEXT:
      """
      $text
      """

      RULES:
      - Return ONLY valid JSON. No markdown formatting.
      - Extract "Merchant", "Date", "Total", "Tax".
      - Extract all line items.
      - If a value is missing, use null or 0.

      RETURN FORMAT (JSON):
      {
        "merchant": "Store Name",
        "date": "YYYY-MM-DD",
        "total": 0.00,
        "tax": 0.00,
        "items": [
          { "name": "Item Name", "amount": 0.00 }
        ]
      }
    ''';

    final response = await model.generateContent([Content.text(prompt)]);
    String rawJson = response.text ?? "{}";

    // Clean Markdown if Gemini adds it (e.g., ```json ... ```)
    rawJson = rawJson.replaceAll('```json', '').replaceAll('```', '').trim();

    try {
      final Map<String, dynamic> data = jsonDecode(rawJson);

      // Parse Items safely
      List<ReceiptItem> parsedItems = [];
      if (data['items'] is List) {
        parsedItems = (data['items'] as List).map((item) {
          return ReceiptItem(
            item['name']?.toString() ?? "Item",
            (item['amount'] is num) ? (item['amount'] as num).toDouble() : 0.0,
          );
        }).toList();
      }

      return ReceiptData(
        merchant: data['merchant']?.toString() ?? "Unknown",
        date: DateTime.tryParse(data['date']?.toString() ?? ""),
        totalAmount: (data['total'] is num) ? (data['total'] as num).toDouble() : 0.0,
        taxAmount: (data['tax'] is num) ? (data['tax'] as num).toDouble() : 0.0,
        category: "General",
        items: parsedItems,
      );
    } catch (e) {
      print("❌ JSON Parsing Failed. Raw response: $rawJson");
      return _emptyReceipt();
    }
  }

  static ReceiptData _emptyReceipt() {
    return ReceiptData(
      merchant: "Scan Failed",
      totalAmount: 0.0,
      taxAmount: 0.0,
      items: [],
      category: "General",
    );
  }
}