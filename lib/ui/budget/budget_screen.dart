// // import 'package:bill_buddy/data/local/database.dart';
// // import 'package:bill_buddy/util/category_style_helper.dart';
// // import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';

// // class BudgetScreen extends StatefulWidget {
// //   const BudgetScreen({super.key});

// //   @override
// //   State<BudgetScreen> createState() => _BudgetScreenState();
// // }

// // class _BudgetScreenState extends State<BudgetScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
// //     final cardColor = Theme.of(context).cardColor;
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
// //     final primaryColor = Theme.of(context).primaryColor;

// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Monthly Budgets")),
// //       floatingActionButton: FloatingActionButton.extended(
// //         onPressed: () => _showAddBudgetDialog(context),
// //         backgroundColor: primaryColor,
// //         icon: const Icon(Icons.add, color: Colors.white),
// //         label: const Text("Set Budget", style: TextStyle(color: Colors.white)),
// //       ),
// //       body: StreamBuilder<List<Budget>>(
// //         stream: database.watchAllBudgets(),
// //         builder: (context, snapshot) {
// //           if (!snapshot.hasData) {
// //             return const Center(child: CircularProgressIndicator());
// //           }

// //           final budgets = snapshot.data!;

// //           if (budgets.isEmpty) {
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.savings_outlined, size: 64, color: Colors.grey.withOpacity(0.5)),
// //                   const SizedBox(height: 16),
// //                   Text("No budgets set yet", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
// //                   Text("Tap + to control your spending", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
// //                 ],
// //               ),
// //             );
// //           }

// //           return ListView.builder(
// //             padding: const EdgeInsets.all(16),
// //             itemCount: budgets.length,
// //             itemBuilder: (context, index) {
// //               final budget = budgets[index];
// //               return Container(
// //                 margin: const EdgeInsets.only(bottom: 12),
// //                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                 decoration: BoxDecoration(
// //                   color: cardColor,
// //                   borderRadius: BorderRadius.circular(16),
// //                   border: Border.all(color: Colors.grey.withOpacity(0.1)),
// //                   boxShadow: [
// //                     BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))
// //                   ],
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     // Icon
// //                     CategoryStyleHelper.getTagIcon(budget.category, size: 24),
// //                     const SizedBox(width: 16),
                    
// //                     // Text
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(budget.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// //                           Text("Limit: $currency${budget.limit.toStringAsFixed(0)}", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
// //                         ],
// //                       ),
// //                     ),

// //                     // Edit/Delete Actions
// //                     IconButton(
// //                       icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blueAccent),
// //                       onPressed: () => _showAddBudgetDialog(context, budget: budget),
// //                     ),
// //                     IconButton(
// //                       icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
// //                       onPressed: () => database.deleteBudget(budget.category),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   // ✅ DIALOG TO ADD/EDIT BUDGET
// //   void _showAddBudgetDialog(BuildContext context, {Budget? budget}) {
// //     final amountController = TextEditingController(text: budget?.limit.toStringAsFixed(0) ?? "");
// //     String selectedCategory = budget?.category ?? "";
// //     bool isEditing = budget != null;

// //     showDialog(
// //       context: context,
// //       builder: (ctx) => AlertDialog(
// //         backgroundColor: Theme.of(context).cardColor,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //         title: Text(isEditing ? "Edit Budget" : "New Budget"),
// //         content: StatefulBuilder(
// //           builder: (context, setState) {
// //             return Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 // 1. CATEGORY DROPDOWN (Only if adding new)
// //                 if (!isEditing) 
// //                   StreamBuilder<List<Tag>>(
// //                     stream: database.watchAllTags(),
// //                     builder: (context, snapshot) {
// //                       final tags = snapshot.data ?? [];
// //                       if (tags.isNotEmpty && selectedCategory.isEmpty) {
// //                         // Default to first tag
// //                         selectedCategory = tags.first.name; 
// //                       }
                      
// //                       return Container(
// //                         padding: const EdgeInsets.symmetric(horizontal: 12),
// //                         decoration: BoxDecoration(
// //                           border: Border.all(color: Colors.grey.withOpacity(0.3)),
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         child: DropdownButtonHideUnderline(
// //                           child: DropdownButton<String>(
// //                             value: selectedCategory.isEmpty ? null : selectedCategory,
// //                             isExpanded: true,
// //                             hint: const Text("Select Category"),
// //                             items: tags.map((t) => DropdownMenuItem(
// //                               value: t.name,
// //                               child: Row(
// //                                 children: [
// //                                   CategoryStyleHelper.getTagIcon(t.name, size: 18),
// //                                   const SizedBox(width: 8),
// //                                   Text(t.name),
// //                                 ],
// //                               ),
// //                             )).toList(),
// //                             onChanged: (val) {
// //                               if (val != null) setState(() => selectedCategory = val);
// //                             },
// //                           ),
// //                         ),
// //                       );
// //                     },
// //                   )
// //                 else
// //                   // If editing, just show the category name (read-only)
// //                   Row(
// //                     children: [
// //                       CategoryStyleHelper.getTagIcon(selectedCategory, size: 20),
// //                       const SizedBox(width: 10),
// //                       Text(selectedCategory, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// //                     ],
// //                   ),
                
// //                 const SizedBox(height: 16),

// //                 // 2. AMOUNT INPUT
// //                 TextField(
// //                   controller: amountController,
// //                   keyboardType: TextInputType.number,
// //                   decoration: InputDecoration(
// //                     labelText: "Monthly Limit",
// //                     prefixText: Provider.of<SettingsViewModel>(context, listen: false).currencySymbol,
// //                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// //                   ),
// //                 ),
// //               ],
// //             );
// //           }
// //         ),
// //         actions: [
// //           TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
// //           ElevatedButton(
// //             onPressed: () {
// //               final amount = double.tryParse(amountController.text);
// //               if (amount != null && selectedCategory.isNotEmpty) {
// //                 // Save to DB
// //                 database.setBudget(selectedCategory, amount);
// //                 Navigator.pop(ctx);
// //               }
// //             },
// //             child: const Text("Save"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:bill_buddy/data/local/database.dart';
// import 'package:bill_buddy/util/category_style_helper.dart';
// import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:drift/drift.dart' as drift;
// import 'package:intl/intl.dart';

// class BudgetScreen extends StatefulWidget {
//   const BudgetScreen({super.key});

//   @override
//   State<BudgetScreen> createState() => _BudgetScreenState();
// }

// class _BudgetScreenState extends State<BudgetScreen> {
//   DateTime _currentMonth = DateTime.now();

//   @override
//   Widget build(BuildContext context) {
//     final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
//     final cardColor = Theme.of(context).cardColor;
//     final primaryColor = Theme.of(context).primaryColor;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Budget & Analytics")),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => _showAddBudgetDialog(context),
//         backgroundColor: primaryColor,
//         icon: const Icon(Icons.add, color: Colors.white),
//         label: const Text("Set Budget", style: TextStyle(color: Colors.white)),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // ------------------------------------
//             // 1. VISUAL TRACKING DASHBOARD
//             // ------------------------------------
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: cardColor,
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: [
//                   BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Spending Trends", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                           Text(DateFormat('MMMM yyyy').format(_currentMonth), style: TextStyle(color: Colors.grey[600], fontSize: 13)),
//                         ],
//                       ),
//                       // Legend
//                       Row(
//                         children: [
//                           _buildLegendDot(Colors.blueAccent, "Daily"),
//                           const SizedBox(width: 10),
//                           _buildLegendDot(Colors.redAccent, "Weekly"),
//                         ],
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 30),
                  
//                   // THE CHART
//                   SizedBox(
//                     height: 180,
//                     child: StreamBuilder<List<Expense>>(
//                       stream: database.watchAllExpenses(), // We filter in logic
//                       builder: (context, snapshot) {
//                         if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//                         return _buildLineChart(snapshot.data!, isDark);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // ------------------------------------
//             // 2. BUDGET LIST
//             // ------------------------------------
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text("Your Budgets", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
//               ),
//             ),

//             StreamBuilder<List<Budget>>(
//               stream: database.watchAllBudgets(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return const SizedBox();
//                 final budgets = snapshot.data!;

//                 if (budgets.isEmpty) {
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 40),
//                     child: Column(
//                       children: [
//                         Icon(Icons.pie_chart_outline, size: 60, color: Colors.grey[300]),
//                         const SizedBox(height: 10),
//                         Text("No budgets set yet", style: TextStyle(color: Colors.grey[500])),
//                       ],
//                     ),
//                   );
//                 }

//                 // We need to match budgets with actual spending
//                 return StreamBuilder<List<Expense>>(
//                   stream: database.watchAllExpenses(),
//                   builder: (context, expSnap) {
//                     final expenses = expSnap.data ?? [];
                    
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: budgets.length,
//                       itemBuilder: (context, index) {
//                         final budget = budgets[index];
//                         // Calculate spent for this category this month
//                         final spent = expenses
//                             .where((e) => e.category == budget.category && 
//                                           e.date.month == _currentMonth.month && 
//                                           e.date.year == _currentMonth.year)
//                             .fold(0.0, (sum, e) => sum + e.amount);

//                         final progress = (spent / budget.limit).clamp(0.0, 1.0);
//                         final isOver = spent > budget.limit;

//                         return Container(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: cardColor,
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(color: Colors.grey.withOpacity(0.1)),
//                           ),
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   // Fetch Tag to get Emoji if available
//                                   FutureBuilder<List<Tag>>(
//                                     future: database.watchAllTags().first,
//                                     builder: (context, tagSnap) {
//                                       final tag = tagSnap.data?.firstWhere((t) => t.name == budget.category, orElse: () => Tag(name: budget.category, color: 0, isCustom: false, emoji: null));
//                                       return Container(
//                                         padding: const EdgeInsets.all(10),
//                                         decoration: BoxDecoration(
//                                           color: isDark ? Colors.grey[800] : Colors.grey[100],
//                                           borderRadius: BorderRadius.circular(12),
//                                         ),
//                                         child: CategoryStyleHelper.getTagIcon(budget.category, size: 24, emoji: tag?.emoji),
//                                       );
//                                     }
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(budget.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           "$currency${spent.toStringAsFixed(0)} of $currency${budget.limit.toStringAsFixed(0)}",
//                                           style: TextStyle(color: isOver ? Colors.red : Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
//                                     onPressed: () => _showAddBudgetDialog(context, budget: budget),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 12),
//                               // Progress Bar
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(4),
//                                 child: LinearProgressIndicator(
//                                   value: progress,
//                                   minHeight: 6,
//                                   backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
//                                   color: isOver ? Colors.redAccent : primaryColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   }
//                 );
//               },
//             ),
//             const SizedBox(height: 80),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLegendDot(Color color, String label) {
//     return Row(
//       children: [
//         Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
//         const SizedBox(width: 4),
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//       ],
//     );
//   }

//   // 📈 CHART LOGIC
//   Widget _buildLineChart(List<Expense> allExpenses, bool isDark) {
//     // 1. Filter for Current Month
//     final monthExpenses = allExpenses.where((e) => 
//       e.date.month == _currentMonth.month && e.date.year == _currentMonth.year
//     ).toList();

//     // 2. Prepare Daily Data (Blue Line)
//     Map<int, double> dailyTotals = {};
//     for (var e in monthExpenses) {
//       dailyTotals[e.date.day] = (dailyTotals[e.date.day] ?? 0) + e.amount;
//     }

//     // 3. Prepare Weekly Data (Red Line - Average per week logic or Accumulation)
//     // User requested: "Red one is for week". Let's plot weekly totals on the end-of-week days.
//     Map<int, double> weeklyTotals = {};
//     for (var e in monthExpenses) {
//       // Find week number (approx)
//       int weekNum = ((e.date.day - 1) / 7).floor() + 1;
//       int plotDay = weekNum * 7; // Plot on day 7, 14, 21, 28
//       if (plotDay > 30) plotDay = 30;
//       weeklyTotals[plotDay] = (weeklyTotals[plotDay] ?? 0) + e.amount;
//     }

//     List<FlSpot> dailySpots = [];
//     List<FlSpot> weeklySpots = [];
    
//     // Sort keys
//     var days = dailyTotals.keys.toList()..sort();
//     for(var day in days) {
//       dailySpots.add(FlSpot(day.toDouble(), dailyTotals[day]!));
//     }

//     var weeks = weeklyTotals.keys.toList()..sort();
//     for(var day in weeks) {
//       weeklySpots.add(FlSpot(day.toDouble(), weeklyTotals[day]!));
//     }

//     if (dailySpots.isEmpty) return const Center(child: Text("No data for this month", style: TextStyle(color: Colors.grey)));

//     return LineChart(
//       LineChartData(
//         gridData: FlGridData(show: false),
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 int day = value.toInt();
//                 if (day % 5 == 0) return Text(day.toString(), style: const TextStyle(color: Colors.grey, fontSize: 10));
//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//         ),
//         borderData: FlBorderData(show: false),
//         lineTouchData: LineTouchData(
//           touchTooltipData: LineTouchTooltipData(
//              tooltipBgColor: isDark ? Colors.grey[800]! : Colors.white,
//              getTooltipItems: (touchedSpots) {
//                return touchedSpots.map((spot) {
//                  return LineTooltipItem(
//                    "${spot.bar.color == Colors.blueAccent ? 'Day' : 'Week'}: ${spot.y.toStringAsFixed(0)}",
//                    TextStyle(color: spot.bar.color, fontWeight: FontWeight.bold),
//                  );
//                }).toList();
//              },
//           ),
//         ),
//         lineBarsData: [
//           // Daily Line (Blue)
//           LineChartBarData(
//             spots: dailySpots,
//             isCurved: true,
//             color: Colors.blueAccent,
//             barWidth: 3,
//             dotData: FlDotData(show: true),
//             belowBarData: BarAreaData(show: true, color: Colors.blueAccent.withOpacity(0.1)),
//           ),
//           // Weekly Line (Red)
//           LineChartBarData(
//             spots: weeklySpots,
//             isCurved: true,
//             color: Colors.redAccent,
//             barWidth: 3,
//             dotData: FlDotData(show: true),
//           ),
//         ],
//       ),
//     );
//   }

//   // ✅ PROFESSIONAL ADD DIALOG WITH CUSTOM TAGS & EMOJI
//   void _showAddBudgetDialog(BuildContext context, {Budget? budget}) {
//     final amountController = TextEditingController(text: budget?.limit.toStringAsFixed(0) ?? "");
//     String? selectedCategory = budget?.category;
    
//     // For Creating New Tag
//     bool isCreatingNew = false;
//     final newTagController = TextEditingController();
//     String newTagEmoji = "💰"; // Default emoji

//     showDialog(
//       context: context,
//       builder: (ctx) => StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             backgroundColor: Theme.of(context).cardColor,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//             title: Text(budget == null ? "Set Budget" : "Edit Budget"),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
                
//                 // 1. CATEGORY SELECTOR
//                 if (budget == null) ...[
//                    if (!isCreatingNew) 
//                      Container(
//                        padding: const EdgeInsets.symmetric(horizontal: 12),
//                        decoration: BoxDecoration(
//                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
//                          borderRadius: BorderRadius.circular(12),
//                        ),
//                        child: StreamBuilder<List<Tag>>(
//                          stream: database.watchAllTags(),
//                          builder: (context, snapshot) {
//                            final tags = snapshot.data ?? [];
//                            return DropdownButtonHideUnderline(
//                              child: DropdownButton<String>(
//                                value: selectedCategory,
//                                hint: const Text("Select Category"),
//                                isExpanded: true,
//                                icon: const Icon(Icons.keyboard_arrow_down_rounded),
//                                items: [
//                                  ...tags.map((t) => DropdownMenuItem(
//                                    value: t.name,
//                                    child: Row(
//                                      children: [
//                                        CategoryStyleHelper.getTagIcon(t.name, size: 18, emoji: t.emoji),
//                                        const SizedBox(width: 8),
//                                        Text(t.name),
//                                      ],
//                                    ),
//                                  )),
//                                  // Option to create new
//                                  const DropdownMenuItem(
//                                    value: "CREATE_NEW",
//                                    child: Row(
//                                      children: [
//                                        Icon(Icons.add_circle_outline, color: Colors.green, size: 18),
//                                        SizedBox(width: 8),
//                                        Text("Create Custom Category", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
//                                      ],
//                                    ),
//                                  )
//                                ],
//                                onChanged: (val) {
//                                  if (val == "CREATE_NEW") {
//                                    setState(() => isCreatingNew = true);
//                                  } else {
//                                    setState(() => selectedCategory = val);
//                                  }
//                                },
//                              ),
//                            );
//                          },
//                        ),
//                      )
//                    else
//                      // UI FOR CREATING NEW TAG
//                      Container(
//                        padding: const EdgeInsets.all(12),
//                        decoration: BoxDecoration(
//                          color: Colors.grey.withOpacity(0.05),
//                          borderRadius: BorderRadius.circular(12),
//                          border: Border.all(color: Colors.green.withOpacity(0.3))
//                        ),
//                        child: Column(
//                          children: [
//                            Row(
//                              children: [
//                                const Text("New Category", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
//                                const Spacer(),
//                                IconButton(
//                                  padding: EdgeInsets.zero,
//                                  constraints: const BoxConstraints(),
//                                  icon: const Icon(Icons.close, size: 18),
//                                  onPressed: () => setState(() => isCreatingNew = false),
//                                )
//                              ],
//                            ),
//                            const SizedBox(height: 10),
//                            Row(
//                              children: [
//                                // Emoji Picker (Simple Text Field for now)
//                                SizedBox(
//                                  width: 50,
//                                  child: TextField(
//                                    maxLength: 1,
//                                    textAlign: TextAlign.center,
//                                    decoration: InputDecoration(
//                                      counterText: "",
//                                      hintText: "💰",
//                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                                      contentPadding: const EdgeInsets.all(8)
//                                    ),
//                                    onChanged: (val) => newTagEmoji = val,
//                                  ),
//                                ),
//                                const SizedBox(width: 10),
//                                // Name Input
//                                Expanded(
//                                  child: TextField(
//                                    controller: newTagController,
//                                    decoration: const InputDecoration(
//                                      hintText: "Name (e.g. Sushi)",
//                                      border: UnderlineInputBorder(),
//                                      isDense: true
//                                    ),
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ],
//                        ),
//                      )
//                 ] else 
//                    // READ ONLY IF EDITING
//                    Row(
//                      children: [
//                        FutureBuilder<List<Tag>>(
//                          future: database.watchAllTags().first,
//                          builder: (context, snap) {
//                            final t = snap.data?.firstWhere((tag) => tag.name == budget.category, orElse: () => Tag(name: "", color: 0, isCustom: false, emoji: null));
//                            return CategoryStyleHelper.getTagIcon(budget.category, size: 24, emoji: t?.emoji);
//                          }
//                        ),
//                        const SizedBox(width: 12),
//                        Text(budget.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                      ],
//                    ),
                
//                 const SizedBox(height: 20),
                
//                 // 2. AMOUNT INPUT
//                 TextField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "Monthly Limit",
//                     prefixText: Provider.of<SettingsViewModel>(context, listen: false).currencySymbol,
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
//               ElevatedButton(
//                 onPressed: () async {
//                   // Handle Creation Logic
//                   if (isCreatingNew && newTagController.text.isNotEmpty) {
//                     // 1. Create Tag First
//                     await database.insertTag(TagsCompanion(
//                       name: drift.Value(newTagController.text.trim()),
//                       emoji: drift.Value(newTagEmoji),
//                       isCustom: const drift.Value(true)
//                     ));
//                     selectedCategory = newTagController.text.trim();
//                   }

//                   final amount = double.tryParse(amountController.text);
//                   if (amount != null && selectedCategory != null) {
//                     database.setBudget(selectedCategory!, amount);
//                     Navigator.pop(ctx);
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).primaryColor,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
//                 ),
//                 child: const Text("Save Budget"),
//               ),
//             ],
//           );
//         }
//       ),
//     );
//   }
// }
import 'package:bill_buddy/data/local/database.dart';
import 'package:bill_buddy/util/category_style_helper.dart';
import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // ✅ SYNCFUSION IMPORT

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  DateTime _currentMonth = DateTime.now();
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
      format: 'point.x : point.y', // Custom format handled below
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
        // Custom Tooltip UI
        final ChartData chartData = data;
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "${chartData.label}: ₹${chartData.amount.toStringAsFixed(0)}",
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
    final cardColor = Theme.of(context).cardColor;
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Budget & Analytics")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBudgetDialog(context),
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Set Budget", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ------------------------------------
            // 1. VISUAL TRACKING DASHBOARD (SYNCFUSION)
            // ------------------------------------
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              height: 300, // Fixed height for chart
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Spending Trends", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(DateFormat('MMMM yyyy').format(_currentMonth), style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        ],
                      ),
                      // Legend
                      Row(
                        children: [
                          _buildLegendDot(Colors.blueAccent, "Daily"),
                          const SizedBox(width: 10),
                          _buildLegendDot(Colors.redAccent, "Weekly"),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // SYNCFUSION CHART
                  Expanded(
                    child: StreamBuilder<List<Expense>>(
                      stream: database.watchAllExpenses(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                        return _buildSyncfusionChart(snapshot.data!, isDark);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ------------------------------------
            // 2. BUDGET LIST
            // ------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Your Budgets", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              ),
            ),

            StreamBuilder<List<Budget>>(
              stream: database.watchAllBudgets(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                final budgets = snapshot.data!;

                if (budgets.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        Icon(Icons.pie_chart_outline, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text("No budgets set yet", style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  );
                }

                return StreamBuilder<List<Expense>>(
                  stream: database.watchAllExpenses(),
                  builder: (context, expSnap) {
                    final expenses = expSnap.data ?? [];
                    
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: budgets.length,
                      itemBuilder: (context, index) {
                        final budget = budgets[index];
                        final spent = expenses
                            .where((e) => e.category == budget.category && 
                                          e.date.month == _currentMonth.month && 
                                          e.date.year == _currentMonth.year)
                            .fold(0.0, (sum, e) => sum + e.amount);

                        final progress = (spent / budget.limit).clamp(0.0, 1.0);
                        final isOver = spent > budget.limit;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.withOpacity(0.1)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  FutureBuilder<List<Tag>>(
                                    future: database.watchAllTags().first,
                                    builder: (context, tagSnap) {
                                      final tag = tagSnap.data?.firstWhere((t) => t.name == budget.category, orElse: () => Tag(name: budget.category, color: 0, isCustom: false, emoji: null));
                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: isDark ? Colors.grey[800] : Colors.grey[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: CategoryStyleHelper.getTagIcon(budget.category, size: 24, emoji: tag?.emoji),
                                      );
                                    }
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(budget.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        const SizedBox(height: 4),
                                        Text(
                                          "$currency${spent.toStringAsFixed(0)} of $currency${budget.limit.toStringAsFixed(0)}",
                                          style: TextStyle(color: isOver ? Colors.red : Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                                    onPressed: () => _showAddBudgetDialog(context, budget: budget),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                                    onPressed: () => database.deleteBudget(budget.category),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 6,
                                  backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                                  color: isOver ? Colors.redAccent : primaryColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // ✅ SYNCFUSION CHART BUILDER
  // ----------------------------------------------------
  Widget _buildSyncfusionChart(List<Expense> allExpenses, bool isDark) {
    final monthExpenses = allExpenses.where((e) => 
      e.date.month == _currentMonth.month && e.date.year == _currentMonth.year
    ).toList();

    // 1. Prepare Daily Data (Blue)
    Map<int, double> dailyTotals = {};
    for (var e in monthExpenses) {
      dailyTotals[e.date.day] = (dailyTotals[e.date.day] ?? 0) + e.amount;
    }
    List<ChartData> dailyData = dailyTotals.entries
        .map((e) => ChartData(e.key, e.value, "Day ${e.key}"))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    // 2. Prepare Weekly Data (Red)
    Map<int, double> weeklyTotals = {};
    for (var e in monthExpenses) {
      int weekNum = ((e.date.day - 1) / 7).floor() + 1;
      int plotDay = weekNum * 7; 
      if (plotDay > 30) plotDay = 30; // Clamp to end of month approximately
      weeklyTotals[plotDay] = (weeklyTotals[plotDay] ?? 0) + e.amount;
    }
    List<ChartData> weeklyData = weeklyTotals.entries
        .map((e) => ChartData(e.key, e.value, "Week ${e.key ~/ 7}"))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    if (dailyData.isEmpty) return const Center(child: Text("No data for this month", style: TextStyle(color: Colors.grey)));

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      tooltipBehavior: _tooltipBehavior,
      primaryXAxis: NumericAxis(
        interval: 5,
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 10),
      ),
      primaryYAxis: NumericAxis(
        isVisible: false, // Clean look
        majorGridLines: const MajorGridLines(width: 0),
      ),
      series: <CartesianSeries>[
        // Weekly Line (Red) - Background
        SplineSeries<ChartData, int>(
          dataSource: weeklyData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.amount,
          color: Colors.redAccent.withOpacity(0.8),
          width: 4,
          name: 'Weekly',
          markerSettings: const MarkerSettings(isVisible: true, color: Colors.redAccent),
          enableTooltip: true,
        ),
        // Daily Line (Blue) - Foreground
        SplineAreaSeries<ChartData, int>(
          dataSource: dailyData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.amount,
          gradient: LinearGradient(
            colors: [Colors.blueAccent.withOpacity(0.3), Colors.blueAccent.withOpacity(0.05)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderColor: Colors.blueAccent,
          borderWidth: 3,
          name: 'Daily',
          markerSettings: const MarkerSettings(isVisible: true, color: Colors.blueAccent, width: 8, height: 8),
          enableTooltip: true,
        ),
      ],
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // ✅ ADD BUDGET DIALOG
  void _showAddBudgetDialog(BuildContext context, {Budget? budget}) {
    final amountController = TextEditingController(text: budget?.limit.toStringAsFixed(0) ?? "");
    String? selectedCategory = budget?.category;
    
    bool isCreatingNew = false;
    final newTagController = TextEditingController();
    String newTagEmoji = "💰";

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(budget == null ? "Set Budget" : "Edit Budget"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (budget == null) ...[
                   if (!isCreatingNew) 
                     Container(
                       padding: const EdgeInsets.symmetric(horizontal: 12),
                       decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.3)), borderRadius: BorderRadius.circular(12)),
                       child: StreamBuilder<List<Tag>>(
                         stream: database.watchAllTags(),
                         builder: (context, snapshot) {
                           final tags = snapshot.data ?? [];
                           return DropdownButtonHideUnderline(
                             child: DropdownButton<String>(
                               value: selectedCategory,
                               hint: const Text("Select Category"),
                               isExpanded: true,
                               icon: const Icon(Icons.keyboard_arrow_down_rounded),
                               items: [
                                 ...tags.map((t) => DropdownMenuItem(
                                   value: t.name,
                                   child: Row(children: [CategoryStyleHelper.getTagIcon(t.name, size: 18, emoji: t.emoji), const SizedBox(width: 8), Text(t.name)]),
                                 )),
                                 const DropdownMenuItem(value: "CREATE_NEW", child: Row(children: [Icon(Icons.add_circle_outline, color: Colors.green, size: 18), SizedBox(width: 8), Text("Create Custom", style: TextStyle(color: Colors.green))])),
                               ],
                               onChanged: (val) {
                                 if (val == "CREATE_NEW") setState(() => isCreatingNew = true);
                                 else setState(() => selectedCategory = val);
                               },
                             ),
                           );
                         },
                       ),
                     )
                   else
                     Container(
                       padding: const EdgeInsets.all(12),
                       decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green.withOpacity(0.3))),
                       child: Column(
                         children: [
                           Row(children: [const Text("New Category", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)), const Spacer(), IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => setState(() => isCreatingNew = false))]),
                           Row(children: [
                               SizedBox(width: 50, child: TextField(textAlign: TextAlign.center, decoration: const InputDecoration(hintText: "💰", border: InputBorder.none), onChanged: (val) => newTagEmoji = val)),
                               Expanded(child: TextField(controller: newTagController, decoration: const InputDecoration(hintText: "Name", border: UnderlineInputBorder()))),
                           ]),
                         ],
                       ),
                     )
                ] else 
                   Row(children: [
                       FutureBuilder<List<Tag>>(
                         future: database.watchAllTags().first,
                         builder: (context, snap) {
                           final t = snap.data?.firstWhere((tag) => tag.name == budget.category, orElse: () => Tag(name: "", color: 0, isCustom: false, emoji: null));
                           return CategoryStyleHelper.getTagIcon(budget.category, size: 24, emoji: t?.emoji);
                         }
                       ),
                       const SizedBox(width: 12),
                       Text(budget.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                   ]),
                
                const SizedBox(height: 20),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Limit",
                    prefixText: Provider.of<SettingsViewModel>(context, listen: false).currencySymbol,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () async {
                  if (isCreatingNew && newTagController.text.isNotEmpty) {
                    await database.insertTag(TagsCompanion(name: drift.Value(newTagController.text.trim()), emoji: drift.Value(newTagEmoji), isCustom: const drift.Value(true)));
                    selectedCategory = newTagController.text.trim();
                  }
                  final amount = double.tryParse(amountController.text);
                  if (amount != null && selectedCategory != null) {
                    database.setBudget(selectedCategory!, amount);
                    Navigator.pop(ctx);
                  }
                },
                child: const Text("Save"),
              ),
            ],
          );
        }
      ),
    );
  }
}

// Simple Model Class for Chart
class ChartData {
  final int x;
  final double amount;
  final String label; // "Day 5" or "Week 1"
  ChartData(this.x, this.amount, this.label);
}