import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // ✅ Import Provider
import '../../data/local/database.dart';
import '../../util/category_style_helper.dart'; // ✅ Import Helper
import '../settings/view_model/setting_view_model.dart'; // ✅ Import Settings ViewModel

class ExpenseDetailScreen extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailScreen({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    // ✅ 1. Get Dynamic Data
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Modern Colors
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Transaction Details", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🧾 RECEIPT CARD
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 1. Category Icon (Animated Look)
                  Container(
                    width: 80, height: 80,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : const Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    // ✅ USE YOUR ASSET ICON HERE
                    child: CategoryStyleHelper.getTagIcon(expense.category, size: 40),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 2. Merchant Name
                  Text(
                    expense.merchant,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEEE, MMM d, y • h:mm a').format(expense.date),
                    style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 24),

                  // 3. The Big Amount (Synced Currency)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currency, // ✅ Shows ₹, $, etc.
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          height: 1.5
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        expense.amount.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),

                  // 4. Dashed Divider
                  _buildDashedLine(context),
                  const SizedBox(height: 30),

                  // 5. Grid Details
                  _buildDetailRow("Category", expense.category, textColor),
                  const SizedBox(height: 20),
                  // ✅ Shows Tax with Currency
                  _buildDetailRow("Tax", "$currency${expense.tax.toStringAsFixed(2)}", textColor),
                  const SizedBox(height: 20),
                  _buildDetailRow("Payment Status", "Completed", Colors.green, isBold: true),

                  // 6. Receipt Image
                  if (expense.imagePath != null) ...[
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black54 : Colors.grey[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.receipt_long_rounded, size: 16, color: Colors.grey[500]),
                              const SizedBox(width: 8),
                              Text("Receipt Photo", style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(expense.imagePath!),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 7. Delete Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: TextButton.icon(
                onPressed: () {
                   // Add your delete logic here (e.g., database.deleteExpense...)
                   Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text("Delete Transaction", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 14, fontWeight: FontWeight.w500)),
        Text(
          value, 
          style: TextStyle(
            color: valueColor, 
            fontSize: 16, 
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600
          )
        ),
      ],
    );
  }

  Widget _buildDashedLine(BuildContext context) {
    return Row(
      children: List.generate(40, (index) => Expanded(
        child: Container(
          color: index % 2 == 0 ? Colors.transparent : Colors.grey.withOpacity(0.3),
          height: 1,
        ),
      )),
    );
  }
}