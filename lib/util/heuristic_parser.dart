// import 'package:bill_buddy/util/recipt_logic.dart';



// // class HeuristicParser {

// //   // ===================== ENTRY POINT =====================
// //   static ParseResult parse(String rawText) {
// //     // 1. Deep Cleaning: Remove noise characters often introduced by OCR
// //     final cleanedLines = _preprocessText(rawText);

// //     // 2. Run Strategies
// //     final merchant = _detectMerchant(cleanedLines);
// //     final date = _detectDate(rawText);
    
// //     // 3. The "Anchor": Finding the Total helps us validate everything else
// //     final total = _detectTotal(cleanedLines, rawText);
    
// //     // 4. Tax Logic: Look for detailed tax breakdowns
// //     final tax = _detectTax(cleanedLines);
    
// //     // 5. Item Extraction: The most complex part
// //     final items = _extractItems(cleanedLines, total, tax);

// //     // 6. Confidence Scoring
// //     final confidence = _calculateConfidence(
// //       merchant: merchant,
// //       date: date,
// //       total: total,
// //       tax: tax,
// //       items: items,
// //     );

// //     return ParseResult(
// //       data: ReceiptData(
// //         merchant: merchant,
// //         date: date,
// //         totalAmount: total,
// //         taxAmount: tax,
// //         items: items,
// //         category: "General",
// //       ),
// //       confidence: confidence,
// //     );
// //   }

// //   // ===================== 1. PRE-PROCESSING =====================
// //   static List<String> _preprocessText(String text) {
// //     return text.split('\n').map((line) {
// //       // Remove common OCR noise but keep currency logic safe
// //       // e.g., "| 50.00" -> "50.00"
// //       String cleaned = line.trim().replaceAll('|', ''); 
// //       return cleaned;
// //     }).where((l) => l.trim().length > 1).toList(); // Remove empty or single-char lines
// //   }

// //   // ===================== 2. MERCHANT STRATEGY =====================
// //   static String _detectMerchant(List<String> lines) {
// //     // Words that indicate a line is NOT a merchant name
// //     final blockList = [
// //       'TAX INVOICE', 'RECEIPT', 'BILL', 'CASH MEMO', 'INVOICE',
// //       'GSTIN', 'GST NO', 'VAT NO', 'TIN', 'PAN NO', 'CIN',
// //       'PH:', 'MO:', 'TEL:', 'MOB', 'EMAIL', 'WEB', 'HTTP', 'WWW',
// //       'DATE', 'TIME', 'TABLE', 'ORDER', 'TOKEN',
// //       'COPY', 'ORIGINAL', 'DUPLICATE',
// //       'ROAD', 'STREET', 'FLOOR', 'OPP', 'NEAR', 'BEHIND', // Address markers
// //       'DIST', 'STATE', 'INDIA', 'USA', 'PIN', 'ZIP'
// //     ];

// //     // Look deeper (first 10 lines) because logos sometimes push text down
// //     int maxLinesToCheck = lines.length < 10 ? lines.length : 10;

// //     for (int i = 0; i < maxLinesToCheck; i++) {
// //       String line = lines[i];
// //       String upper = line.toUpperCase();

// //       // 1. Skip Blocklisted lines
// //       if (blockList.any((word) => upper.contains(word))) continue;

// //       // 2. Skip lines that are purely numeric/dates (e.g. "12-10-2023")
// //       if (RegExp(r'^[\d\s\-\/\.,:xX]+$').hasMatch(line)) continue;

// //       // 3. Skip lines that look like prices (e.g. "500.00")
// //       if (RegExp(r'^\d+[\.,]\d{2}$').hasMatch(line)) continue;

// //       // 4. Must contain letters
// //       if (!RegExp(r'[A-Za-z]').hasMatch(line)) continue;

// //       // 5. Length Check (Merchant names are rarely 2 chars)
// //       if (line.length < 3) continue;

// //       // 6. "Welcome to" Logic: If line says "Welcome to Walmart", extract "Walmart"
// //       if (upper.contains('WELCOME TO')) {
// //         return line.replaceAll(RegExp(r'Welcome to', caseSensitive: false), '').trim();
// //       }

// //       // If it survives all checks, it's our best guess
// //       return line.trim();
// //     }
// //     return "Unknown Merchant";
// //   }

// //   // ===================== 3. DATE STRATEGY =====================
// //   static DateTime? _detectDate(String text) {
// //     // Pattern 1: DD/MM/YYYY or YYYY-MM-DD
// //     final numericRegex = RegExp(r'\b(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})\b');
    
// //     // Pattern 2: Text Months (02 Feb 2023 or Feb 02, 2023)
// //     final textMonthRegex = RegExp(
// //       r'\b(\d{1,2})[\s-](Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*[\s-](\d{2,4})\b', 
// //       caseSensitive: false
// //     );

// //     // Try Numeric First
// //     final numMatch = numericRegex.firstMatch(text);
// //     if (numMatch != null) {
// //       try {
// //         String d = numMatch.group(0)!.replaceAll('/', '-');
// //         List<String> parts = d.split('-');
// //         // YYYY-MM-DD
// //         if (parts[0].length == 4) return DateTime.parse(d);
// //         // DD-MM-YYYY
// //         if (parts[2].length == 4) return DateTime.parse("${parts[2]}-${parts[1]}-${parts[0]}");
// //       } catch (_) {}
// //     }

// //     // Try Text Month (e.g. 12-Oct-2023)
// //     final textMatch = textMonthRegex.firstMatch(text);
// //     if (textMatch != null) {
// //       // Parsing text months is complex in Dart without Intl, so we return null 
// //       // or implement a map. For now, returning null will default to "Today" in UI, 
// //       // which is safer than crashing.
// //       // (You can add a month-map here if needed)
// //     }

// //     return null;
// //   }

// //   // ===================== 4. TOTAL STRATEGY =====================
// //   static double _detectTotal(List<String> lines, String fullText) {
// //     // 1. Keyword Search (Bottom-Up)
// //     final keywords = [
// //       'GRAND TOTAL', 'NET AMOUNT', 'AMOUNT PAYABLE', 'BALANCE DUE', 
// //       'TOTAL PAID', 'BILL AMOUNT', 'TOTAL' // Keep generic "TOTAL" last
// //     ];

// //     for (var line in lines.reversed) {
// //       String upper = line.toUpperCase();
// //       for (var keyword in keywords) {
// //         if (upper.contains(keyword)) {
// //           // Special Case: "Total Savings" is NOT the bill total
// //           if (upper.contains('SAVING')) continue;
          
// //           double val = _extractLastNumber(line);
// //           if (val > 0) return val;
// //         }
// //       }
// //     }

// //     // 2. Largest Number Fallback (Heuristic)
// //     // Most receipts' largest number is the total.
// //     return _findLargestNumber(fullText);
// //   }

// //   // ===================== 5. TAX STRATEGY =====================
// //   static double _detectTax(List<String> lines) {
// //     double totalTax = 0.0;
// //     // Scan bottom half only
// //     int start = (lines.length / 2).floor();

// //     for (int i = start; i < lines.length; i++) {
// //       String line = lines[i].toUpperCase();

// //       // Skip invalid lines
// //       if (line.contains('INVOICE') || line.contains('NO:')) continue;

// //       // Look for tax keywords
// //       if (line.contains('GST') || line.contains('VAT') || line.contains('TAX')) {
// //         // "Taxable Value" is NOT the tax amount. It's the base amount.
// //         if (line.contains('VALUE') || line.contains('GROSS')) continue;

// //         double val = _extractLastNumber(line);
        
// //         // Sanity Check: Tax is usually smaller than 50% of a typical bill
// //         // If we picked up a huge number, it's likely wrong.
// //         if (val > 0 && val < 500000) {
// //           totalTax += val;
// //         }
// //       }
// //     }
// //     return totalTax;
// //   }

// //   // ===================== 6. ITEM EXTRACTION (ADVANCED) =====================
// //   static List<ReceiptItem> _extractItems(List<String> lines, double total, double tax) {
// //     List<ReceiptItem> items = [];
    
// //     // STOPPING CONDITIONS
// //     final footerKeywords = ['TOTAL', 'SUB', 'AMOUNT', 'GST', 'TAX', 'THANK', 'VISIT', 'BALANCE', 'CARD', 'CASH', 'CHANGE'];

// //     // FIND STARTING POINT (Header Detection)
// //     // We look for a line like "Item  Qty  Price  Amount"
// //     int startIndex = 4; // Default heuristic
// //     for (int i = 0; i < lines.length; i++) {
// //       String line = lines[i].toUpperCase();
// //       if ((line.contains('ITEM') || line.contains('PARTICULARS') || line.contains('DESC')) && 
// //           (line.contains('PRICE') || line.contains('AMOUNT') || line.contains('RATE'))) {
// //         startIndex = i + 1; // Start strictly after header
// //         break;
// //       }
// //     }

// //     for (int i = startIndex; i < lines.length; i++) {
// //       String line = lines[i];
// //       String upper = line.toUpperCase();

// //       // 1. Check if we hit the footer
// //       if (footerKeywords.any((k) => upper.contains(k))) break;

// //       // 2. Filter Trash
// //       if (line.length < 3) continue; // Skip "---" or ".." lines
// //       if (!RegExp(r'\d').hasMatch(line)) continue; // Must have at least one digit

// //       // 3. Extract Price
// //       double price = _extractLastNumber(line);

// //       // 4. Validate Price
// //       if (price <= 0) continue;
// //       if (price == total) continue; // Should not equal Grand Total
// //       if (price == tax) continue;   // Should not equal Tax Amount

// //       // 5. Clean Name
// //       String name = _cleanItemName(line);

// //       // 6. Final Filter
// //       if (name.length > 2 && !name.toUpperCase().contains('TOTAL')) {
// //         items.add(ReceiptItem(name, price));
// //       }
// //     }
// //     return items;
// //   }

// //   // ===================== UTILITIES =====================

// //   /// Extracts the number at the very end of the line.
// //   /// Handles: "59,000.00", "9.44 X", "Rs. 100"
// //   static double _extractLastNumber(String line) {
// //     try {
// //       // Remove currency symbols and noise characters
// //       // We keep digits, dots, commas, and spaces
// //       String cleaned = line.replaceAll(RegExp(r'[^\d\.,\s]'), '');
      
// //       List<String> parts = cleaned.trim().split(RegExp(r'\s+'));
      
// //       // Iterate right-to-left
// //       for (String part in parts.reversed) {
// //         // Fix trailing punctuation (e.g. "500.")
// //         if (part.endsWith('.')) part = part.substring(0, part.length - 1);
// //         if (part.endsWith(',')) part = part.substring(0, part.length - 1);
        
// //         // Remove internal commas (e.g. "59,000")
// //         String numStr = part.replaceAll(',', '');
        
// //         double? val = double.tryParse(numStr);
// //         // Valid price check (rarely is a receipt item 0.00 or massive integer like a barcode)
// //         if (val != null) return val;
// //       }
// //     } catch (_) {}
// //     return 0.0;
// //   }

// //   static String _cleanItemName(String line) {
// //     // 1. Remove the price from the end
// //     // Logic: Regex finds the last number cluster
// //     String name = line.replaceAll(RegExp(r'[\d,]+\.?\d*\s*[a-zA-Z]?\s*$'), '');

// //     // 2. Remove Quantities from start (e.g. "1 x", "2 @")
// //     name = name.replaceAll(RegExp(r'^\d+\s*[xX@]\s*'), '');
    
// //     // 3. Remove Barcodes/UPC (Big number strings)
// //     name = name.replaceAll(RegExp(r'\b\d{8,}\b'), '');

// //     // 4. Remove Currency symbols
// //     name = name.replaceAll(RegExp(r'(Rs\.?|INR|₹|\$|EUR|USD)', caseSensitive: false), '');

// //     return name.trim();
// //   }

// //   static double _findLargestNumber(String fullText) {
// //     final regex = RegExp(r'[\d,]+\.\d{2}');
// //     final matches = regex.allMatches(fullText);
// //     double maxVal = 0.0;
// //     for (final match in matches) {
// //       String str = match.group(0)!.replaceAll(',', '');
// //       double? val = double.tryParse(str);
// //       if (val != null && val > maxVal && val < 1000000) maxVal = val;
// //     }
// //     return maxVal;
// //   }

// //   static double _calculateConfidence({
// //     required String merchant,
// //     required DateTime? date,
// //     required double total,
// //     required double tax,
// //     required List<ReceiptItem> items,
// //   }) {
// //     double score = 0.0;
// //     if (merchant != "Unknown Merchant") score += 0.2;
// //     if (date != null) score += 0.15;
// //     if (total > 0) score += 0.35;
// //     if (items.isNotEmpty) score += 0.2;
    
// //     // Mathematical Confidence: Do items sum up to Total?
// //     double itemsSum = items.fold(0, (prev, e) => prev + e.amount);
// //     if (itemsSum > 0 && (itemsSum + tax - total).abs() < 5.0) {
// //       score += 0.1; // Bonus confidence if math works out
// //     }
    
// //     return score.clamp(0.0, 1.0);
// //   }
// // }

// // class ParseResult {
// //   final ReceiptData data;
// //   final double confidence;
// //   ParseResult({required this.data, required this.confidence});
// // }

// // import 'receipt_parser.dart';

// class HeuristicParser {

//   static ParseResult parse(String rawText) {
//     // 1. Clean & Split
//     final lines = rawText.split('\n')
//         .map((l) => l.trim())
//         .where((l) => l.isNotEmpty)
//         .toList();

//     // 2. Extract Data
//     final merchant = _detectMerchant(lines);
//     final date = _detectDate(rawText);
//     final total = _detectTotal(lines, rawText);
//     final tax = _detectTax(lines);
    
//     // 3. Extract Items (With strict Address Filtering)
//     final items = _extractItems(lines, total, tax);

//     // 4. Score
//     final confidence = _calculateConfidence(merchant, total, items);

//     return ParseResult(
//       data: ReceiptData(
//         merchant: merchant,
//         date: date,
//         totalAmount: total,
//         taxAmount: tax,
//         items: items,
//         category: "General",
//       ),
//       confidence: confidence,
//     );
//   }

//   // ===================== MERCHANT =====================
//   static String _detectMerchant(List<String> lines) {
//     // Blocklist: Words that look like merchants but aren't
//     final blockList = [
//       'TAX INVOICE', 'RECEIPT', 'BILL', 'CASH MEMO', 'INVOICE',
//       'GSTIN', 'PH:', 'MO:', 'TEL:', 'WEB', 'WWW', 'DATE', 'TIME',
//       'COPY', 'ORIGINAL', 'DUPLICATE', 'WELCOME', 'STORE', 'MANAGER'
//     ];

//     for (int i = 0; i < lines.length && i < 8; i++) {
//       String line = lines[i];
//       String upper = line.toUpperCase();

//       // Skip blocklist
//       if (blockList.any((word) => upper.contains(word))) continue;
//       // Skip Address Lines (Fix for Walmart/Reliance)
//       if (_isAddressLine(upper)) continue;
//       // Skip Dates/Numbers
//       if (RegExp(r'^[\d\s\-\/\.,:xX]+$').hasMatch(line)) continue;
//       // Must have letters
//       if (!RegExp(r'[A-Za-z]').hasMatch(line)) continue;

//       // Special Case: "Reliance Digital" often has a logo that OCR misses,
//       // but text usually appears right after headers.
//       // We return the first clean line we find.
//       return line;
//     }
//     return "Unknown Merchant";
//   }

//   // ===================== DATE =====================
//   static DateTime? _detectDate(String text) {
//     final regex = RegExp(r'\b(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})\b');
//     final match = regex.firstMatch(text);
//     if (match != null) {
//       try {
//         String d = match.group(0)!.replaceAll('/', '-');
//         List<String> parts = d.split('-');
//         if (parts[0].length == 4) return DateTime.parse(d);
//         if (parts[2].length == 4) return DateTime.parse("${parts[2]}-${parts[1]}-${parts[0]}");
//       } catch (_) {}
//     }
//     return null;
//   }

//   // ===================== TOTAL =====================
//   static double _detectTotal(List<String> lines, String fullText) {
//     final keywords = ['GRAND TOTAL', 'NET AMOUNT', 'PAYABLE', 'BALANCE DUE', 'TOTAL'];
    
//     for (var line in lines.reversed) {
//       String upper = line.toUpperCase();
//       if (keywords.any((k) => upper.contains(k))) {
//         // Ignore "Total Savings" or "Subtotal" lines
//         if (upper.contains('SAVING') || upper.contains('SUB')) continue;
        
//         double val = _extractPrice(line);
//         if (val > 0) return val;
//       }
//     }
//     // Fallback: Largest number that looks like a price
//     return _findLargestPrice(fullText);
//   }

//   // ===================== TAX =====================
//   static double _detectTax(List<String> lines) {
//     double totalTax = 0.0;
//     int start = (lines.length / 2).floor(); // Only look at bottom half

//     for (int i = start; i < lines.length; i++) {
//       String upper = lines[i].toUpperCase();
//       if (upper.contains('GST') || upper.contains('TAX') || upper.contains('VAT')) {
//         if (upper.contains('INVOICE') || upper.contains('NO:')) continue; // Skip "GST No:"
        
//         double val = _extractPrice(lines[i]);
//         if (val > 0 && val < 100000) totalTax += val;
//       }
//     }
//     return totalTax;
//   }

//   // ===================== ITEMS (THE FIX) =====================
//   static List<ReceiptItem> _extractItems(List<String> lines, double total, double tax) {
//     List<ReceiptItem> items = [];
    
//     // 1. Detect Header to start scanning
//     int startIndex = 0;
//     for(int i=0; i<lines.length; i++) {
//        String upper = lines[i].toUpperCase();
//        // If we see "Description", "Item", "Qty", or "Price", start strictly AFTER this line
//        if((upper.contains('ITEM') || upper.contains('DESC')) && upper.contains('AMOUNT')) {
//          startIndex = i + 1;
//          break;
//        }
//        // Fallback: If no header found, skip first 1/3rd of text (Usually addresses)
//        if (startIndex == 0 && i > lines.length / 3) startIndex = i; 
//     }

//     final stopWords = ['TOTAL', 'SUB', 'AMOUNT', 'GST', 'TAX', 'THANK', 'VISIT', 'BALANCE', 'CARD', 'CASH'];

//     for (int i = startIndex; i < lines.length; i++) {
//       String line = lines[i];
//       String upper = line.toUpperCase();

//       // Stop at footer
//       if (stopWords.any((w) => upper.contains(w))) break;
      
//       // CRITICAL FIX: Skip Address Lines (Mumbai, Road, TX, Plano)
//       if (_isAddressLine(upper)) continue;

//       // CRITICAL FIX: Skip Lines that look like items but are actually Zip Codes
//       // e.g. "400002" -> Valid number, but it's an integer > 10000 and has no decimal text
//       if (RegExp(r'^\d{5,6}$').hasMatch(line.replaceAll(' ', ''))) continue;

//       double price = _extractPrice(line);

//       // Validate Price
//       if (price <= 0) continue;
//       if (price == total) continue;
//       if (price == tax) continue;
      
//       // CRITICAL FIX: Ignore prices that are huge integers (Zip codes detected as price)
//       // e.g. 400002.0 -> If it's > 10000 AND looks like a raw integer (no decimal in text), skip.
//       if (price > 10000 && !line.contains('.')) continue;

//       // Clean Name
//       String name = _cleanName(line);
      
//       if (name.length > 2) {
//         items.add(ReceiptItem(name, price));
//       }
//     }
//     return items;
//   }

//   // ===================== UTILITIES =====================
  
//   // The "Address Killer" Function
//   static bool _isAddressLine(String upper) {
//     final addressWords = [
//       'ROAD', 'STREET', 'FLOOR', 'OPP', 'NEAR', 'BEHIND', 
//       'DIST', 'STATE', 'INDIA', 'USA', 'PIN', 'ZIP', 
//       'MUMBAI', 'MAHARASHTRA', 'TX', 'PLANO', 'DRIVE', 'AVE', 'BOX'
//     ];
//     return addressWords.any((w) => upper.contains(w));
//   }

//   static double _extractPrice(String line) {
//     try {
//       // Remove currency and noise
//       String cleaned = line.replaceAll(RegExp(r'[^\d\.,\s]'), '');
//       List<String> parts = cleaned.trim().split(RegExp(r'\s+'));
      
//       for (String part in parts.reversed) {
//         // Fix "500." -> "500"
//         if (part.endsWith('.') || part.endsWith(',')) part = part.substring(0, part.length - 1);
        
//         // Remove internal commas "59,000" -> "59000"
//         String numStr = part.replaceAll(',', '');
//         double? val = double.tryParse(numStr);
//         if (val != null) return val;
//       }
//     } catch (_) {}
//     return 0.0;
//   }

//   static double _findLargestPrice(String text) {
//     // Looks for 1,000.00 pattern
//     final regex = RegExp(r'[\d,]+\.\d{2}'); 
//     final matches = regex.allMatches(text);
//     double maxVal = 0.0;
//     for (var m in matches) {
//       String s = m.group(0)!.replaceAll(',', '');
//       double? v = double.tryParse(s);
//       // Filter out Zip codes (usually integers) by checking format or range
//       if (v != null && v > maxVal && v < 1000000) maxVal = v;
//     }
//     return maxVal;
//   }

//   static String _cleanName(String line) {
//     // Remove price from end
//     String name = line.replaceAll(RegExp(r'[\d,]+\.?\d*\s*[a-zA-Z]?\s*$'), '');
//     // Remove quantity from start
//     name = name.replaceAll(RegExp(r'^\d+\s*[xX@]\s*'), '');
//     // Remove UPC/Barcodes (8+ digits)
//     name = name.replaceAll(RegExp(r'\b\d{8,}\b'), '');
//     // Remove currency
//     name = name.replaceAll(RegExp(r'(Rs\.?|INR|₹|\$)', caseSensitive: false), '');
//     return name.trim();
//   }

//   static double _calculateConfidence(String merchant, double total, List items) {
//     double score = 0.0;
//     if (merchant != "Unknown Merchant") score += 0.3;
//     if (total > 0) score += 0.4;
//     if (items.isNotEmpty) score += 0.3;
//     return score;
//   }
// }

// class ParseResult {
//   final ReceiptData data;
//   final double confidence;
//   ParseResult({required this.data, required this.confidence});
// }