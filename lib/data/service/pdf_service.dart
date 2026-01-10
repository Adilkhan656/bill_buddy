// import 'package:bill_buddy/data/local/database.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class PdfService {
  
//   // ---------------------------------------------------------------------------
//   // 🧾 1. MODERN RECEIPT (Single Expense)
//   // ---------------------------------------------------------------------------
//   Future<void> generateReceipt(Expense expense) async {
//     final pdf = pw.Document();
//     final font = await PdfGoogleFonts.poppinsRegular();
//     final boldFont = await PdfGoogleFonts.poppinsBold();

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.roll80,
//         theme: pw.ThemeData.withFont(base: font, bold: boldFont),
//         build: (pw.Context context) {
//           return pw.Container(
//             padding: const pw.EdgeInsets.all(10),
//             decoration: pw.BoxDecoration(
//               border: pw.Border.all(color: PdfColors.grey300),
//               borderRadius: pw.BorderRadius.circular(8),
//             ),
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.center,
//               children: [
//                 // LOGO / BRAND
//                 pw.Container(
//                   padding: const pw.EdgeInsets.all(8),
//                   decoration: const pw.BoxDecoration(color: PdfColors.teal, shape: pw.BoxShape.circle),
//                   child: pw.Text("BB", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
//                 ),
//                 pw.SizedBox(height: 5),
//                 pw.Text("Bill Buddy", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
//                 pw.Text("Official Receipt", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
//                 pw.Divider(thickness: 0.5),
                
//                 // AMOUNT HERO
//                 pw.SizedBox(height: 10),
//                 pw.Text("TOTAL PAID", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
//                 pw.Text("₹${expense.amount.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.teal800)),
//                 pw.SizedBox(height: 10),

//                 // DETAILS TABLE
//                 pw.Container(
//                   decoration: pw.BoxDecoration(
//                     color: PdfColors.grey100,
//                     borderRadius: pw.BorderRadius.circular(4),
//                   ),
//                   padding: const pw.EdgeInsets.all(8),
//                   child: pw.Column(
//                     children: [
//                       _buildReceiptRow("Merchant", expense.merchant),
//                       _buildReceiptRow("Date", DateFormat('dd MMM yyyy').format(expense.date)),
//                       _buildReceiptRow("Category", expense.category),
//                       _buildReceiptRow("Time", DateFormat('hh:mm a').format(expense.date)),
//                     ],
//                   ),
//                 ),
                
//                 pw.SizedBox(height: 15),
//                 pw.BarcodeWidget(
//                   data: expense.id.toString(),
//                   barcode: pw.Barcode.qrCode(),
//                   width: 40,
//                   height: 40,
//                 ),
//                 pw.SizedBox(height: 5),
//                 pw.Text("Scan to verify", style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey500)),
//               ],
//             ),
//           );
//         },
//       ),
//     );

//     await Printing.layoutPdf(
//       onLayout: (format) => pdf.save(),
//       name: 'Receipt_${expense.merchant}.pdf',
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // 📊 2. PREMIUM LIFETIME REPORT (With Charts)
//   // ---------------------------------------------------------------------------
//   Future<void> generateLifetimeReport(List<Expense> expenses, String s) async {
//     final pdf = pw.Document();
    
//     // FONTS (Important for modern look)
//     final font = await PdfGoogleFonts.openSansRegular();
//     final boldFont = await PdfGoogleFonts.openSansBold();

//     // 1. PREPARE DATA
//     final totalSpent = expenses.fold(0.0, (sum, item) => sum + item.amount);
    
//     // Group by Category for Chart
//     final Map<String, double> categoryData = {};
//     for (var e in expenses) {
//       categoryData[e.category] = (categoryData[e.category] ?? 0) + e.amount;
//     }
    
//     // Sort Categories by spend (Highest first)
//     final sortedCategories = categoryData.entries.toList()
//       ..sort((a, b) => b.value.compareTo(a.value));
    
//     // Colors for the chart
//     const chartColors = [PdfColors.teal, PdfColors.orange, PdfColors.blue, PdfColors.red, PdfColors.purple];

//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         theme: pw.ThemeData.withFont(base: font, bold: boldFont),
//         build: (pw.Context context) {
//           return [
//             // --- HEADER ---
//             pw.Container(
//               padding: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 0),
//               child: pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Text("FINANCIAL REPORT", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
//                       pw.Text("Generated on ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}", style: const pw.TextStyle(color: PdfColors.grey600)),
//                     ],
//                   ),
//                   pw.Container(
//                     padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: pw.BoxDecoration(color: PdfColors.teal50, borderRadius: pw.BorderRadius.circular(4)),
//                     child: pw.Column(
//                       children: [
//                         pw.Text("Total Spend", style: const pw.TextStyle(fontSize: 8, color: PdfColors.teal800)),
//                         pw.Text("₹${totalSpent.toStringAsFixed(0)}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.teal)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             pw.Divider(thickness: 0.5, color: PdfColors.grey300),
//             pw.SizedBox(height: 20),

//             // --- CHART SECTION ---
//             pw.Text("Spending Breakdown", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 10),
            
//             pw.Container(
//               height: 150,
//               child: pw.Flex(
//                 direction: pw.Axis.horizontal,
//                 children: [
//                   // 1. The Visual Chart
//                   pw.Expanded(
//                     flex: 2,
//                     child: pw.Chart(
//                       grid: pw.CartesianGrid(
//                         xAxis: pw.FixedAxis(
//                           List.generate(sortedCategories.length, (i) => i),
//                         ),
//                         yAxis: pw.FixedAxis(
//                           [0, (sortedCategories.first.value * 1.2).toInt()], // Auto scale Y
//                           divisions: true,
//                         ),
//                       ),
//                       datasets: [
//                         pw.BarDataSet(
//                           color: PdfColors.teal,
//                           width: 15,
//                           data: List.generate(sortedCategories.length, (i) {
//                              return pw.PointChartValue(i.toDouble(), sortedCategories[i].value);
//                           }),
//                         ),
//                       ],
//                     ),
//                   ),
//                   pw.SizedBox(width: 20),
//                   // 2. The Legend Side
//                   pw.Expanded(
//                     flex: 1,
//                     child: pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       mainAxisAlignment: pw.MainAxisAlignment.center,
//                       children: sortedCategories.take(5).map((entry) {
//                          return pw.Padding(
//                            padding: const pw.EdgeInsets.only(bottom: 4),
//                            child: pw.Row(
//                              children: [
//                                pw.Container(width: 8, height: 8, color: PdfColors.teal),
//                                pw.SizedBox(width: 6),
//                                pw.Text(entry.key, style: const pw.TextStyle(fontSize: 10)),
//                                pw.Spacer(),
//                                pw.Text("₹${entry.value.toStringAsFixed(0)}", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
//                              ],
//                            ),
//                          );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             pw.SizedBox(height: 30),

//             // --- TRANSACTIONS TABLE ---
//             pw.Text("Transaction History", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 10),

//             pw.Table.fromTextArray(
//               headers: ["Date", "Merchant", "Category", "Amount"],
//               data: expenses.map((e) => [
//                 DateFormat('MMM dd').format(e.date),
//                 e.merchant, // pw.Table automatically wraps text if it's too long!
//                 e.category,
//                 "₹${e.amount.toStringAsFixed(0)}"
//               ]).toList(),
//               border: null,
//               headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
//               headerDecoration: const pw.BoxDecoration(color: PdfColors.teal),
//               rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200))),
//               cellPadding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 5),
//               cellAlignments: {
//                 0: pw.Alignment.centerLeft,
//                 1: pw.Alignment.centerLeft,
//                 2: pw.Alignment.centerLeft,
//                 3: pw.Alignment.centerRight,
//               },
//             ),
//           ];
//         },
//       ),
//     );

//     await Printing.layoutPdf(
//       onLayout: (format) => pdf.save(),
//       name: 'BillBuddy_Summary.pdf',
//     );
//   }

//   // --- HELPER FOR RECEIPT ---
//   pw.Widget _buildReceiptRow(String label, String value) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.only(bottom: 4),
//       child: pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//         children: [
//           pw.Text(label, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
//           pw.Text(value, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }

import 'package:bill_buddy/data/local/database.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class PdfService {

  // COLORS
  static const _accentColor = PdfColors.teal;
  static const _black = PdfColors.black;
  static const _grey = PdfColors.grey600;

  // ---------------------------------------------------------------------------
  // 🧾 1. MODERN RECEIPT (Fixed Overflow & Currency)
  // ---------------------------------------------------------------------------
  Future<void> generateReceipt(Expense expense, String currencySymbol) async {
    final pdf = pw.Document();
    
    // ✅ Use Roboto for better Currency Support (₹, $, €)
    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // BRAND
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: const pw.BoxDecoration(color: _accentColor, shape: pw.BoxShape.circle),
                  child: pw.Text("BB", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(height: 5),
                pw.Text("Bill Buddy", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                pw.Text("Official Receipt", style: const pw.TextStyle(fontSize: 8, color: _grey)),
                pw.Divider(thickness: 0.5),
                
                // AMOUNT
                pw.SizedBox(height: 10),
                pw.Text("TOTAL PAID", style: const pw.TextStyle(fontSize: 8, color: _grey)),
                pw.Text("$currencySymbol${expense.amount.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.teal800)),
                pw.SizedBox(height: 10),

                // DETAILS BOX
                pw.Container(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Column(
                    children: [
                      // ✅ FIXED: Overflowing Merchant Name
                      _buildReceiptRow("Merchant", expense.merchant, isBold: true),
                      _buildReceiptRow("Date", DateFormat('dd MMM yyyy').format(expense.date)),
                      _buildReceiptRow("Category", expense.category),
                      _buildReceiptRow("Time", DateFormat('hh:mm a').format(expense.date)),
                      
                      pw.Divider(thickness: 0.5, color: PdfColors.grey400),
                      
                      // ✅ ADDED: Extra Details (Simulated)
                      _buildReceiptRow("Items", "1"), 
                      _buildReceiptRow("Tax (Incl.)", "$currencySymbol 0.00"), // Simulated as 0 for now
                    ],
                  ),
                ),
                
                pw.SizedBox(height: 15),
                pw.BarcodeWidget(
                  data: expense.id.toString(),
                  barcode: pw.Barcode.qrCode(),
                  width: 40,
                  height: 40,
                ),
                pw.SizedBox(height: 5),
                pw.Text("Scan to verify", style: const pw.TextStyle(fontSize: 6, color: _grey)),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
      name: 'Receipt_${expense.merchant}.pdf',
    );
  }

  // ---------------------------------------------------------------------------
  // 📊 2. PREMIUM LIFETIME REPORT (Multi-Color Pie Chart)
  // ---------------------------------------------------------------------------
  Future<void> generateLifetimeReport(List<Expense> expenses, String currencySymbol) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    final totalSpent = expenses.fold(0.0, (sum, item) => sum + item.amount);
    
    // Process Data for Chart
    final Map<String, double> categoryData = {};
    for (var e in expenses) {
      categoryData[e.category] = (categoryData[e.category] ?? 0) + e.amount;
    }
    
    // Sort high to low
    final sortedCategories = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // ✅ MULTI-COLOR PALETTE
    final chartColors = [
      PdfColors.teal, PdfColors.orange, PdfColors.purple, PdfColors.blue, PdfColors.red, PdfColors.green,
    ];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        build: (pw.Context context) {
          return [
            // HEADER
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("FINANCIAL REPORT", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
                    pw.Text("Generated on ${DateFormat('MMM dd, yyyy').format(DateTime.now())}", style: const pw.TextStyle(color: _grey)),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: pw.BoxDecoration(color: PdfColors.teal50, borderRadius: pw.BorderRadius.circular(4)),
                  child: pw.Column(
                    children: [
                      pw.Text("Total Spend", style: const pw.TextStyle(fontSize: 8, color: PdfColors.teal800)),
                      pw.Text("$currencySymbol${totalSpent.toStringAsFixed(0)}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.teal)),
                    ],
                  ),
                ),
              ],
            ),
            pw.Divider(),
            pw.SizedBox(height: 20),

            // CHART TITLE
            pw.Text("Spending Breakdown", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),

            // ✅ PIE CHART (Colorful & Clean)
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    height: 150,
                    child: pw.Chart(
                      title: pw.Text("Expenses"),
                      grid: pw.CartesianGrid(
                        xAxis: pw.FixedAxis(const <num>[]),
                        yAxis: pw.FixedAxis([0, 100], divisions: true), // Dummy axis needed for chart structure
                      ),
                      datasets: List.generate(sortedCategories.length, (index) {
                        final entry = sortedCategories[index];
                        final color = chartColors[index % chartColors.length];
                        return pw.PieDataSet(
                          legend: entry.key,
                          value: entry.value,
                          color: color,
                          legendStyle: const pw.TextStyle(fontSize: 10),
                        );
                      }),
                    ),
                  ),
                ),
                pw.SizedBox(width: 20),
                
                // LEGEND LIST (Right Side)
                pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                    children: List.generate(sortedCategories.take(6).length, (index) {
                      final entry = sortedCategories[index];
                      final color = chartColors[index % chartColors.length];
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 5),
                        child: pw.Row(
                          children: [
                            pw.Container(width: 8, height: 8, color: color),
                            pw.SizedBox(width: 6),
                            pw.Expanded(child: pw.Text(entry.key, style: const pw.TextStyle(fontSize: 10))),
                            pw.Text("$currencySymbol${entry.value.toStringAsFixed(0)}", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            
            pw.SizedBox(height: 30),

            // TABLE
            pw.Text("Transaction History", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            
            pw.Table.fromTextArray(
              headers: ["Date", "Merchant", "Category", "Amount"],
              data: expenses.map((e) => [
                DateFormat('MMM dd').format(e.date),
                e.merchant,
                e.category,
                "$currencySymbol${e.amount.toStringAsFixed(0)}"
              ]).toList(),
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: _accentColor),
              rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200))),
              cellPadding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerRight,
              },
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
      name: 'BillBuddy_Report.pdf',
    );
  }

  // ✅ HELPER: Handles Long Text Overflow
  pw.Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start, // Align text to top
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 9, color: _grey)),
          pw.SizedBox(width: 10),
          pw.Flexible(
            child: pw.Text(
              value,
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(fontSize: 9, fontWeight: isBold ? pw.FontWeight.bold : null),
            ),
          ),
        ],
      ),
    );
  }
}