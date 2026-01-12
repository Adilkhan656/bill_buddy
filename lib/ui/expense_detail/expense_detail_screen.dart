import 'dart:io';
import 'package:bill_buddy/data/service/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/local/database.dart';
import '../../util/category_style_helper.dart';
import '../settings/view_model/setting_view_model.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailScreen({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // 1. MODERN APP BAR WITH IMAGE BACKGROUND
          // SliverAppBar(
          //   expandedHeight: expense.imagePath != null ? 300 : 120,
          //   pinned: true,
          //   backgroundColor: cardColor,
          //   elevation: 0,
          //   leading: IconButton(
          //     icon: Container(
          //       padding: const EdgeInsets.all(8),
          //       decoration: BoxDecoration(color: cardColor, shape: BoxShape.circle),
          //       child: Icon(Icons.arrow_back, color: textColor, size: 20),
          //     ),
          //     onPressed: () => Navigator.pop(context),
          //   ),
          //   flexibleSpace: FlexibleSpaceBar(
          //     background: expense.imagePath != null
          //         ? Image.file(File(expense.imagePath!), fit: BoxFit.cover)
          //         : Container(
          //             color: cardColor,
          //             alignment: Alignment.bottomLeft,
          //             padding: const EdgeInsets.only(left: 20, bottom: 20),
          //             child: Text("Details", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor)),
          //           ),
          //   ),
          // ),
// 1. MODERN APP BAR WITH IMAGE BACKGROUND
          SliverAppBar(
            expandedHeight: expense.imagePath != null ? 300 : 120,
            pinned: true,
            backgroundColor: cardColor,
            elevation: 0,
            
            // Back Button
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: cardColor, shape: BoxShape.circle),
                child: Icon(Icons.arrow_back, color: textColor, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),

            // ✅ NEW: Export Button
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: cardColor, shape: BoxShape.circle),
                  child: Icon(Icons.print_rounded, color: textColor, size: 20),
                ),
                tooltip: "Export Receipt",
                onPressed: () async {
                  final currency = Provider.of<SettingsViewModel>(context, listen: false).currencySymbol;
                   // Make sure to import your PdfService
                   await PdfService().generateReceipt(expense: expense, currencySymbol: currency);
                },
              ),
              const SizedBox(width: 10), // Right padding
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: expense.imagePath != null
                  ? Image.file(File(expense.imagePath!), fit: BoxFit.cover)
                  : Container(
                      color: cardColor,
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 20, bottom: 20),
                      child: Text("Details", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor)),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // 2. MAIN INFO ROW (Merchant & Price)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[800] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CategoryStyleHelper.getTagIcon(expense.category, size: 16),
                                  const SizedBox(width: 8),
                                  Text(expense.category, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              expense.merchant,
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: textColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM d, y • h:mm a').format(expense.date),
                              style: TextStyle(color: Colors.grey[500], fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            currency,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                          ),
                          Text(
                            expense.amount.toStringAsFixed(2),
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: textColor),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Divider(thickness: 1),
                  const SizedBox(height: 20),

                  // 3. ITEMS LIST HEADER
                  Text("Receipt Breakdown", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 16),

                  // 4. ITEMS LIST (Fetched from DB)
                  FutureBuilder<List<ExpenseItem>>(
                    future: database.getExpenseItems(expense.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _buildEmptyState("No items recorded for this bill.");
                      }
                      
                      return Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.withOpacity(0.1)),
                        ),
                        child: Column(
                          children: [
                            ...snapshot.data!.map((item) => ListTile(
                              visualDensity: VisualDensity.compact,
                              title: Text(item.name, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
                              trailing: Text(
                                "$currency${item.amount.toStringAsFixed(2)}",
                                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                              ),
                            )),
                            // Tax Row
                            if (expense.tax > 0) ...[
                              const Divider(height: 1, indent: 16, endIndent: 16),
                              ListTile(
                                visualDensity: VisualDensity.compact,
                                title: const Text("Tax", style: TextStyle(color: Colors.grey)),
                                trailing: Text(
                                  "$currency${expense.tax.toStringAsFixed(2)}",
                                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // 5. DELETE BUTTON (Clean Text Button)
  // 5. DELETE BUTTON (With Confirmation)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Delete Transaction?"),
                            content: const Text("Are you sure you want to delete this expense? This action cannot be undone."),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            actions: [
                              // Cancel Button
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                              ),
                              // Confirm Delete Button
                              TextButton(
                                onPressed: () async {
                                  // 1. Close the Dialog first
                                  Navigator.pop(ctx); 
                                  
                                  // 2. Perform the Delete
                                  await database.deleteExpense(expense.id); 
                                  
                                  // 3. Close the Detail Screen
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text("Delete", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        "Delete Transaction", 
                        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String msg) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(msg, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
    );
  }
}