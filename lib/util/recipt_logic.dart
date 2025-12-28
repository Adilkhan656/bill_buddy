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
  
  // Known big brands to auto-detect
  static final Set<String> _knownMerchants = {
    'walmart', 'target', 'costco', 'walgreens', 'cvs', 
    'starbucks', 'mcdonalds', 'kfc', 'subway', 
    'home depot', 'lowes', 'best buy', 'apple', 'amazon',
    'reliance', 'dmart', 'big bazaar', 'zara', 'h&m'
  };

  static ReceiptData parse(String rawText) {
    List<String> lines = rawText.split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    String merchant = _findMerchant(lines);
    DateTime? date = _findDate(rawText);
    double total = _findTotal(lines);
    double tax = _findTax(lines);
    List<ReceiptItem> items = _findLineItems(lines, total, tax);
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

  // --- 1. MERCHANT LOGIC (Brand Priority) ---
  static String _findMerchant(List<String> lines) {
    // Strategy A: Check for known brands first (Highest Priority)
    for (String line in lines) {
      String lower = line.toLowerCase();
      for (String brand in _knownMerchants) {
        if (lower.contains(brand)) {
           // Return the clean brand name (e.g. "Walmart") capitalized
           return brand[0].toUpperCase() + brand.substring(1); 
        }
      }
    }

    // Strategy B: If no known brand, take the first valid line
    for (int i = 0; i < lines.length && i < 10; i++) {
      String line = lines[i];
      String lower = line.toLowerCase();
      
      // Filter junk lines
      if (lower.contains("limited time")) continue; // <--- FIX FOR YOUR WALMART BILL
      if (lower.contains("save money")) continue;
      if (lower.contains("tax invoice")) continue;
      if (lower.contains("customer copy")) continue;
      if (lower.length < 3) continue;

      return line; 
    }
    return "Unknown Merchant";
  }

  // --- 2. TABLE EXTRACTION (Universal Mode) ---
  static List<ReceiptItem> _findLineItems(List<String> lines, double totalAmount, double taxAmount) {
    List<ReceiptItem> extractedItems = [];
    int headerIndex = -1;

    // Step A: Try to find a Header
    for (int i = 0; i < lines.length; i++) {
      String lower = lines[i].toLowerCase();
      if ((lower.contains("item") || lower.contains("description") || lower.contains("article")) && 
          (lower.contains("price") || lower.contains("amount") || lower.contains("rate"))) {
        headerIndex = i;
        break;
      }
    }

    // Step B: Start scanning
    // If no header found, start from line 3 (skip likely merchant info)
    int startIndex = (headerIndex != -1) ? headerIndex + 1 : 3;

    for (int i = startIndex; i < lines.length; i++) {
      String line = lines[i];
      String lower = line.toLowerCase();

      // STOP conditions
      if (lower.startsWith("total") || lower.startsWith("subtotal") || lower.startsWith("balance")) break;
      if (lower.contains("items sold")) break; // Walmart specific footer

      // IGNORE garbage
      if (lower.contains("visa") || lower.contains("change due")) continue;

      // PARSE PRICE: Look for price at end, allowing 1-2 chars after (like "9.44 X")
      // Regex explanation:
      // (\d+\.\d{2})  -> Find 12.34
      // \s* -> Maybe spaces
      // [a-zA-Z]?     -> Maybe ONE letter (X, N, T)
      // $             -> End of line
      final priceMatch = RegExp(r'(\d+\.\d{2})\s*[a-zA-Z]?$').firstMatch(line);
      
      if (priceMatch != null) {
        double amount = double.parse(priceMatch.group(1)!);
        
        // Safety: Don't capture the Total or Tax as an item
        if (amount == totalAmount || amount == taxAmount) continue;
        if (amount == 0.0) continue;

        String desc = line.substring(0, line.indexOf(priceMatch.group(1)!)).trim();
        
        // Clean up: Walmart item codes (e.g., "00440000379 F")
        // If description is purely numbers, it's a barcode, skip it or keep it? 
        // Let's keep it but remove the UPC if it's separate.
        
        if (desc.isNotEmpty) {
           extractedItems.add(ReceiptItem(desc, amount));
        }
      }
    }
    return extractedItems;
  }

  // --- 3. TOTAL, TAX & DATE ---
  static double _findTotal(List<String> lines) {
    for (String line in lines.reversed) {
      String lower = line.toLowerCase();
      // Walmart calls it "TOTAL PURCHASE" or just "TOTAL"
      if (lower.contains("total") && !lower.contains("sub")) {
        final match = RegExp(r'(\d+\.\d{2})').firstMatch(line);
        if (match != null) {
          return double.parse(match.group(1)!);
        }
      }
    }
    // Fallback: Max number
    double max = 0.0;
    for (String line in lines) {
      final match = RegExp(r'(\d+\.\d{2})').firstMatch(line);
      if (match != null) {
         double v = double.parse(match.group(1)!);
         if (v > max) max = v;
      }
    }
    return max;
  }

  static double _findTax(List<String> lines) {
    double totalTax = 0.0;
    for (String line in lines) {
      String lower = line.toLowerCase();
      if (lower.contains("tax") || lower.contains("vat") || lower.contains("gst")) {
         // Avoid "Tax Invoice" title
         if (lower.contains("invoice")) continue;
         
         final match = RegExp(r'(\d+\.\d{2})').firstMatch(line);
         if (match != null) {
            double v = double.parse(match.group(1)!);
            if (v < 1000) totalTax += v; // Sanity check
         }
      }
    }
    return totalTax;
  }

  static DateTime? _findDate(String text) {
    // 1. Try MM/DD/YY (Walmart style: 07/29/14)
    final mmddyy = RegExp(r'(\d{2})/(\d{2})/(\d{2,4})').firstMatch(text);
    if (mmddyy != null) {
      try {
        int m = int.parse(mmddyy.group(1)!);
        int d = int.parse(mmddyy.group(2)!);
        int y = int.parse(mmddyy.group(3)!);
        if (y < 100) y += 2000; // Fix 2-digit year
        return DateTime(y, m, d);
      } catch (e) {}
    }
    
    // 2. Try YYYY-MM-DD
    final yyyymmdd = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(text);
    if (yyyymmdd != null) {
      return DateTime.parse(yyyymmdd.group(0)!);
    }
    return null;
  }

  static String _guessCategory(String merchant, String fullText, List<ReceiptItem> items) {
     if (merchant.toLowerCase().contains("walmart")) return "Grocery"; // Default for Walmart
     // (Keep existing logic)
     return "General";
  }
}