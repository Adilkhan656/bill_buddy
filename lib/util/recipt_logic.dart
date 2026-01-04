// import 'package:intl/intl.dart';

// // ==================== DATA MODELS ====================
// class ReceiptData {
//   String merchant;
//   DateTime? date;
//   double totalAmount;
//   double taxAmount;
//   List<ReceiptItem> items;
//   String category;

//   ReceiptData({
//     required this.merchant,
//     this.date,
//     required this.totalAmount,
//     required this.taxAmount,
//     required this.items,
//     required this.category,
//   });
// }

// class ReceiptItem {
//   String description;
//   double amount;
//   int quantity;

//   ReceiptItem(this.description, this.amount, {this.quantity = 1});
// }

// class ParseResult {
//   final ReceiptData data;
//   final double confidence;
//   final List<String> warnings;

//   ParseResult({
//     required this.data,
//     required this.confidence,
//     this.warnings = const [],
//   });
// }

// // ==================== MAIN PARSER ====================
// class ImprovedReceiptParser {
//   // Known merchant patterns with regex for better matching
//   static final Map<String, List<String>> _merchantPatterns = {
//     'Walmart': ['walmart', 'wal-mart', 'wal mart'],
//     'Target': ['target'],
//     'Costco': ['costco'],
//     'Walgreens': ['walgreens'],
//     'CVS': ['cvs pharmacy', 'cvs'],
//     'Starbucks': ['starbucks'],
//     'McDonald\'s': ['mcdonald', 'mcdonalds'],
//     'Home Depot': ['home depot', 'homedepot'],
//     'Best Buy': ['best buy', 'bestbuy'],
//     'Reliance': ['reliance fresh', 'reliance mart', 'reliance'],
//     'DMart': ['dmart', 'd-mart', 'd mart'],
//     'Big Bazaar': ['big bazaar', 'bigbazaar'],
//   };

//   static ParseResult parse(String rawText) {
//     List<String> warnings = [];
    
//     // Normalize text
//     String normalizedText = _normalizeText(rawText);
//     List<String> lines = normalizedText.split('\n')
//         .map((l) => l.trim())
//         .where((l) => l.isNotEmpty)
//         .toList();

//     // Extract all components
//     String merchant = _detectMerchant(lines);
//     DateTime? date = _detectDate(normalizedText);
//     double total = _detectTotal(lines, normalizedText);
//     double tax = _detectTax(lines);
//     List<ReceiptItem> items = _extractItems(lines, total, tax);
//     String category = _categorizeReceipt(merchant, items, normalizedText);

//     // Validation and warnings
//     if (merchant == "Unknown Merchant") {
//       warnings.add("Could not identify merchant");
//     }
//     if (date == null) {
//       warnings.add("Could not parse date");
//     }
//     if (items.isEmpty) {
//       warnings.add("No line items found");
//     }
//     if (total > 0 && items.isNotEmpty) {
//       double itemsSum = items.fold(0.0, (sum, item) => sum + item.amount);
//       double diff = (total - itemsSum - tax).abs();
//       if (diff > 1.0) {
//         warnings.add("Total mismatch: items+tax ≠ total");
//       }
//     }

//     double confidence = _calculateConfidence(merchant, date, total, items, warnings);

//     return ParseResult(
//       data: ReceiptData(
//         merchant: merchant,
//         date: date,
//         totalAmount: total,
//         taxAmount: tax,
//         items: items,
//         category: category,
//       ),
//       confidence: confidence,
//       warnings: warnings,
//     );
//   }

//   // ==================== TEXT NORMALIZATION ====================
//   static String _normalizeText(String text) {
//     // Fix common OCR errors
//     text = text.replaceAll(RegExp(r'\s+'), ' '); // Normalize whitespace
//     text = text.replaceAll(RegExp(r'(?<=\d)\s+(?=\d)'), ''); // Remove spaces in numbers
//     text = text.replaceAll('|', 'I'); // Common OCR error
//     text = text.replaceAll('О', '0'); // Cyrillic O to zero
//     text = text.replaceAll('о', '0');
//     return text;
//   }

//   // ==================== MERCHANT DETECTION ====================
//   static String _detectMerchant(List<String> lines) {
//     // Phase 1: Check for known brands (case-insensitive, fuzzy)
//     for (String line in lines.take(15)) {
//       String lower = line.toLowerCase();
      
//       for (var entry in _merchantPatterns.entries) {
//         for (var pattern in entry.value) {
//           if (lower.contains(pattern)) {
//             return entry.key;
//           }
//         }
//       }
//     }

//     // Phase 2: Heuristic detection (first substantial line)
//     final junkKeywords = [
//       'tax invoice', 'receipt', 'bill', 'customer copy', 'original',
//       'save money', 'limited time', 'thank you', 'visit us',
//       'welcome', 'gstin', 'phone', 'tel', 'website', 'www',
//       'store hours', 'cashier', 'manager'
//     ];

//     for (int i = 0; i < lines.length && i < 12; i++) {
//       String line = lines[i];
//       String lower = line.toLowerCase();

//       // Skip junk
//       if (junkKeywords.any((kw) => lower.contains(kw))) continue;
      
//       // Skip address-like lines
//       if (_isAddressLine(lower)) continue;
      
//       // Skip pure numbers/symbols
//       if (!RegExp(r'[a-zA-Z]{3,}').hasMatch(line)) continue;
      
//       // Skip lines with only date/time patterns
//       if (RegExp(r'^\d{1,2}[:/\-]\d{1,2}[:/\-]\d{2,4}').hasMatch(line)) continue;

//       // Must have reasonable length
//       if (line.length >= 3 && line.length <= 50) {
//         return line;
//       }
//     }

//     return "Unknown Merchant";
//   }

//   // ==================== DATE DETECTION ====================
//   static DateTime? _detectDate(String text) {
//     // Pattern 1: MM/DD/YYYY or MM/DD/YY (US format)
//     final usDate = RegExp(r'\b(\d{1,2})[/\-](\d{1,2})[/\-](\d{2,4})\b');
//     final matches = usDate.allMatches(text);
    
//     for (var match in matches) {
//       try {
//         int part1 = int.parse(match.group(1)!);
//         int part2 = int.parse(match.group(2)!);
//         int year = int.parse(match.group(3)!);
        
//         // Fix 2-digit year
//         if (year < 100) {
//           year += (year > 50) ? 1900 : 2000;
//         }

//         // Try MM/DD/YYYY
//         if (part1 >= 1 && part1 <= 12 && part2 >= 1 && part2 <= 31) {
//           return DateTime(year, part1, part2);
//         }
        
//         // Try DD/MM/YYYY (international)
//         if (part2 >= 1 && part2 <= 12 && part1 >= 1 && part1 <= 31) {
//           return DateTime(year, part2, part1);
//         }
//       } catch (_) {}
//     }

//     // Pattern 2: YYYY-MM-DD (ISO format)
//     final isoDate = RegExp(r'\b(\d{4})-(\d{2})-(\d{2})\b');
//     final isoMatch = isoDate.firstMatch(text);
//     if (isoMatch != null) {
//       try {
//         return DateTime.parse(isoMatch.group(0)!);
//       } catch (_) {}
//     }

//     // Pattern 3: Written dates (Jan 15, 2024)
//     final writtenDate = RegExp(
//       r'\b(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s+(\d{1,2}),?\s+(\d{4})\b',
//       caseSensitive: false
//     );
//     final writtenMatch = writtenDate.firstMatch(text);
//     if (writtenMatch != null) {
//       try {
//         final monthMap = {
//           'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
//           'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12
//         };
//         String monthStr = writtenMatch.group(1)!.toLowerCase().substring(0, 3);
//         int month = monthMap[monthStr] ?? 1;
//         int day = int.parse(writtenMatch.group(2)!);
//         int year = int.parse(writtenMatch.group(3)!);
//         return DateTime(year, month, day);
//       } catch (_) {}
//     }

//     return null;
//   }

//   // ==================== TOTAL DETECTION ====================
//   static double _detectTotal(List<String> lines, String fullText) {
//     final totalKeywords = [
//       'grand total', 'total purchase', 'net amount', 'amount due',
//       'balance due', 'total amount', 'total'
//     ];

//     // Search from bottom up (totals are usually at the end)
//     for (int i = lines.length - 1; i >= 0; i--) {
//       String lower = lines[i].toLowerCase();
      
//       // Check if line contains total keyword
//       bool isTotal = totalKeywords.any((kw) => lower.contains(kw));
      
//       // Exclude subtotals and savings
//       if (lower.contains('sub') || lower.contains('saving')) continue;
      
//       if (isTotal) {
//         double amount = _extractLargestNumber(lines[i]);
//         if (amount > 0) return amount;
//       }
//     }

//     // Fallback: Find the largest reasonable price in the document
//     return _findLargestPrice(fullText);
//   }

//   // ==================== TAX DETECTION ====================
//   static double _detectTax(List<String> lines) {
//     double totalTax = 0.0;
//     final taxKeywords = ['tax', 'gst', 'vat', 'cgst', 'sgst', 'igst'];
    
//     // Start from middle (tax usually after items)
//     int startIdx = (lines.length * 0.4).floor();
    
//     for (int i = startIdx; i < lines.length; i++) {
//       String lower = lines[i].toLowerCase();
      
//       // Skip header lines
//       if (lower.contains('invoice') || lower.contains('number')) continue;
      
//       if (taxKeywords.any((kw) => lower.contains(kw))) {
//         double amount = _extractLargestNumber(lines[i]);
//         if (amount > 0 && amount < 50000) { // Reasonable tax amount
//           totalTax += amount;
//         }
//       }
//     }
    
//     return totalTax;
//   }

//   // ==================== ITEM EXTRACTION ====================
//   static List<ReceiptItem> _extractItems(List<String> lines, double total, double tax) {
//     List<ReceiptItem> items = [];
    
//     // Find the items section boundaries
//     int startIdx = _findItemsStartIndex(lines);
//     int endIdx = _findItemsEndIndex(lines, startIdx);

//     final stopWords = ['total', 'subtotal', 'tax', 'amount', 'balance', 'cash', 'card', 
//                        'change', 'thank', 'visit', 'items sold', 'quantity'];

//     for (int i = startIdx; i < endIdx && i < lines.length; i++) {
//       String line = lines[i];
//       String lower = line.toLowerCase();

//       // Stop conditions
//       if (stopWords.any((w) => lower.startsWith(w))) break;
      
//       // Skip garbage lines
//       if (_isAddressLine(lower)) continue;
//       if (lower.contains('visa') || lower.contains('mastercard')) continue;
//       if (line.length < 3) continue;

//       // Try to extract price and description
//       var itemData = _parseItemLine(line);
      
//       if (itemData != null) {
//         double price = itemData['price'];
//         String desc = itemData['description'];
//         int qty = itemData['quantity'];
        
//         // Validation
//         if (price <= 0 || price > total) continue;
//         if (price == total || price == tax) continue;
//         if (desc.isEmpty || desc.length < 2) continue;
        
//         // Avoid duplicates (OCR sometimes duplicates lines)
//         if (items.any((item) => 
//             item.description == desc && (item.amount - price).abs() < 0.01)) {
//           continue;
//         }

//         items.add(ReceiptItem(desc, price, quantity: qty));
//       }
//     }

//     return items;
//   }

//   static int _findItemsStartIndex(List<String> lines) {
//     // Look for table headers
//     for (int i = 0; i < lines.length && i < 20; i++) {
//       String lower = lines[i].toLowerCase();
      
//       bool hasItemCol = lower.contains('item') || lower.contains('description') || 
//                         lower.contains('article') || lower.contains('particular');
//       bool hasPriceCol = lower.contains('price') || lower.contains('amount') || 
//                          lower.contains('rate') || lower.contains('total');
      
//       if (hasItemCol && hasPriceCol) {
//         return i + 1;
//       }
//     }
    
//     // Fallback: skip first 25% of lines
//     return (lines.length * 0.25).floor();
//   }

//   static int _findItemsEndIndex(List<String> lines, int startIdx) {
//     // Look for footer markers
//     for (int i = startIdx; i < lines.length; i++) {
//       String lower = lines[i].toLowerCase();
//       if (lower.startsWith('subtotal') || lower.startsWith('total') || 
//           lower.contains('items sold')) {
//         return i;
//       }
//     }
//     return lines.length;
//   }

//   static Map<String, dynamic>? _parseItemLine(String line) {
//     // Pattern 1: Description followed by price (most common)
//     // e.g., "MILK ORGANIC 2% 9.44" or "BREAD 2.99 N"
//     final pattern1 = RegExp(r'^(.+?)\s+(\d+\.\d{2})\s*[A-Z]?\s*$');
//     var match = pattern1.firstMatch(line);
    
//     if (match != null) {
//       String desc = match.group(1)!.trim();
//       double price = double.parse(match.group(2)!);
      
//       // Try to extract quantity (e.g., "2 X ITEM" or "ITEM QTY 3")
//       int qty = _extractQuantity(desc);
//       desc = _cleanDescription(desc);
      
//       return {'description': desc, 'price': price, 'quantity': qty};
//     }

//     // Pattern 2: Quantity x Description Price
//     // e.g., "2 X EGGS 5.98"
//     final pattern2 = RegExp(r'^(\d+)\s*[xX@]\s*(.+?)\s+(\d+\.\d{2})\s*$');
//     match = pattern2.firstMatch(line);
    
//     if (match != null) {
//       int qty = int.parse(match.group(1)!);
//       String desc = match.group(2)!.trim();
//       double price = double.parse(match.group(3)!);
//       desc = _cleanDescription(desc);
      
//       return {'description': desc, 'price': price, 'quantity': qty};
//     }

//     return null;
//   }

//   static int _extractQuantity(String text) {
//     // Look for patterns like "2 X", "QTY 3", "3x"
//     final qtyPattern = RegExp(r'\b(\d+)\s*[xX@]|QTY\s*[:=]?\s*(\d+)', caseSensitive: false);
//     var match = qtyPattern.firstMatch(text);
//     if (match != null) {
//       return int.parse(match.group(1) ?? match.group(2) ?? '1');
//     }
//     return 1;
//   }

//   static String _cleanDescription(String desc) {
//     // Remove UPC codes (8+ digits)
//     desc = desc.replaceAll(RegExp(r'\b\d{8,}\b'), '');
    
//     // Remove quantity markers
//     desc = desc.replaceAll(RegExp(r'^\d+\s*[xX@]\s*'), '');
//     desc = desc.replaceAll(RegExp(r'\bQTY\s*[:=]?\s*\d+\b', caseSensitive: false), '');
    
//     // Remove currency symbols
//     desc = desc.replaceAll(RegExp(r'[₹$£€]|Rs\.?|INR', caseSensitive: false), '');
    
//     // Remove trailing single letters (often flags like N, T, F)
//     desc = desc.replaceAll(RegExp(r'\s+[A-Z]$'), '');
    
//     return desc.trim();
//   }

//   // ==================== UTILITY FUNCTIONS ====================
  
//   static bool _isAddressLine(String lower) {
//     final addressKeywords = [
//       'road', 'street', 'floor', 'avenue', 'drive', 'lane', 'blvd',
//       'opp', 'near', 'behind', 'dist', 'state', 'pin', 'zip',
//       'mumbai', 'delhi', 'bangalore', 'maharashtra', 'texas', 'california',
//       'india', 'usa', 'uk', 'marg', 'nagar'
//     ];
//     return addressKeywords.any((kw) => lower.contains(kw));
//   }

//   static double _extractLargestNumber(String line) {
//     // Find all numbers with 2 decimal places
//     final regex = RegExp(r'(\d+[,\d]*\.\d{2})');
//     final matches = regex.allMatches(line);
    
//     double maxVal = 0.0;
//     for (var match in matches) {
//       String numStr = match.group(1)!.replaceAll(',', '');
//       double? val = double.tryParse(numStr);
//       if (val != null && val > maxVal) {
//         maxVal = val;
//       }
//     }
    
//     // If no decimal number found, try integer
//     if (maxVal == 0.0) {
//       final intRegex = RegExp(r'\b(\d+)\b');
//       final intMatches = intRegex.allMatches(line);
//       for (var match in intMatches) {
//         double? val = double.tryParse(match.group(1)!);
//         if (val != null && val > maxVal && val < 1000000) {
//           maxVal = val;
//         }
//       }
//     }
    
//     return maxVal;
//   }

//   static double _findLargestPrice(String text) {
//     final regex = RegExp(r'\d+[,\d]*\.\d{2}');
//     final matches = regex.allMatches(text);
    
//     double maxVal = 0.0;
//     for (var match in matches) {
//       String numStr = match.group(0)!.replaceAll(',', '');
//       double? val = double.tryParse(numStr);
//       if (val != null && val > maxVal && val < 1000000) {
//         maxVal = val;
//       }
//     }
//     return maxVal;
//   }

//   static String _categorizeReceipt(String merchant, List<ReceiptItem> items, String fullText) {
//     String lower = merchant.toLowerCase() + ' ' + fullText.toLowerCase();
    
//     // Food & Grocery
//     if (lower.contains('walmart') || lower.contains('costco') || 
//         lower.contains('dmart') || lower.contains('grocery') ||
//         lower.contains('supermarket') || lower.contains('food')) {
//       return 'Grocery';
//     }
    
//     // Pharmacy
//     if (lower.contains('pharmacy') || lower.contains('cvs') || 
//         lower.contains('walgreens') || lower.contains('medicine')) {
//       return 'Healthcare';
//     }
    
//     // Restaurant
//     if (lower.contains('restaurant') || lower.contains('cafe') || 
//         lower.contains('starbucks') || lower.contains('mcdonald')) {
//       return 'Dining';
//     }
    
//     // Retail
//     if (lower.contains('depot') || lower.contains('best buy') || 
//         lower.contains('target')) {
//       return 'Retail';
//     }
    
//     return 'General';
//   }

//   static double _calculateConfidence(String merchant, DateTime? date, 
//                                      double total, List<ReceiptItem> items, 
//                                      List<String> warnings) {
//     double score = 0.0;
    
//     if (merchant != "Unknown Merchant") score += 0.25;
//     if (date != null) score += 0.15;
//     if (total > 0) score += 0.30;
//     if (items.isNotEmpty) score += 0.20;
//     if (warnings.isEmpty) score += 0.10;
    
//     return score.clamp(0.0, 1.0);
//   }
// }
// import 'package:intl/intl.dart';

// // ==================== DATA MODELS ====================
// class ReceiptData {
//   String merchant;
//   DateTime? date;
//   double totalAmount;
//   double taxAmount;
//   List<ReceiptItem> items;
//   String category;
//   Map<String, double> taxBreakdown; // For CGST, SGST, IGST, etc.

//   ReceiptData({
//     required this.merchant,
//     this.date,
//     required this.totalAmount,
//     required this.taxAmount,
//     required this.items,
//     required this.category,
//     this.taxBreakdown = const {},
//   });
// }

// class ReceiptItem {
//   String description;
//   double amount;
//   int quantity;
//   double unitPrice;

//   ReceiptItem(
//     this.description,
//     this.amount, {
//     this.quantity = 1,
//     double? unitPrice,
//   }) : unitPrice = unitPrice ?? amount;
// }

// class ParseResult {
//   final ReceiptData data;
//   final double confidence;
//   final List<String> warnings;

//   ParseResult({
//     required this.data,
//     required this.confidence,
//     this.warnings = const [],
//   });
// }

// // ==================== MAIN PARSER ====================
// class ImprovedReceiptParser {
//   // Known merchant patterns with regex for better matching
//   static final Map<String, List<String>> _merchantPatterns = {
//     'Walmart': ['walmart', 'wal-mart', 'wal mart'],
//     'Target': ['target'],
//     'Costco': ['costco'],
//     'Walgreens': ['walgreens'],
//     'CVS': ['cvs pharmacy', 'cvs'],
//     'Starbucks': ['starbucks'],
//     'McDonald\'s': ['mcdonald', 'mcdonalds'],
//     'Home Depot': ['home depot', 'homedepot'],
//     'Best Buy': ['best buy', 'bestbuy'],
//     'Reliance': ['reliance fresh', 'reliance mart', 'reliance retail', 'reliance digital', 'reliance'],
//     'DMart': ['dmart', 'd-mart', 'd mart'],
//     'Big Bazaar': ['big bazaar', 'bigbazaar'],
//     'Spencer\'s': ['spencer', 'spencers'],
//     'More': ['more megastore', 'more supermarket'],
//   };

//   static ParseResult parse(String rawText) {
//     List<String> warnings = [];
    
//     // Normalize text
//     String normalizedText = _normalizeText(rawText);
//     List<String> lines = normalizedText.split('\n')
//         .map((l) => l.trim())
//         .where((l) => l.isNotEmpty)
//         .toList();

//     // Extract all components
//     String merchant = _detectMerchant(lines);
//     DateTime? date = _detectDate(normalizedText);
    
//     // Enhanced tax detection with breakdown
//     var taxData = _detectTaxEnhanced(lines, normalizedText);
//     double tax = taxData['total'];
//     Map<String, double> taxBreakdown = taxData['breakdown'];
    
//     // Extract items BEFORE detecting total (helps with validation)
//     List<ReceiptItem> items = _extractItemsEnhanced(lines);
    
//     // Enhanced total detection using items as context
//     double total = _detectTotalEnhanced(lines, normalizedText, items, tax);
    
//     String category = _categorizeReceipt(merchant, items, normalizedText);

//     // Validation and warnings
//     if (merchant == "Unknown Merchant") {
//       warnings.add("Could not identify merchant");
//     }
//     if (date == null) {
//       warnings.add("Could not parse date");
//     }
//     if (items.isEmpty) {
//       warnings.add("No line items found");
//     }
//     if (total > 0 && items.isNotEmpty) {
//       double itemsSum = items.fold(0.0, (sum, item) => sum + item.amount);
//       double expectedTotal = itemsSum + tax;
//       double diff = (total - expectedTotal).abs();
      
//       // More lenient tolerance for rounding differences
//       if (diff > 2.0) {
//         warnings.add("Total mismatch: items(\$${itemsSum.toStringAsFixed(2)}) + tax(\$${tax.toStringAsFixed(2)}) = \$${expectedTotal.toStringAsFixed(2)}, but total is \$${total.toStringAsFixed(2)}");
//       }
//     }

//     double confidence = _calculateConfidence(merchant, date, total, items, warnings);

//     return ParseResult(
//       data: ReceiptData(
//         merchant: merchant,
//         date: date,
//         totalAmount: total,
//         taxAmount: tax,
//         items: items,
//         category: category,
//         taxBreakdown: taxBreakdown,
//       ),
//       confidence: confidence,
//       warnings: warnings,
//     );
//   }

//   // ==================== TEXT NORMALIZATION ====================
//   static String _normalizeText(String text) {
//     // Fix common OCR errors
//     text = text.replaceAll(RegExp(r'\s+'), ' '); // Normalize whitespace
//     text = text.replaceAll(RegExp(r'(?<=\d)\s+(?=\d{2}$)', multiLine: true), '.'); // Fix decimal spaces
//     text = text.replaceAll('|', 'I'); // Common OCR error
//     text = text.replaceAll('О', '0'); // Cyrillic O to zero
//     text = text.replaceAll('о', '0');
//     text = text.replaceAll('l', '1'); // lowercase L to 1 in numeric contexts
    
//     // Fix common price format issues
//     text = text.replaceAll(RegExp(r'(\d+)\s+(\d{2})\b'), '\$1.\$2'); // "9 44" -> "9.44"
    
//     return text;
//   }

//   // ==================== MERCHANT DETECTION ====================
//   static String _detectMerchant(List<String> lines) {
//     // Phase 1: Check for known brands (case-insensitive, fuzzy)
//     for (String line in lines.take(15)) {
//       String lower = line.toLowerCase();
      
//       for (var entry in _merchantPatterns.entries) {
//         for (var pattern in entry.value) {
//           if (lower.contains(pattern)) {
//             return entry.key;
//           }
//         }
//       }
//     }

//     // Phase 2: Heuristic detection (first substantial line)
//     final junkKeywords = [
//       'tax invoice', 'receipt', 'bill', 'customer copy', 'original',
//       'save money', 'limited time', 'thank you', 'visit us',
//       'welcome', 'gstin', 'gst no', 'phone', 'tel', 'website', 'www',
//       'store hours', 'cashier', 'manager', 'invoice#', 'bill to'
//     ];

//     for (int i = 0; i < lines.length && i < 12; i++) {
//       String line = lines[i];
//       String lower = line.toLowerCase();

//       // Skip junk
//       if (junkKeywords.any((kw) => lower.contains(kw))) continue;
      
//       // Skip address-like lines
//       if (_isAddressLine(lower)) continue;
      
//       // Skip pure numbers/symbols
//       if (!RegExp(r'[a-zA-Z]{3,}').hasMatch(line)) continue;
      
//       // Skip lines with only date/time patterns
//       if (RegExp(r'^\d{1,2}[:/\-]\d{1,2}[:/\-]\d{2,4}').hasMatch(line)) continue;

//       // Must have reasonable length
//       if (line.length >= 3 && line.length <= 50) {
//         return line;
//       }
//     }

//     return "Unknown Merchant";
//   }

//   // ==================== DATE DETECTION ====================
//   static DateTime? _detectDate(String text) {
//     // Pattern 1: DD/MM/YYYY or MM/DD/YYYY
//     final dateSlash = RegExp(r'\b(\d{1,2})[/\-](\d{1,2})[/\-](\d{2,4})\b');
//     final matches = dateSlash.allMatches(text);
    
//     for (var match in matches) {
//       try {
//         int part1 = int.parse(match.group(1)!);
//         int part2 = int.parse(match.group(2)!);
//         int year = int.parse(match.group(3)!);
        
//         // Fix 2-digit year
//         if (year < 100) {
//           year += (year > 50) ? 1900 : 2000;
//         }

//         // Try DD/MM/YYYY first (more common internationally)
//         if (part1 >= 1 && part1 <= 31 && part2 >= 1 && part2 <= 12) {
//           try {
//             return DateTime(year, part2, part1);
//           } catch (_) {}
//         }
        
//         // Try MM/DD/YYYY (US format)
//         if (part1 >= 1 && part1 <= 12 && part2 >= 1 && part2 <= 31) {
//           try {
//             return DateTime(year, part1, part2);
//           } catch (_) {}
//         }
//       } catch (_) {}
//     }

//     // Pattern 2: YYYY-MM-DD (ISO format)
//     final isoDate = RegExp(r'\b(\d{4})-(\d{2})-(\d{2})\b');
//     final isoMatch = isoDate.firstMatch(text);
//     if (isoMatch != null) {
//       try {
//         return DateTime.parse(isoMatch.group(0)!);
//       } catch (_) {}
//     }

//     // Pattern 3: Written dates (Jan 15, 2024 or 15 Jan 2024)
//     final writtenDate = RegExp(
//       r'\b(\d{1,2})\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s+(\d{4})\b|'
//       r'\b(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s+(\d{1,2}),?\s+(\d{4})\b',
//       caseSensitive: false
//     );
//     final writtenMatch = writtenDate.firstMatch(text);
//     if (writtenMatch != null) {
//       try {
//         final monthMap = {
//           'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
//           'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12
//         };
        
//         if (writtenMatch.group(1) != null) {
//           // Format: 15 Jan 2024
//           int day = int.parse(writtenMatch.group(1)!);
//           String monthStr = writtenMatch.group(2)!.toLowerCase().substring(0, 3);
//           int month = monthMap[monthStr] ?? 1;
//           int year = int.parse(writtenMatch.group(3)!);
//           return DateTime(year, month, day);
//         } else {
//           // Format: Jan 15, 2024
//           String monthStr = writtenMatch.group(4)!.toLowerCase().substring(0, 3);
//           int month = monthMap[monthStr] ?? 1;
//           int day = int.parse(writtenMatch.group(5)!);
//           int year = int.parse(writtenMatch.group(6)!);
//           return DateTime(year, month, day);
//         }
//       } catch (_) {}
//     }

//     return null;
//   }

//   // ==================== ENHANCED TAX DETECTION ====================
//   static Map<String, dynamic> _detectTaxEnhanced(List<String> lines, String fullText) {
//     double totalTax = 0.0;
//     Map<String, double> breakdown = {};
    
//     final taxKeywords = {
//       'cgst': 'CGST',
//       'sgst': 'SGST', 
//       'igst': 'IGST',
//       'vat': 'VAT',
//       'tax': 'Tax',
//       'gst': 'GST',
//       'sales tax': 'Sales Tax',
//     };
    
//     // Start from middle (tax usually after items)
//     int startIdx = (lines.length * 0.4).floor();
    
//     for (int i = startIdx; i < lines.length; i++) {
//       String line = lines[i];
//       String lower = line.toLowerCase();
      
//       // Skip irrelevant lines
//       if (lower.contains('invoice') || lower.contains('number') || 
//           lower.contains('gstin') || lower.contains('gst no')) continue;
      
//       // Check each tax keyword
//       for (var entry in taxKeywords.entries) {
//         String keyword = entry.key;
//         String label = entry.value;
        
//         if (lower.contains(keyword)) {
//           // Extract all numbers from the line
//           List<double> amounts = _extractAllPrices(line);
          
//           // For percentage-based tax (e.g., "Tax 1 8.250 %")
//           if (lower.contains('%')) {
//             // Look for the actual amount, not the percentage
//             for (double amt in amounts) {
//               if (amt > 0 && amt < 10000 && !_isPercentage(amt)) {
//                 breakdown[label] = (breakdown[label] ?? 0.0) + amt;
//                 totalTax += amt;
//                 break;
//               }
//             }
//           } else {
//             // Regular tax amount
//             for (double amt in amounts) {
//               if (amt > 0 && amt < 10000) {
//                 breakdown[label] = (breakdown[label] ?? 0.0) + amt;
//                 totalTax += amt;
//                 break;
//               }
//             }
//           }
//         }
//       }
//     }
    
//     return {
//       'total': totalTax,
//       'breakdown': breakdown,
//     };
//   }

//   static bool _isPercentage(double val) {
//     // Common tax percentages
//     return val >= 1.0 && val <= 30.0 && (val % 0.25 == 0 || val % 0.5 == 0);
//   }

//   // ==================== ENHANCED TOTAL DETECTION ====================
//   static double _detectTotalEnhanced(List<String> lines, String fullText, 
//                                      List<ReceiptItem> items, double tax) {
//     final totalKeywords = [
//       'grand total', 'total purchase', 'net amount', 'amount due',
//       'balance due', 'total amount', 'total', 'net total'
//     ];

//     List<double> candidates = [];

//     // Search from bottom up (totals are usually at the end)
//     for (int i = lines.length - 1; i >= 0 && i >= lines.length - 20; i--) {
//       String line = lines[i];
//       String lower = line.toLowerCase();
      
//       // Check if line contains total keyword
//       bool isTotal = totalKeywords.any((kw) => lower.contains(kw));
      
//       // Exclude subtotals and savings
//       if (lower.contains('sub') && !lower.contains('grand')) continue;
//       if (lower.contains('saving')) continue;
      
//       if (isTotal) {
//         List<double> amounts = _extractAllPrices(line);
//         for (double amt in amounts) {
//           if (amt > 0) {
//             candidates.add(amt);
//           }
//         }
//       }
//     }

//     // Validate candidates against items and tax
//     if (candidates.isNotEmpty && items.isNotEmpty) {
//       double itemsSum = items.fold(0.0, (sum, item) => sum + item.amount);
//       double expectedTotal = itemsSum + tax;
      
//       // Find the candidate closest to expected total
//       candidates.sort((a, b) => 
//         (a - expectedTotal).abs().compareTo((b - expectedTotal).abs()));
      
//       double bestCandidate = candidates.first;
      
//       // If close enough, use it
//       if ((bestCandidate - expectedTotal).abs() < expectedTotal * 0.1) {
//         return bestCandidate;
//       }
//     }

//     // Return the largest candidate if found
//     if (candidates.isNotEmpty) {
//       return candidates.reduce((a, b) => a > b ? a : b);
//     }

//     // Fallback: Calculate from items + tax
//     if (items.isNotEmpty) {
//       double itemsSum = items.fold(0.0, (sum, item) => sum + item.amount);
//       return itemsSum + tax;
//     }

//     // Last resort: Find largest price
//     return _findLargestPrice(fullText);
//   }

//   // ==================== ENHANCED ITEM EXTRACTION ====================
//   static List<ReceiptItem> _extractItemsEnhanced(List<String> lines) {
//     List<ReceiptItem> items = [];
    
//     // Find the items section boundaries
//     int startIdx = _findItemsStartIndex(lines);
//     int endIdx = _findItemsEndIndex(lines, startIdx);

//     final stopWords = ['total', 'subtotal', 'tax', 'amount', 'balance', 'cash', 'card', 
//                        'change', 'thank', 'visit', 'items sold', 'quantity', 'cgst', 
//                        'sgst', 'igst', 'gst', 'cess', 'discount', 'savings'];

//     for (int i = startIdx; i < endIdx && i < lines.length; i++) {
//       String line = lines[i];
//       String lower = line.toLowerCase();

//       // Stop conditions
//       if (stopWords.any((w) => lower.startsWith(w))) break;
      
//       // Skip garbage lines
//       if (_isAddressLine(lower)) continue;
//       if (lower.contains('visa') || lower.contains('mastercard') || lower.contains('debit')) continue;
//       if (lower.contains('account') || lower.contains('network')) continue;
//       if (line.length < 3) continue;

//       // Try multiple parsing strategies
//       Map<String, dynamic>? itemData = _parseItemLineEnhanced(line);
      
//       if (itemData != null) {
//         double price = itemData['price'];
//         String desc = itemData['description'];
//         int qty = itemData['quantity'];
//         double unitPrice = itemData['unitPrice'] ?? price;
        
//         // Validation
//         if (price <= 0 || price > 100000) continue;
//         if (desc.isEmpty || desc.length < 2) continue;
        
//         // Skip if description is just numbers or codes
//         if (RegExp(r'^\d+$').hasMatch(desc)) continue;
        
//         // Avoid duplicates
//         if (items.any((item) => 
//             item.description.toLowerCase() == desc.toLowerCase() && 
//             (item.amount - price).abs() < 0.01)) {
//           continue;
//         }

//         items.add(ReceiptItem(desc, price, quantity: qty, unitPrice: unitPrice));
//       }
//     }

//     return items;
//   }

//   static Map<String, dynamic>? _parseItemLineEnhanced(String line) {
//     // Strategy 1: Standard format "DESCRIPTION PRICE X"
//     // e.g., "COM 2SET 088851018239 9.44 X"
//     var pattern1 = RegExp(r'^(.+?)\s+(\d+[,\.]?\d{0,2})\s*[A-Z]?\s*$');
//     var match = pattern1.firstMatch(line);
    
//     if (match != null) {
//       String desc = match.group(1)!.trim();
//       String priceStr = match.group(2)!.replaceAll(',', '');
      
//       // Ensure proper decimal format
//       if (!priceStr.contains('.') && priceStr.length > 2) {
//         priceStr = priceStr.substring(0, priceStr.length - 2) + '.' + 
//                    priceStr.substring(priceStr.length - 2);
//       }
      
//       double? price = double.tryParse(priceStr);
//       if (price == null) return null;
      
//       int qty = _extractQuantity(desc);
//       desc = _cleanDescription(desc);
      
//       return {
//         'description': desc,
//         'price': price * qty,
//         'quantity': qty,
//         'unitPrice': price
//       };
//     }

//     // Strategy 2: Quantity at start "2 X DESCRIPTION PRICE"
//     var pattern2 = RegExp(r'^(\d+)\s*[xX@]\s*(.+?)\s+(\d+[,\.]?\d{0,2})\s*$');
//     match = pattern2.firstMatch(line);
    
//     if (match != null) {
//       int qty = int.parse(match.group(1)!);
//       String desc = match.group(2)!.trim();
//       String priceStr = match.group(3)!.replaceAll(',', '');
      
//       if (!priceStr.contains('.') && priceStr.length > 2) {
//         priceStr = priceStr.substring(0, priceStr.length - 2) + '.' + 
//                    priceStr.substring(priceStr.length - 2);
//       }
      
//       double? price = double.tryParse(priceStr);
//       if (price == null) return null;
      
//       desc = _cleanDescription(desc);
      
//       return {
//         'description': desc,
//         'price': price,
//         'quantity': qty,
//         'unitPrice': price / qty
//       };
//     }

//     // Strategy 3: Table format "Item Qty Rate SGST CGST Amount"
//     // e.g., "Apple iPhone 12 (128GB) 1 50,000.00 4,500.00 4,500.00 0 59,000.00"
//     var pattern3 = RegExp(r'^(.+?)\s+(\d+)\s+([\d,]+\.\d{2})(?:\s+[\d,]+\.\d{2}){0,3}\s+([\d,]+\.\d{2})\s*$');
//     match = pattern3.firstMatch(line);
    
//     if (match != null) {
//       String desc = match.group(1)!.trim();
//       int qty = int.parse(match.group(2)!);
//       String rateStr = match.group(3)!.replaceAll(',', '');
//       String amountStr = match.group(4)!.replaceAll(',', '');
      
//       double? rate = double.tryParse(rateStr);
//       double? amount = double.tryParse(amountStr);
      
//       if (rate == null || amount == null) return null;
      
//       desc = _cleanDescription(desc);
      
//       return {
//         'description': desc,
//         'price': amount,
//         'quantity': qty,
//         'unitPrice': rate
//       };
//     }

//     return null;
//   }

//   static int _findItemsStartIndex(List<String> lines) {
//     // Look for table headers
//     for (int i = 0; i < lines.length && i < 25; i++) {
//       String lower = lines[i].toLowerCase();
      
//       bool hasItemCol = lower.contains('item') || lower.contains('description') || 
//                         lower.contains('article') || lower.contains('particular');
//       bool hasPriceCol = lower.contains('price') || lower.contains('amount') || 
//                          lower.contains('rate') || lower.contains('total') ||
//                          lower.contains('qty');
      
//       if ((hasItemCol && hasPriceCol) || lower.contains('qty')) {
//         return i + 1;
//       }
//     }
    
//     // Fallback: skip header portion
//     return (lines.length * 0.2).floor().clamp(5, 15);
//   }

//   static int _findItemsEndIndex(List<String> lines, int startIdx) {
//     // Look for footer markers
//     for (int i = startIdx; i < lines.length; i++) {
//       String lower = lines[i].toLowerCase();
//       if (lower.startsWith('sub') || lower.startsWith('total') || 
//           lower.contains('items sold') || lower.contains('cgst') ||
//           lower.contains('sgst') || lower.contains('tax')) {
//         return i;
//       }
//     }
//     return lines.length;
//   }

//   static int _extractQuantity(String text) {
//     // Look for patterns like "2 X", "QTY 3", "3x", "2PK", "4PK"
//     final qtyPattern = RegExp(
//       r'\b(\d+)\s*[xX@]|QTY\s*[:=]?\s*(\d+)|(\d+)PK\b',
//       caseSensitive: false
//     );
//     var match = qtyPattern.firstMatch(text);
//     if (match != null) {
//       String? qty = match.group(1) ?? match.group(2) ?? match.group(3);
//       if (qty != null) {
//         return int.parse(qty);
//       }
//     }
//     return 1;
//   }

//   static String _cleanDescription(String desc) {
//     // Remove UPC codes (8+ digits)
//     desc = desc.replaceAll(RegExp(r'\b\d{8,}\b'), '');
    
//     // Remove HSN/SAC codes
//     desc = desc.replaceAll(RegExp(r'HSN/SAC:\s*\w+', caseSensitive: false), '');
    
//     // Remove quantity markers
//     desc = desc.replaceAll(RegExp(r'^\d+\s*[xX@]\s*'), '');
//     desc = desc.replaceAll(RegExp(r'\bQTY\s*[:=]?\s*\d+\b', caseSensitive: false), '');
//     desc = desc.replaceAll(RegExp(r'\d+PK\b', caseSensitive: false), '');
    
//     // Remove currency symbols
//     desc = desc.replaceAll(RegExp(r'[₹$£€]|Rs\.?|INR', caseSensitive: false), '');
    
//     // Remove trailing single letters (flags like N, T, F, X)
//     desc = desc.replaceAll(RegExp(r'\s+[A-Z]$'), '');
    
//     // Remove "COM" prefix (common in Walmart receipts)
//     desc = desc.replaceAll(RegExp(r'^COM\s+', caseSensitive: false), '');
    
//     return desc.trim();
//   }

//   // ==================== UTILITY FUNCTIONS ====================
  
//   static bool _isAddressLine(String lower) {
//     final addressKeywords = [
//       'road', 'street', 'floor', 'avenue', 'drive', 'lane', 'blvd',
//       'opp', 'near', 'behind', 'dist', 'state', 'pin', 'zip', 'court',
//       'mumbai', 'delhi', 'bangalore', 'maharashtra', 'texas', 'california',
//       'india', 'usa', 'uk', 'marg', 'nagar', 'talao', 'dhobi'
//     ];
//     return addressKeywords.any((kw) => lower.contains(kw));
//   }

//   static List<double> _extractAllPrices(String line) {
//     List<double> prices = [];
    
//     // Pattern for prices with decimal
//     final regex = RegExp(r'(\d+[,\d]*\.\d{2})');
//     final matches = regex.allMatches(line);
    
//     for (var match in matches) {
//       String numStr = match.group(1)!.replaceAll(',', '');
//       double? val = double.tryParse(numStr);
//       if (val != null && val > 0) {
//         prices.add(val);
//       }
//     }
    
//     // If no decimal found, try integers (but convert to double)
//     if (prices.isEmpty) {
//       final intRegex = RegExp(r'\b(\d{1,6})\b');
//       final intMatches = intRegex.allMatches(line);
//       for (var match in intMatches) {
//         double? val = double.tryParse(match.group(1)!);
//         if (val != null && val > 0 && val < 1000000) {
//           prices.add(val);
//         }
//       }
//     }
    
//     return prices;
//   }

//   static double _extractLargestNumber(String line) {
//     List<double> prices = _extractAllPrices(line);
//     if (prices.isEmpty) return 0.0;
//     return prices.reduce((a, b) => a > b ? a : b);
//   }

//   static double _findLargestPrice(String text) {
//     final regex = RegExp(r'\d+[,\d]*\.\d{2}');
//     final matches = regex.allMatches(text);
    
//     double maxVal = 0.0;
//     for (var match in matches) {
//       String numStr = match.group(0)!.replaceAll(',', '');
//       double? val = double.tryParse(numStr);
//       if (val != null && val > maxVal && val < 1000000) {
//         maxVal = val;
//       }
//     }
//     return maxVal;
//   }

//   static String _categorizeReceipt(String merchant, List<ReceiptItem> items, String fullText) {
//     String lower = merchant.toLowerCase() + ' ' + fullText.toLowerCase();
    
//     // Food & Grocery
//     if (lower.contains('walmart') || lower.contains('costco') || 
//         lower.contains('dmart') || lower.contains('reliance fresh') ||
//         lower.contains('grocery') || lower.contains('supermarket') || 
//         lower.contains('food') || lower.contains('mart')) {
//       return 'Grocery';
//     }
    
//     // Electronics & Digital
//     if (lower.contains('reliance digital') || lower.contains('best buy') || 
//         lower.contains('electronics') || lower.contains('iphone') ||
//         lower.contains('laptop') || lower.contains('mobile')) {
//       return 'Electronics';
//     }
    
//     // Pharmacy
//     if (lower.contains('pharmacy') || lower.contains('cvs') || 
//         lower.contains('walgreens') || lower.contains('medicine')) {
//       return 'Healthcare';
//     }
    
//     // Restaurant
//     if (lower.contains('restaurant') || lower.contains('cafe') || 
//         lower.contains('starbucks') || lower.contains('mcdonald')) {
//       return 'Dining';
//     }
    
//     // Retail
//     if (lower.contains('depot') || lower.contains('target')) {
//       return 'Retail';
//     }
    
//     return 'General';
//   }

//   static double _calculateConfidence(String merchant, DateTime? date, 
//                                      double total, List<ReceiptItem> items, 
//                                      List<String> warnings) {
//     double score = 0.0;
    
//     if (merchant != "Unknown Merchant") score += 0.25;
//     if (date != null) score += 0.15;
//     if (total > 0) score += 0.30;
//     if (items.isNotEmpty) score += 0.20;
//     if (warnings.isEmpty) score += 0.10;
    
//     return score.clamp(0.0, 1.0);
//   }
// }

// ==================== DATA MODELS ====================
class ReceiptData {
  String merchant;
  DateTime? date;
  double totalAmount;
  double taxAmount;
  List<ReceiptItem> items;
  String category;
  Map<String, double> taxBreakdown;

  ReceiptData({
    required this.merchant,
    this.date,
    required this.totalAmount,
    required this.taxAmount,
    required this.items,
    required this.category,
    this.taxBreakdown = const {},
  });
}

class ReceiptItem {
  String description;
  double amount;
  int quantity;
  double unitPrice;

  ReceiptItem(
    this.description,
    this.amount, {
    this.quantity = 1,
    double? unitPrice,
  }) : unitPrice = unitPrice ?? amount;
}

class ParseResult {
  final ReceiptData data;
  final double confidence;
  final List<String> warnings;

  ParseResult({
    required this.data,
    required this.confidence,
    this.warnings = const [],
  });
}

// ==================== MAIN PARSER ====================
class ImprovedReceiptParser {
  static final Map<String, List<String>> _merchantPatterns = {
    'Walmart': ['walmart', 'wal-mart'],
    'Target': ['target'],
    'Costco': ['costco'],
    'CVS': ['cvs'],
    'Walgreens': ['walgreens'],
    'Starbucks': ['starbucks'],
    'McDonald\'s': ['mcdonald'],
    'Home Depot': ['home depot'],
    'Best Buy': ['best buy'],
    'Reliance': ['reliance'],
    'DMart': ['dmart', 'd-mart'],
    'Big Bazaar': ['big bazaar'],
    'Spencer\'s': ['spencer'],
    'More': ['more'],
  };

  static ParseResult parse(String rawText) {
    print("\n=== RECEIPT PARSING STARTED ===");
    
    List<String> warnings = [];
    String normalizedText = _normalizeText(rawText);
    List<String> lines = normalizedText.split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    print("Lines to parse: ${lines.length}");

    // Parse components
    String merchant = _detectMerchant(lines, normalizedText);
    DateTime? date = _detectDate(normalizedText);
    List<ReceiptItem> items = _extractItems(lines);
    var taxData = _detectTax(lines);
    double tax = taxData['total'];
    Map<String, double> taxBreakdown = taxData['breakdown'];
    double total = _detectTotal(lines, items, tax);
    String category = _categorizeReceipt(merchant, items, normalizedText);

    // Warnings
    if (merchant == "Unknown Merchant") warnings.add("Could not identify merchant");
    if (date == null) warnings.add("Could not parse date");
    if (items.isEmpty) warnings.add("No line items found");

    double confidence = _calculateConfidence(merchant, date, total, items, warnings);

    print("Parsed: $merchant | ${items.length} items | Total: ₹$total");
    print("=== PARSING COMPLETE ===\n");

    return ParseResult(
      data: ReceiptData(
        merchant: merchant,
        date: date,
        totalAmount: total,
        taxAmount: tax,
        items: items,
        category: category,
        taxBreakdown: taxBreakdown,
      ),
      confidence: confidence,
      warnings: warnings,
    );
  }

  static String _normalizeText(String text) {
    text = text.replaceAll(RegExp(r'[ \t]+'), ' ');
    text = text.replaceAll('|', 'I');
    text = text.replaceAll('О', '0');
    text = text.replaceAll('о', '0');
    return text;
  }

  static String _detectMerchant(List<String> lines, String fullText) {
    // Known patterns
    for (int i = 0; i < lines.length && i < 20; i++) {
      String lower = lines[i].toLowerCase();
      for (var entry in _merchantPatterns.entries) {
        for (var pattern in entry.value) {
          if (lower.contains(pattern)) return entry.key;
        }
      }
    }

    // Heuristic
    final skip = ['invoice', 'receipt', 'bill', 'gstin', 'phone', 'www', 'date', 'time'];
    for (int i = 0; i < 10 && i < lines.length; i++) {
      String line = lines[i];
      String lower = line.toLowerCase();
      
      if (line.length < 3 || line.length > 50) continue;
      if (skip.any((k) => lower.contains(k))) continue;
      if (_isAddressLine(lower)) continue;
      if (!RegExp(r'[a-zA-Z]{3,}').hasMatch(line)) continue;
      
      return line;
    }

    return "Unknown Merchant";
  }

  static DateTime? _detectDate(String text) {
    final datePattern = RegExp(r'\b(\d{1,2})[/\-](\d{1,2})[/\-](\d{2,4})\b');
    for (var match in datePattern.allMatches(text)) {
      try {
        int p1 = int.parse(match.group(1)!);
        int p2 = int.parse(match.group(2)!);
        int year = int.parse(match.group(3)!);
        if (year < 100) year += (year > 50 ? 1900 : 2000);
        
        if (p1 <= 31 && p2 <= 12) {
          try { return DateTime(year, p2, p1); } catch (_) {}
        }
        if (p1 <= 12 && p2 <= 31) {
          try { return DateTime(year, p1, p2); } catch (_) {}
        }
      } catch (_) {}
    }
    return null;
  }

  static Map<String, dynamic> _detectTax(List<String> lines) {
    double total = 0.0;
    Map<String, double> breakdown = {};
    
    final keywords = {'cgst': 'CGST', 'sgst': 'SGST', 'igst': 'IGST', 'gst': 'GST', 'tax': 'Tax'};
    
    for (var line in lines) {
      String lower = line.toLowerCase();
      if (lower.contains('gstin') || lower.contains('invoice')) continue;
      
      for (var entry in keywords.entries) {
        if (lower.contains(entry.key)) {
          var amounts = _extractPrices(line);
          for (var amt in amounts) {
            if (amt > 0 && amt < 50000) {
              breakdown[entry.value] = (breakdown[entry.value] ?? 0) + amt;
              total += amt;
              break;
            }
          }
        }
      }
    }
    
    return {'total': total, 'breakdown': breakdown};
  }

  static double _detectTotal(List<String> lines, List<ReceiptItem> items, double tax) {
    List<double> candidates = [];
    
    for (int i = lines.length - 1; i >= 0 && i >= lines.length - 20; i--) {
      String lower = lines[i].toLowerCase();
      
      if (lower.contains('total') && !lower.contains('sub')) {
        candidates.addAll(_extractPrices(lines[i]));
      }
    }

    if (candidates.isNotEmpty) {
      candidates.sort((a, b) => b.compareTo(a));
      return candidates.first;
    }

    if (items.isNotEmpty) {
      return items.fold(0.0, (sum, item) => sum + item.amount) + tax;
    }

    return _findLargestPrice(lines.join(' '));
  }

  static List<ReceiptItem> _extractItems(List<String> lines) {
    List<ReceiptItem> items = [];
    int start = _findItemsStart(lines);
    int end = _findItemsEnd(lines, start);

    print("Extracting items from lines $start to $end");

    for (int i = start; i < end && i < lines.length; i++) {
      String line = lines[i];
      String lower = line.toLowerCase();

      if (lower.startsWith('total') || lower.startsWith('tax') || 
          lower.startsWith('cgst') || lower.startsWith('sgst')) {
        break;
      }
      
      if (line.length < 5 || _isAddressLine(lower)) continue;

      var item = _parseItemLine(line);
      if (item != null) {
        items.add(item);
        print("  Item: ${item.description} = ₹${item.amount}");
      }
    }

    return items;
  }

  static ReceiptItem? _parseItemLine(String line) {
    // Pattern 1: "DESCRIPTION PRICE"
    var p1 = RegExp(r'^(.+?)\s+(\d+(?:[,\.]\d{2})?)\s*[A-Z]?\s*$');
    var m = p1.firstMatch(line);
    if (m != null) {
      String desc = _cleanDesc(m.group(1)!);
      String priceStr = m.group(2)!.replaceAll(',', '.');
      double? price = double.tryParse(priceStr);
      
      if (price != null && price > 0 && desc.length >= 2) {
        return ReceiptItem(desc, price);
      }
    }

    // Pattern 2: "QTY x DESCRIPTION PRICE"
    var p2 = RegExp(r'^(\d+)\s*[xX@]\s*(.+?)\s+(\d+(?:[,\.]\d{2})?)\s*$');
    m = p2.firstMatch(line);
    if (m != null) {
      int qty = int.parse(m.group(1)!);
      String desc = _cleanDesc(m.group(2)!);
      String priceStr = m.group(3)!.replaceAll(',', '.');
      double? price = double.tryParse(priceStr);
      
      if (price != null && price > 0 && desc.length >= 2) {
        return ReceiptItem(desc, price, quantity: qty);
      }
    }

    // Pattern 3: Extract from multiple numbers
    var prices = _extractPrices(line);
    if (prices.isNotEmpty) {
      double price = prices.last;
      String desc = line.replaceAll(RegExp(r'[\d\.,₹Rs]+'), ' ').trim();
      desc = _cleanDesc(desc);
      
      if (desc.length >= 3 && price > 0) {
        return ReceiptItem(desc, price);
      }
    }

    return null;
  }

  static int _findItemsStart(List<String> lines) {
    for (int i = 0; i < 25 && i < lines.length; i++) {
      String lower = lines[i].toLowerCase();
      if ((lower.contains('item') || lower.contains('description')) &&
          (lower.contains('price') || lower.contains('amount') || lower.contains('qty'))) {
        return i + 1;
      }
    }
    return (lines.length * 0.15).floor().clamp(3, 10);
  }

  static int _findItemsEnd(List<String> lines, int start) {
    for (int i = start; i < lines.length; i++) {
      String lower = lines[i].toLowerCase();
      if (lower.contains('subtotal') || lower.contains('total items') ||
          lower.contains('cgst') || lower.contains('sgst') ||
          (lower.startsWith('total') && lower.length < 20)) {
        return i;
      }
    }
    return lines.length - 10;
  }

  static String _cleanDesc(String desc) {
    desc = desc.replaceAll(RegExp(r'\b\d{8,}\b'), '');
    desc = desc.replaceAll(RegExp(r'HSN|SAC', caseSensitive: false), '');
    desc = desc.replaceAll(RegExp(r'^\d+\s*[xX@]\s*'), '');
    desc = desc.replaceAll(RegExp(r'[₹$£€Rs]', caseSensitive: false), '');
    desc = desc.replaceAll(RegExp(r'\s+[A-Z]$'), '');
    desc = desc.replaceAll(RegExp(r'\s+'), ' ');
    return desc.trim();
  }

  static bool _isAddressLine(String lower) {
    final keywords = ['road', 'street', 'floor', 'marg', 'nagar', 'pin', 'mumbai', 'delhi'];
    return keywords.any((k) => lower.contains(k));
  }

  static List<double> _extractPrices(String line) {
    List<double> prices = [];
    final pattern = RegExp(r'\d{1,3}(?:,\d{3})*\.\d{2}|\d+\.\d{2}');
    
    for (var m in pattern.allMatches(line)) {
      String numStr = m.group(0)!.replaceAll(',', '');
      double? val = double.tryParse(numStr);
      if (val != null && val > 0) prices.add(val);
    }
    
    return prices;
  }

  static double _findLargestPrice(String text) {
    final prices = _extractPrices(text);
    return prices.isEmpty ? 0.0 : prices.reduce((a, b) => a > b ? a : b);
  }

  static String _categorizeReceipt(String merchant, List<ReceiptItem> items, String text) {
    String lower = '$merchant $text'.toLowerCase();
    
    if (lower.contains('grocery') || lower.contains('dmart') || lower.contains('reliance fresh')) {
      return 'Grocery';
    }
    if (lower.contains('electronics') || lower.contains('digital') || lower.contains('mobile')) {
      return 'Electronics';
    }
    if (lower.contains('pharmacy') || lower.contains('medicine')) {
      return 'Healthcare';
    }
    if (lower.contains('restaurant') || lower.contains('cafe') || lower.contains('food')) {
      return 'Dining';
    }
    
    return 'General';
  }

  static double _calculateConfidence(String merchant, DateTime? date, 
                                     double total, List<ReceiptItem> items, 
                                     List<String> warnings) {
    double score = 0.0;
    if (merchant != "Unknown Merchant") score += 0.25;
    if (date != null) score += 0.15;
    if (total > 0) score += 0.30;
    if (items.isNotEmpty) score += 0.20;
    if (warnings.isEmpty) score += 0.10;
    return score.clamp(0.0, 1.0);
  }
}