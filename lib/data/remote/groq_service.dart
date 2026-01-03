// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// // Data Model to hold the result
// class BillData {
//   String merchant;
//   String date;
//   String total;
//   String tax;
//   List<Map<String, dynamic>> items;

//   BillData({
//     required this.merchant,
//     required this.date,
//     required this.total,
//     required this.tax,
//     required this.items,
//   });
// }

// class GroqService {
//   static const String _baseUrl = "https://api.groq.com/openai/v1/chat/completions";

//   static Future<BillData?> scanReceipt(File imageFile) async {
//     try {
//       final apiKey = dotenv.env['GROQ_API_KEY'] ?? "";
//       if (apiKey.isEmpty) {
//         print("❌ Error: API Key not found in .env");
//         return null;
//       }

//       // 1. Convert Image to Base64 (Resize is handled by ImagePicker in UI)
//       List<int> imageBytes = await imageFile.readAsBytes();
//       String base64Image = base64Encode(imageBytes);
//       String dataUrl = "data:image/jpeg;base64,$base64Image";

//       print("🚀 Sending Image to Groq (Llama-4-Scout)...");

//       // 2. Prepare Request (Exact match to your Python logic)
//       final response = await http.post(
//         Uri.parse(_baseUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $apiKey",
//         },
//         body: jsonEncode({
//           "model": "meta-llama/llama-4-scout-17b-16e-instruct", // ✅ YOUR SPECIFIC MODEL
//           "messages": [
//             {
//               "role": "user",
//               "content": [
//                 {
//                   "type": "text",
//                   "text": '''
//                     Analyze this receipt image. Extract data into strict JSON format.
                    
//                     RULES:
//                     1. MERCHANT: Identify the store name (top of receipt). Ignore addresses.
//                     2. TOTAL: Find the final amount to pay.
//                     3. DATE: Format YYYY-MM-DD.
//                     4. ITEMS: Extract line items (Name, Price). Ignore SKU/UPC codes.
//                     5. ADDRESS KILLER: Do not treat phone numbers or pincodes as prices.
                    
//                     OUTPUT FORMAT:
//                     {
//                       "merchant": "Store Name",
//                       "date": "2025-01-01",
//                       "total": "100.00",
//                       "tax": "5.00",
//                       "items": [
//                         {"name": "Item 1", "price": 10.00},
//                         {"name": "Item 2", "price": 20.00}
//                       ]
//                     }
//                   '''
//                 },
//                 {
//                   "type": "image_url",
//                   "image_url": {
//                     "url": dataUrl // Sending the local image
//                   }
//                 }
//               ]
//             }
//           ],
//           "temperature": 0.1, // Low temp for strict JSON
//           "max_tokens": 1024
//         }),
//       );

//       // 3. Handle Response
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         String content = data['choices'][0]['message']['content'];
        
//         print("✅ Groq Raw Response: $content");

//         // 4. CLEANUP: Remove ```json and ``` marks if AI adds them
//         content = content.replaceAll('```json', '').replaceAll('```', '').trim();

//         // 5. Parse JSON to Object
//         final Map<String, dynamic> jsonMap = jsonDecode(content);
        
//         return BillData(
//           merchant: jsonMap['merchant']?.toString() ?? "Unknown",
//           date: jsonMap['date']?.toString() ?? DateTime.now().toString().split(' ')[0],
//           total: jsonMap['total']?.toString() ?? "0.00",
//           tax: jsonMap['tax']?.toString() ?? "0.00",
//           items: List<Map<String, dynamic>>.from(jsonMap['items'] ?? []),
//         );

//       } else {
//         print("❌ Groq API Error: ${response.statusCode} - ${response.body}");
//         return null;
//       }

//     } catch (e) {
//       print("🚨 Exception: $e");
//       return null;
//     }
//   }
// }

// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class BillData {
//   String merchant;
//   String date;
//   String total;
//   String tax;
//   List<Map<String, dynamic>> items;

//   BillData({
//     required this.merchant,
//     required this.date,
//     required this.total,
//     required this.tax,
//     required this.items,
//   });
// }

// class GroqService {
//   static const String _baseUrl = "https://api.groq.com/openai/v1/chat/completions";

//   static Future<BillData?> scanReceipt(File imageFile) async {
//     try {
//       final apiKey = dotenv.env['GROQ_API_KEY'] ?? "";
//       if (apiKey.isEmpty) {
//         print("❌ Error: API Key not found");
//         return null;
//       }

//       // 1. Image Processing
//       List<int> imageBytes = await imageFile.readAsBytes();
//       String base64Image = base64Encode(imageBytes);
      
//       // ✅ YOUR IMPROVEMENT: Correct Mime Type
//       String mimeType = imageFile.path.toLowerCase().endsWith('.png') 
//           ? 'image/png' 
//           : 'image/jpeg';
//       String dataUrl = "data:$mimeType;base64,$base64Image";

//       print("🚀 Sending to Groq...");

//       final response = await http.post(
//         Uri.parse(_baseUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $apiKey",
//         },
//         body: jsonEncode({
//           "model": "meta-llama/llama-4-scout-17b-16e-instruct",
//           "messages": [
//             {
//               "role": "user",
//               "content": [
//                 {
//                   "type": "text",
//                   // ✅ MY IMPROVEMENT: Universal Prompt for Rent/Bills
//                   "text": '''
//                     Analyze this image. It is either a shopping receipt, a utility bill (water, electricity), or a rent invoice.
//                     Extract data into strict JSON.

//                     RULES:
//                     1. MERCHANT: Name of the Store, Biller, Landlord, or Utility Company.
//                     2. TOTAL: The final amount to be paid.
//                     3. DATE: The billing date or due date (YYYY-MM-DD).
//                     4. ITEMS: 
//                        - If it's a receipt, list products.
//                        - If it's a utility/rent bill, create one item describing the service (e.g., "Rent for October" or "Water Usage").
                    
//                     REQUIRED JSON STRUCTURE:
//                     {
//                       "merchant": "String",
//                       "date": "YYYY-MM-DD",
//                       "total": "String",
//                       "tax": "String",
//                       "items": [
//                         {"name": "String", "price": Number}
//                       ]
//                     }
//                   '''
//                 },
//                 {
//                   "type": "image_url",
//                   "image_url": {"url": dataUrl}
//                 }
//               ]
//             }
//           ],
//           "temperature": 0.0,
//           "max_tokens": 1024
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         String content = data['choices'][0]['message']['content'];
//         print("✅ Raw Response: $content");

//         // 3. NUCLEAR PARSING
//         final jsonMap = _extractJson(content);
        
//         if (jsonMap.isEmpty) {
//           print("⚠️ Failed to extract valid JSON");
//           return null;
//         }

//         return BillData(
//           merchant: jsonMap['merchant']?.toString() ?? "Unknown",
//           date: jsonMap['date']?.toString() ?? DateTime.now().toString().split(' ')[0],
//           total: jsonMap['total']?.toString() ?? "0.00",
//           tax: jsonMap['tax']?.toString() ?? "0.00",
          
//           // ✅ YOUR IMPROVEMENT: Robust Price Parsing (String OR Number)
//           items: (jsonMap['items'] as List?)?.map((item) => {
//             'name': item['name']?.toString() ?? 'Unknown',
//             'price': (item['price'] is num) 
//               ? item['price'] 
//               : double.tryParse(item['price']?.toString() ?? '0') ?? 0.0
//           }).toList() ?? [],
//         );

//       } else {
//         print("❌ API Error ${response.statusCode}: ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("🚨 Exception: $e");
//       return null;
//     }
//   }

// /// 🛠️ SMART PARSER: Finds the first valid JSON object by counting brackets
//   static Map<String, dynamic> _extractJson(String text) {
//     try {
//       // 1. Find the first opening brace '{'
//       int startIndex = text.indexOf('{');
//       if (startIndex == -1) return {};

//       int braceCount = 0;
//       int endIndex = -1;

//       // 2. Iterate from start to find the matching closing brace '}'
//       for (int i = startIndex; i < text.length; i++) {
//         if (text[i] == '{') {
//           braceCount++;
//         } else if (text[i] == '}') {
//           braceCount--;
//           // Once count returns to 0, we found the end of the FIRST valid object
//           if (braceCount == 0) {
//             endIndex = i;
//             break;
//           }
//         }
//       }

//       // 3. Extract and Parse
//       if (endIndex != -1) {
//         String jsonString = text.substring(startIndex, endIndex + 1);
        
//         // Optional: Clean common cleanup issues (like newlines in strings)
//         jsonString = jsonString.replaceAll(RegExp(r'[\r\n]+'), ''); 
        
//         print("✨ Extracted First Valid JSON: $jsonString");
//         return jsonDecode(jsonString);
//       }
      
//       return {};
//     } catch (e) {
//       print("⚠️ Smart Parse Failed: $e");
//       // Fallback: If strict parsing fails, return empty to prevent crash
//       return {};
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// =======================
/// DATA MODEL
/// =======================
class BillData {
  final String merchant;
  final String date;
  final String total;
  final String tax;
  final List<Map<String, dynamic>> items;

  BillData({
    required this.merchant,
    required this.date,
    required this.total,
    required this.tax,
    required this.items,
  });
}

/// =======================
/// GROQ SERVICE
/// =======================
class GroqService {
  static const String _baseUrl =
      "https://api.groq.com/openai/v1/chat/completions";

  static Future<BillData?> scanReceipt(File imageFile) async {
    try {
      final apiKey = dotenv.env['GROQ_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("GROQ_API_KEY missing");
      }

      // ---------- IMAGE → BASE64 ----------
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final mimeType = imageFile.path.endsWith('.png')
          ? 'image/png'
          : 'image/jpeg';

      final dataUrl = "data:$mimeType;base64,$base64Image";

      // ---------- API CALL ----------
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "meta-llama/llama-4-scout-17b-16e-instruct",
          "temperature": 0.0,
          "max_tokens": 300, // 🔥 HARD CAP (important)
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text": _optimizedPrompt,
                },
                {
                  "type": "image_url",
                  "image_url": {"url": dataUrl}
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
            "Groq API error ${response.statusCode}: ${response.body}");
      }

      final decoded = jsonDecode(response.body);
      final content = decoded['choices'][0]['message']['content'];

      final jsonMap = _extractJson(content);
      if (jsonMap.isEmpty) return null;

      return BillData(
        merchant: jsonMap['merchant']?.toString() ?? "Unknown",
        date: jsonMap['date']?.toString() ??
            DateTime.now().toIso8601String().split('T').first,
        total: jsonMap['total']?.toString() ?? "0",
        tax: jsonMap['tax']?.toString() ?? "0",
        items: (jsonMap['items'] as List?)
                ?.map<Map<String, dynamic>>((item) => {
                      "name": item['name']?.toString() ?? "Unknown",
                      "price": item['price'] is num
                          ? item['price']
                          : double.tryParse(
                                  item['price']?.toString() ?? '0') ??
                              0.0
                    })
                .toList() ??
            [],
      );
    } catch (e) {
      print("❌ Receipt Scan Failed: $e");
      return null;
    }
  }

  /// =======================
  /// TOKEN-SAFE PROMPT
  /// =======================
  static const String _optimizedPrompt = '''
Extract receipt or bill data from the image.

Return ONLY valid JSON with:
- merchant
- date (YYYY-MM-DD)
- total
- tax
- items: [{name, price}]

If utility or rent bill, include ONE item describing the service.
No explanation. No markdown.
''';

  /// =======================
  /// SMART JSON EXTRACTOR
  /// =======================
  static Map<String, dynamic> _extractJson(String text) {
    try {
      final start = text.indexOf('{');
      if (start == -1) return {};

      int braces = 0;
      for (int i = start; i < text.length; i++) {
        if (text[i] == '{') braces++;
        if (text[i] == '}') braces--;
        if (braces == 0) {
          final jsonString = text.substring(start, i + 1);
          return jsonDecode(jsonString);
        }
      }
      return {};
    } catch (_) {
      return {};
    }
  }
}
