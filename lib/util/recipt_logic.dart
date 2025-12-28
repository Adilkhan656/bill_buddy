import 'package:intl/intl.dart';

class ReceiptData {
  String merchant;
  DateTime? date;
  double totalAmount;
  double taxAmount;
  List<ReceiptItem> items;
  String category;

  ReceiptData({
    required this.merchant,
    this.date,
    required this.totalAmount,
    required this.taxAmount,
    required this.items,
    required this.category,
  });
}

class ReceiptItem {
  String description;
  double amount;

  ReceiptItem(this.description, this.amount);
}

class ReceiptParser {
  
  // --- MAIN PARSE FUNCTION ---
  static ReceiptData parse(String rawText) {
    // 1. Clean the text (remove empty lines)
    List<String> lines = rawText.split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    // 2. Extract Fields using smart logic
    String merchant = _findMerchant(lines);
    DateTime? date = _findDate(rawText);
    double total = _findTotal(lines);
    double tax = _findTax(lines);
    List<ReceiptItem> items = _findLineItems(lines, total); // <--- Advanced Table Logic
    String category = _guessCategory(merchant, rawText, items);

    return ReceiptData(
      merchant: merchant,
      date: date,
      totalAmount: total,
      taxAmount: tax,
      items: items,
      category: category,
    );
  }

  // --- 1. MERCHANT LOGIC ---
  static String _findMerchant(List<String> lines) {
    // Look at first 10 lines only
    for (int i = 0; i < lines.length && i < 10; i++) {
      String line = lines[i];
      String lower = line.toLowerCase();
      
      // Filter out junk/headers
      if (lower.contains("tax invoice")) continue;
      if (lower.contains("gst")) continue;
      if (lower.contains("date")) continue;
      if (lower.contains("bill to")) continue;
      if (lower.startsWith("no.")) continue; 
      if (lower.contains("welcome")) continue;
      
      // Valid merchant names are usually short (but not too short)
      if (line.length > 3 && line.length < 40) {
        return line; 
      }
    }
    return "Unknown Merchant";
  }

  // --- 2. TABLE EXTRACTION (The "Item" Logic) ---
  static List<ReceiptItem> _findLineItems(List<String> lines, double totalAmount) {
    List<ReceiptItem> extractedItems = [];
    
    // State 0: Waiting for Header
    // State 1: Reading Items
    int state = 0; 
    
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String lower = line.toLowerCase();

      // STOP if we hit the footer (Total/Subtotal)
      if (lower.startsWith("total") || lower.startsWith("sub total") || lower.startsWith("grand total")) {
        break;
      }

      // STATE 0: Look for "Item" or "Description" header
      if (state == 0) {
        if (lower.contains("item") && lower.contains("description")) {
          state = 1; 
          continue;
        }
        // Fallback: If we see a row starting with "1 " and it has a big price, assume table started
        if (RegExp(r'^\s*1\s+').hasMatch(line) && !lower.contains("/")) {
           state = 1;
        } else {
          continue; // Keep looking for header
        }
      }

      // STATE 1: Parse the actual item rows
      if (state == 1) {
        // Ignore garbage lines (headers appearing again)
        if (lower.contains("qty") && lower.contains("rate")) continue;

        // Regex: Find the LAST price in the line (e.g. "59,000.00")
        final priceMatch = RegExp(r'([\d,]+\.\d{2})\s*$').firstMatch(line);
        
        if (priceMatch != null) {
          double amount = double.parse(priceMatch.group(1)!.replaceAll(',', ''));
          
          // Everything before the price is the Description
          String desc = line.substring(0, line.indexOf(priceMatch.group(0)!)).trim();
          
          // Cleanup: Remove leading numbers like "1 " or "2 " (Row numbers)
          desc = desc.replaceAll(RegExp(r'^\d+\s+'), ''); 

          // Sanity check: Amount shouldn't be the Total
          if (amount > 0 && amount != totalAmount) {
             extractedItems.add(ReceiptItem(desc, amount));
          }
        } else {
          // Multiline Description Logic: Append to previous item
          // (e.g. Line 1: "Apple iPhone 12", Line 2: "(128GB Black)")
          if (extractedItems.isNotEmpty) {
             // Avoid appending technical junk like HSN codes
             if (!lower.contains("hsn") && !lower.contains("imei")) {
                extractedItems.last.description += " $line";
             }
          }
        }
      }
    }
    return extractedItems;
  }

  // --- 3. TAX LOGIC (SGST / CGST) ---
  static double _findTax(List<String> lines) {
    double totalTax = 0.0;
    
    for (String line in lines) {
      String lower = line.toLowerCase();
      
      // Look for lines with "gst" or "tax" AND a number
      if (lower.contains("gst") || lower.contains("tax")) {
        if (lower.contains("invoice")) continue; // Skip title
        
        final match = RegExp(r'([\d,]+\.\d{2})').firstMatch(line);
        if (match != null) {
           double val = double.parse(match.group(1)!.replaceAll(',', ''));
           // Sanity check: Tax is usually smaller than 100,000
           if (val < 100000) {
             totalTax += val;
           }
        }
      }
    }
    return totalTax;
  }

  // --- 4. HELPERS (Total, Date, Category) ---
  static double _findTotal(List<String> lines) {
    // Scan from bottom up for "Total"
    for (String line in lines.reversed) {
      if (line.toLowerCase().contains("total") && !line.toLowerCase().contains("sub")) {
        final match = RegExp(r'([\d,]+\.\d{2})').firstMatch(line);
        if (match != null) {
          return double.parse(match.group(1)!.replaceAll(',', ''));
        }
      }
    }
    return 0.0;
  }

  static DateTime? _findDate(String text) {
    // Regex for dd/mm/yyyy or yyyy-mm-dd
    final match = RegExp(r'(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})').firstMatch(text);
    if (match != null) {
      try {
        String raw = match.group(1)!.replaceAll('-', '/');
        return DateFormat('dd/MM/yyyy').parse(raw);
      } catch (e) { return null; }
    }
    return null;
  }

  static String _guessCategory(String merchant, String fullText, List<ReceiptItem> items) {
     String lowerMerchant = merchant.toLowerCase();
     if (lowerMerchant.contains("digital") || lowerMerchant.contains("reliance") || lowerMerchant.contains("apple")) {
       return "Tech";
     }
     if (lowerMerchant.contains("food") || lowerMerchant.contains("cafe") || lowerMerchant.contains("pizza")) {
       return "Food";
     }
     if (lowerMerchant.contains("mart") || lowerMerchant.contains("market") || lowerMerchant.contains("grocery")) {
       return "Grocery";
     }
     return "General";
  }
}