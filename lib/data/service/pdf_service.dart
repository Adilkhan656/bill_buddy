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
  // 🧾 1. MODERN RECEIPT
  // ---------------------------------------------------------------------------
Future<void> generateReceipt({
    required Expense expense,
    required String currencySymbol,
    double? taxAmount,       // ✅ Pass Real Tax
    double? otherCharges,    // ✅ Pass Real Other Charges
    String? description,     // ✅ Pass Real Item Name
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    // 🧮 USE REAL VALUES OR DEFAULTS
    final double tax = taxAmount ?? 0.00;
    final double other = otherCharges ?? 0.00;
    final String itemTitle = description ?? "1 x ${expense.category} Item";

    // Logic: If Total is 4038 and Other is 19, then Item Price was 4019.
    // We treat Tax as 'Included' or 'Extra' depending on how you stored it. 
    // Based on your screenshot, Total = Item + Other. Tax is informational.
    final double itemPrice = expense.amount - other; 

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              border: pw.Border.all(color: PdfColors.grey300),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // HEADER
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: const pw.BoxDecoration(color: _accentColor, shape: pw.BoxShape.circle),
                  child: pw.Text("BB", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(height: 5),
                pw.Text("Bill Buddy", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                pw.Text("Official e-Receipt", style: const pw.TextStyle(fontSize: 8, color: _grey)),
                
                pw.SizedBox(height: 10),
                pw.Divider(color: _grey, thickness: 0.5, borderStyle: pw.BorderStyle.dashed),
                pw.SizedBox(height: 10),

                // MERCHANT
                pw.Text(expense.merchant.toUpperCase(), textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.Text(DateFormat('dd MMM yyyy • hh:mm a').format(expense.date), style: const pw.TextStyle(fontSize: 8, color: _grey)),
                
                pw.SizedBox(height: 15),

                // ITEM TABLE HEADER
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Description", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    pw.Text("Amount", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Divider(thickness: 0.5),

                // ITEM ROW (With Text Wrapping)
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Text(itemTitle, style: const pw.TextStyle(fontSize: 9)),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Text("$currencySymbol${itemPrice.toStringAsFixed(2)}", style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
                pw.SizedBox(height: 15),
                pw.Divider(thickness: 0.5),

                // BILL BREAKDOWN
                _buildReceiptRow("Subtotal", "$currencySymbol${itemPrice.toStringAsFixed(2)}"),
                
                // Only show Tax row if tax > 0
                if (tax > 0)
                _buildReceiptRow("Tax (Included)", "$currencySymbol${tax.toStringAsFixed(2)}"),
                
                // Only show Other Charges row if > 0
                if (other > 0)
                _buildReceiptRow("Other Charges", "$currencySymbol${other.toStringAsFixed(2)}"),
                
                pw.Divider(thickness: 0.5, borderStyle: pw.BorderStyle.dashed),
                
                // GRAND TOTAL
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("GRAND TOTAL", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                    pw.Text("$currencySymbol${expense.amount.toStringAsFixed(2)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Text("(Inclusive of all taxes)", style: pw.TextStyle(fontSize: 7, color: _grey, fontStyle: pw.FontStyle.italic)),

                pw.SizedBox(height: 20),
                pw.BarcodeWidget(
                  data: "BILL-BUDDY-${expense.id}",
                  barcode: pw.Barcode.qrCode(),
                  width: 40,
                  height: 40,
                ),
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
  // 📊 2. PREMIUM LIFETIME REPORT
  // ---------------------------------------------------------------------------
  Future<void> generateLifetimeReport(List<Expense> expenses, String currencySymbol) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    final totalSpent = expenses.fold(0.0, (sum, item) => sum + item.amount);
    
    final Map<String, double> categoryData = {};
    for (var e in expenses) {
      categoryData[e.category] = (categoryData[e.category] ?? 0) + e.amount;
    }
    
    final sortedCategories = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
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

            // CHART
            pw.Text("Spending Breakdown", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),

            pw.Row(
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    height: 150,
                    child: pw.Chart(
                      title: pw.Text("Expenses"),
                      grid: pw.PieGrid(),
                      datasets: List.generate(sortedCategories.length, (index) {
                        final entry = sortedCategories[index];
                        final color = chartColors[index % chartColors.length];
                        return pw.PieDataSet(
                          legend: entry.key,
                          value: entry.value,
                          color: color,
                        );
                      }),
                    ),
                  ),
                ),
                pw.SizedBox(width: 20),
                
                // LEGEND
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

  // HELPERS
  pw.Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
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