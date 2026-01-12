import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../data/local/database.dart';
import '../../../util/category_style_helper.dart';
import '../../expense_detail/expense_detail_screen.dart';
import '../../settings/view_model/setting_view_model.dart';

class TransactionList extends StatelessWidget {
  final List<Expense> expenses;
  final String searchQuery;

  const TransactionList({super.key, required this.expenses, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: Text(
              searchQuery.isNotEmpty ? "No results found" : "No transactions found",
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final e = expenses[index];
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ExpenseDetailScreen(expense: e)));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                // Image or Icon
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                    image: e.imagePath != null
                        ? DecorationImage(image: FileImage(File(e.imagePath!)), fit: BoxFit.cover)
                        : null,
                  ),
                  child: e.imagePath == null ? Icon(Icons.receipt_outlined, color: primaryColor) : null,
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.merchant, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(DateFormat('MMM d, yyyy').format(e.date), style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                    ],
                  ),
                ),
                // Amount & Tag
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          CategoryStyleHelper.getTagIcon(e.category, size: 12),
                          const SizedBox(width: 4),
                          Text(e.category, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey.shade700)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("$currency${e.amount.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        );
      }, childCount: expenses.length),
    );
  }
}