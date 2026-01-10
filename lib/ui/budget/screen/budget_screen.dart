// // import 'package:bill_buddy/data/local/database.dart';
// // import 'package:bill_buddy/util/category_style_helper.dart';
// // import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:provider/provider.dart';
// // import 'package:drift/drift.dart' as drift;
// // import 'package:intl/intl.dart';
// // import 'package:syncfusion_flutter_charts/charts.dart';

// // class BudgetScreen extends StatefulWidget {
// //   const BudgetScreen({super.key});

// //   @override
// //   State<BudgetScreen> createState() => _BudgetScreenState();
// // }

// // class _BudgetScreenState extends State<BudgetScreen> {
// //   DateTime _currentMonth = DateTime.now();
// //   late TooltipBehavior _tooltipBehavior;

// //   // ✅ STATE FOR SELECTION MODE
// //   Budget? _selectedBudget;

// //   @override
// //   void initState() {
// //     _tooltipBehavior = TooltipBehavior(
// //       enable: true,
// //       header: '',
// //       canShowMarker: false,
// //       builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
// //         final ChartData chartData = data;
// //         return Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// //           decoration: BoxDecoration(
// //             color: Colors.grey[900],
// //             borderRadius: BorderRadius.circular(8),
// //             boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2))],
// //           ),
// //           child: Text(
// //             "${chartData.label}\n₹${chartData.amount.toStringAsFixed(0)}",
// //             textAlign: TextAlign.center,
// //             style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
// //           ),
// //         );
// //       },
// //     );
// //     super.initState();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final primaryColor = Theme.of(context).primaryColor;
// //     final isDark = Theme.of(context).brightness == Brightness.dark;

// //     return WillPopScope(
// //       onWillPop: () async {
// //         if (_selectedBudget != null) {
// //           setState(() => _selectedBudget = null);
// //           return false;
// //         }
// //         return true;
// //       },
// //       child: Scaffold(
// //         backgroundColor: isDark ? Colors.black : Colors.grey[50],

// //         // ✅ APP BAR SWITCHES MODE ON SELECTION
// //         appBar: _selectedBudget == null
// //           ? AppBar(
// //               title: const Text("Budget & Analytics"),
// //               centerTitle: false,
// //               elevation: 0,
// //               backgroundColor: isDark ? Colors.black : Colors.white,
// //               foregroundColor: isDark ? Colors.white : Colors.black,
// //             )
// //           : AppBar(
// //               leading: IconButton(
// //                 icon: const Icon(Icons.close),
// //                 onPressed: () => setState(() => _selectedBudget = null),
// //               ),
// //               title: Text(_selectedBudget!.category, style: const TextStyle(fontWeight: FontWeight.bold)),
// //               backgroundColor: isDark ? Colors.grey[900] : Colors.blueAccent,
// //               foregroundColor: Colors.white,
// //               actions: [
// //                 // EDIT BUTTON
// //                 IconButton(
// //                   icon: const Icon(Icons.edit),
// //                   tooltip: "Edit Limit",
// //                   onPressed: () {
// //                     final budgetToEdit = _selectedBudget!;
// //                     setState(() => _selectedBudget = null); // Exit selection mode
// //                     _showAddBudgetSheet(context, budget: budgetToEdit);
// //                   },
// //                 ),
// //                 // DELETE BUTTON
// //                 IconButton(
// //                   icon: const Icon(Icons.delete),
// //                   tooltip: "Delete Budget",
// //                   onPressed: () async {
// //                     final budgetToDelete = _selectedBudget!;
// //                     if (await _showDeleteConfirmDialog(context, budgetToDelete.category)) {
// //                       database.deleteBudget(budgetToDelete.category);
// //                       setState(() => _selectedBudget = null);
// //                     }
// //                   },
// //                 ),
// //                 const SizedBox(width: 8),
// //               ],
// //             ),

// //         floatingActionButton: _selectedBudget == null
// //           ? FloatingActionButton.extended(
// //               onPressed: () => _showAddBudgetSheet(context),
// //               backgroundColor: primaryColor,
// //               elevation: 4,
// //               icon: const Icon(Icons.add_rounded, color: Colors.white),
// //               label: const Text("Set Limit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
// //             )
// //           : null, // Hide FAB when selecting

// //         body: SingleChildScrollView(
// //           physics: const BouncingScrollPhysics(),
// //           padding: const EdgeInsets.only(bottom: 100),
// //           child: Column(
// //             children: [
// //               // 1. ANALYTICS DASHBOARD
// //               _buildDashboard(context),

// //               // 2. HEADER
// //               Padding(
// //                 padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
// //                 child: Row(
// //                   children: [
// //                     Text("Monthly Limits", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface)),
// //                     const Spacer(),
// //                     Icon(Icons.info_outline, size: 16, color: Colors.grey[500]),
// //                     const SizedBox(width: 4),
// //                     Text("Long press to edit", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
// //                   ],
// //                 ),
// //               ),

// //               // 3. BUDGET LIST ITEMS
// //               StreamBuilder<List<Budget>>(
// //                 stream: database.watchAllBudgets(),
// //                 builder: (context, snapshot) {
// //                   if (!snapshot.hasData) return const SizedBox();
// //                   final budgets = snapshot.data!;

// //                   if (budgets.isEmpty) return _buildEmptyState();

// //                   return StreamBuilder<List<Expense>>(
// //                     stream: database.watchAllExpenses(),
// //                     builder: (context, expSnap) {
// //                       final expenses = expSnap.data ?? [];

// //                       return ListView.builder(
// //                         shrinkWrap: true,
// //                         physics: const NeverScrollableScrollPhysics(),
// //                         padding: const EdgeInsets.symmetric(horizontal: 16),
// //                         itemCount: budgets.length,
// //                         itemBuilder: (context, index) {
// //                           return _buildBudgetItem(context, budgets[index], expenses);
// //                         },
// //                       );
// //                     }
// //                   );
// //                 },
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // ----------------------------------------------------
// //   // 🎨 WIDGETS: DASHBOARD (Updated with Month Switcher)
// //   // ----------------------------------------------------
// //   Widget _buildDashboard(BuildContext context) {
// //     final cardColor = Theme.of(context).cardColor;
// //     final isDark = Theme.of(context).brightness == Brightness.dark;

// //     return Container(
// //       margin: const EdgeInsets.all(16),
// //       padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
// //       height: 340,
// //       decoration: BoxDecoration(
// //         color: cardColor,
// //         borderRadius: BorderRadius.circular(24),
// //         border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
// //         boxShadow: [
// //           BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 20, offset: const Offset(0, 10))
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               const Text("Spending Analysis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

// //               // ✅ Month Switcher
// //               Container(
// //                 height: 36,
// //                 padding: const EdgeInsets.symmetric(horizontal: 4),
// //                 decoration: BoxDecoration(
// //                   color: isDark ? Colors.grey[800] : Colors.grey[100],
// //                   borderRadius: BorderRadius.circular(18),
// //                   border: Border.all(color: Colors.grey.withOpacity(0.2)),
// //                 ),
// //                 child: Row(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     IconButton(
// //                       icon: const Icon(Icons.chevron_left, size: 20),
// //                       padding: EdgeInsets.zero,
// //                       constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
// //                       color: Colors.grey[600],
// //                       onPressed: () {
// //                         setState(() {
// //                           _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
// //                         });
// //                       },
// //                     ),
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 4),
// //                       child: Text(
// //                         DateFormat('MMM yyyy').format(_currentMonth),
// //                         style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
// //                       ),
// //                     ),
// //                     IconButton(
// //                       icon: const Icon(Icons.chevron_right, size: 20),
// //                       padding: EdgeInsets.zero,
// //                       constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
// //                       color: Colors.grey[600],
// //                       onPressed: () {
// //                         setState(() {
// //                           _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
// //                         });
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),

// //           const SizedBox(height: 20),
// //           Expanded(
// //             child: StreamBuilder<List<Expense>>(
// //               stream: database.watchAllExpenses(),
// //               builder: (context, snapshot) {
// //                 if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
// //                 return _buildSyncfusionChart(snapshot.data!, isDark);
// //               },
// //             ),
// //           ),
// //           const SizedBox(height: 10),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               _buildLegendDot(Colors.blueAccent, "Daily Spend"),
// //               const SizedBox(width: 16),
// //               _buildLegendDot(Colors.redAccent, "Weekly Trend"),
// //             ],
// //           )
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSyncfusionChart(List<Expense> allExpenses, bool isDark) {
// //     final monthExpenses = allExpenses.where((e) =>
// //       e.date.month == _currentMonth.month && e.date.year == _currentMonth.year
// //     ).toList();

// //     Map<int, double> dailyTotals = {};
// //     for (var e in monthExpenses) dailyTotals[e.date.day] = (dailyTotals[e.date.day] ?? 0) + e.amount;

// //     List<ChartData> dailyData = dailyTotals.entries
// //         .map((e) => ChartData(e.key, e.value, DateFormat('MMM d').format(DateTime(_currentMonth.year, _currentMonth.month, e.key))))
// //         .toList()..sort((a, b) => a.x.compareTo(b.x));

// //     Map<int, double> weeklyTotals = {};
// //     for (var e in monthExpenses) {
// //       int weekNum = ((e.date.day - 1) / 7).floor() + 1;
// //       int plotDay = weekNum * 7;
// //       if (plotDay > 30) plotDay = 30;
// //       weeklyTotals[plotDay] = (weeklyTotals[plotDay] ?? 0) + e.amount;
// //     }
// //     List<ChartData> weeklyData = weeklyTotals.entries
// //         .map((e) => ChartData(e.key, e.value, "Week ${e.key ~/ 7}"))
// //         .toList()..sort((a, b) => a.x.compareTo(b.x));

// //     if (dailyData.isEmpty) {
// //       return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.bar_chart, color: Colors.grey[300], size: 48), Text("No data yet", style: TextStyle(color: Colors.grey[400]))]));
// //     }

// //     return SfCartesianChart(
// //       plotAreaBorderWidth: 0,
// //       tooltipBehavior: _tooltipBehavior,
// //       primaryXAxis: NumericAxis(
// //         interval: 5,
// //         majorGridLines: const MajorGridLines(width: 0),
// //         axisLine: const AxisLine(width: 0),
// //         labelStyle: TextStyle(color: Colors.grey[600], fontSize: 10),
// //         axisLabelFormatter: (AxisLabelRenderDetails args) {
// //            return ChartAxisLabel("${args.value.toInt()}", const TextStyle(fontSize: 10, color: Colors.grey));
// //         },
// //       ),
// //       primaryYAxis: NumericAxis(isVisible: false, majorGridLines: const MajorGridLines(width: 0)),
// //       series: <CartesianSeries>[
// //         SplineSeries<ChartData, int>(
// //           dataSource: weeklyData,
// //           xValueMapper: (ChartData data, _) => data.x,
// //           yValueMapper: (ChartData data, _) => data.amount,
// //           color: Colors.redAccent.withOpacity(0.5),
// //           width: 3,
// //           dashArray: <double>[5, 5],
// //           enableTooltip: true,
// //         ),
// //         SplineAreaSeries<ChartData, int>(
// //           dataSource: dailyData,
// //           xValueMapper: (ChartData data, _) => data.x,
// //           yValueMapper: (ChartData data, _) => data.amount,
// //           gradient: LinearGradient(
// //             colors: [Colors.blueAccent.withOpacity(0.4), Colors.blueAccent.withOpacity(0.0)],
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //           ),
// //           borderColor: Colors.blueAccent,
// //           borderWidth: 3,
// //           markerSettings: const MarkerSettings(isVisible: true, color: Colors.white, borderColor: Colors.blueAccent, borderWidth: 2, width: 8, height: 8),
// //           enableTooltip: true,
// //         ),
// //       ],
// //     );
// //   }

// //   // ----------------------------------------------------
// //   // 🎨 WIDGETS: BUDGET LIST ITEM (With Selection Logic)
// //   // ----------------------------------------------------
// //   Widget _buildBudgetItem(BuildContext context, Budget budget, List<Expense> allExpenses) {
// //     final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
// //     final isDark = Theme.of(context).brightness == Brightness.dark;

// //     // ✅ Check if this item is currently selected
// //     final isSelected = _selectedBudget?.id == budget.id;

// //     final spent = allExpenses
// //         .where((e) => e.category == budget.category &&
// //                       e.date.month == _currentMonth.month &&
// //                       e.date.year == _currentMonth.year)
// //         .fold(0.0, (sum, e) => sum + e.amount);

// //     final double progress = (spent / budget.limit).clamp(0.0, 1.0);

// //     Color statusColor;
// //     String statusText;
// //     if (progress >= 1.0) {
// //       statusColor = Colors.redAccent;
// //       statusText = "Exceeded";
// //     } else if (progress >= 0.8) {
// //       statusColor = Colors.orangeAccent;
// //       statusText = "Warning";
// //     } else {
// //       statusColor = const Color(0xFF0F766E);
// //       statusText = "Safe";
// //     }

// //     return Dismissible(
// //       key: Key("budget_${budget.id}"),
// //       direction: DismissDirection.endToStart,
// //       background: Container(
// //         margin: const EdgeInsets.only(bottom: 12),
// //         decoration: BoxDecoration(color: Colors.red[400], borderRadius: BorderRadius.circular(16)),
// //         alignment: Alignment.centerRight,
// //         padding: const EdgeInsets.only(right: 20),
// //         child: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), SizedBox(width: 8), Icon(Icons.delete_outline, color: Colors.white)]),
// //       ),
// //       confirmDismiss: (direction) async {
// //         return await _showDeleteConfirmDialog(context, budget.category);
// //       },
// //       onDismissed: (direction) {
// //         database.deleteBudget(budget.category);
// //       },
// //       child: GestureDetector(
// //         // ✅ Selection Logic
// //         onLongPress: () {
// //           HapticFeedback.mediumImpact(); // Adds a nice vibration
// //           setState(() => _selectedBudget = budget);
// //         },
// //         onTap: () {
// //           if (_selectedBudget != null) {
// //             // If selecting, tap deselects
// //             setState(() => _selectedBudget = null);
// //           }
// //         },
// //         child: AnimatedContainer(
// //           duration: const Duration(milliseconds: 200),
// //           margin: const EdgeInsets.only(bottom: 12),
// //           padding: const EdgeInsets.all(16),
// //           decoration: BoxDecoration(
// //             color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Theme.of(context).cardColor,
// //             borderRadius: BorderRadius.circular(16),
// //             border: Border.all(
// //               color: isSelected ? Colors.blueAccent : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
// //               width: isSelected ? 2 : 1
// //             ),
// //             boxShadow: [
// //               if (!isSelected) BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))
// //             ],
// //           ),
// //           child: Column(
// //             children: [
// //               Row(
// //                 children: [
// //                   // Icon with Selection Checkmark
// //                    FutureBuilder<List<Tag>>(
// //                     future: database.watchAllTags().first,
// //                     builder: (context, tagSnap) {
// //                       final tag = tagSnap.data?.firstWhere((t) => t.name == budget.category, orElse: () => Tag(name: budget.category, color: 0, isCustom: false, emoji: null));
// //                       return Container(
// //                         padding: const EdgeInsets.all(10),
// //                         decoration: BoxDecoration(
// //                           color: isSelected ? Colors.blueAccent : (isDark ? Colors.grey[800] : Colors.grey[100]),
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         // Show Checkmark if selected, else Tag Icon
// //                         child: isSelected
// //                             ? const Icon(Icons.check, size: 22, color: Colors.white)
// //                             : CategoryStyleHelper.getTagIcon(budget.category, size: 22, emoji: tag?.emoji),
// //                       );
// //                     }
// //                   ),
// //                   const SizedBox(width: 14),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             Text(budget.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
// //                               decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
// //                               child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
// //                             )
// //                           ],
// //                         ),
// //                         const SizedBox(height: 6),
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             Text("$currency${spent.toStringAsFixed(0)} spent", style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13)),
// //                             Text("Limit: $currency${budget.limit.toStringAsFixed(0)}", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 12),
// //               Stack(
// //                 children: [
// //                   Container(height: 8, decoration: BoxDecoration(color: isDark ? Colors.grey[800] : Colors.grey[200], borderRadius: BorderRadius.circular(4))),
// //                   FractionallySizedBox(
// //                     widthFactor: progress,
// //                     child: Container(
// //                       height: 8,
// //                       decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: statusColor.withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 2))]),
// //                     ),
// //                   )
// //                 ],
// //               )
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // 1. DELETE CONFIRMATION
// //   Future<bool> _showDeleteConfirmDialog(BuildContext context, String category) async {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
// //     return await showDialog(
// //       context: context,
// //       builder: (ctx) => AlertDialog(
// //         backgroundColor: isDark ? Colors.grey[900] : Colors.white,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //         title: const Text("Delete Budget?", style: TextStyle(fontWeight: FontWeight.bold)),
// //         content: Text("Delete budget for $category? Spending data remains.", style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700])),
// //         actions: [
// //           TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text("Cancel", style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]))),
// //           ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text("Delete", style: TextStyle(color: Colors.white))),
// //         ],
// //       )
// //     ) ?? false;
// //   }

// //   // 2. ADD/EDIT SHEET (Fix: Handles Edits correctly)
// //   void _showAddBudgetSheet(BuildContext context, {Budget? budget}) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
// //     final amountController = TextEditingController(text: budget?.limit.toStringAsFixed(0) ?? "");
// //     String? selectedCategory = budget?.category;
// //     bool isCreatingNew = false;
// //     final newTagController = TextEditingController();
// //     String newTagEmoji = "💰";

// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
// //       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
// //       builder: (ctx) => StatefulBuilder(
// //         builder: (context, setState) {
// //           return Padding(
// //             padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(2)))),
// //                 const SizedBox(height: 20),
// //                 Text(budget == null ? "New Monthly Limit" : "Update Limit", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
// //                 const SizedBox(height: 24),

// //                 // CATEGORY SELECTOR (Read Only if Editing)
// //                 Text("CATEGORY", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.2)),
// //                 const SizedBox(height: 10),

// //                 if (budget != null)
// //                   // Editing: Show Fixed Category
// //                   Container(
// //                     width: double.infinity,
// //                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                     decoration: BoxDecoration(color: isDark ? Colors.black26 : Colors.grey[200], borderRadius: BorderRadius.circular(16)),
// //                     child: Row(
// //                       children: [
// //                         CategoryStyleHelper.getTagIcon(budget.category, size: 20),
// //                         const SizedBox(width: 10),
// //                         Text(budget.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// //                         const Spacer(),
// //                         const Icon(Icons.lock_outline, size: 16, color: Colors.grey)
// //                       ],
// //                     ),
// //                   )
// //                 else
// //                   // Adding: Show Dropdown
// //                   AnimatedCrossFade(
// //                      duration: const Duration(milliseconds: 300),
// //                      crossFadeState: isCreatingNew ? CrossFadeState.showSecond : CrossFadeState.showFirst,
// //                      firstChild: Container(
// //                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// //                        decoration: BoxDecoration(color: isDark ? Colors.black26 : Colors.grey[100], borderRadius: BorderRadius.circular(16)),
// //                        child: StreamBuilder<List<Tag>>(
// //                          stream: database.watchAllTags(),
// //                          builder: (context, snapshot) {
// //                            final tags = snapshot.data ?? [];
// //                            return DropdownButtonHideUnderline(
// //                              child: DropdownButton<String>(
// //                                value: selectedCategory,
// //                                hint: const Text("Select a category"),
// //                                isExpanded: true,
// //                                icon: const Icon(Icons.keyboard_arrow_down_rounded),
// //                                items: [
// //                                  ...tags.map((t) => DropdownMenuItem(value: t.name, child: Row(children: [CategoryStyleHelper.getTagIcon(t.name, size: 20, emoji: t.emoji), const SizedBox(width: 10), Text(t.name)]))),
// //                                  const DropdownMenuItem(value: "CREATE_NEW", child: Row(children: [Icon(Icons.add_circle, color: Colors.blueAccent), SizedBox(width: 10), Text("Create New Category", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))])),
// //                                ],
// //                                onChanged: (val) {
// //                                  if (val == "CREATE_NEW") setState(() => isCreatingNew = true);
// //                                  else setState(() => selectedCategory = val);
// //                                },
// //                              ),
// //                            );
// //                          },
// //                        ),
// //                      ),
// //                      secondChild: Container(
// //                        padding: const EdgeInsets.all(12),
// //                        decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blueAccent.withOpacity(0.3))),
// //                        child: Column(
// //                          children: [
// //                            Row(children: [const Text("New Category", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)), const Spacer(), IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => setState(() => isCreatingNew = false))]),
// //                            Row(children: [
// //                                SizedBox(width: 50, child: TextField(textAlign: TextAlign.center, decoration: const InputDecoration(hintText: "💰", border: InputBorder.none), onChanged: (val) => newTagEmoji = val)),
// //                                Expanded(child: TextField(controller: newTagController, decoration: const InputDecoration(hintText: "Name (e.g. Sushi)", border: UnderlineInputBorder(), isDense: true))),
// //                            ]),
// //                          ],
// //                        ),
// //                      ),
// //                    ),

// //                 const SizedBox(height: 24),

// //                 // AMOUNT INPUT
// //                 Text("MONTHLY LIMIT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.2)),
// //                 const SizedBox(height: 10),
// //                 TextField(
// //                   controller: amountController,
// //                   keyboardType: TextInputType.number,
// //                   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
// //                   decoration: InputDecoration(
// //                     prefixText: "${Provider.of<SettingsViewModel>(context, listen: false).currencySymbol} ",
// //                     hintText: "0",
// //                     filled: true,
// //                     fillColor: isDark ? Colors.black26 : Colors.grey[100],
// //                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
// //                     contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
// //                   ),
// //                 ),

// //                 const SizedBox(height: 30),

// //                 SizedBox(
// //                   width: double.infinity,
// //                   height: 55,
// //                   child: ElevatedButton(
// //                     onPressed: () async {
// //                       if (isCreatingNew && newTagController.text.isNotEmpty) {
// //                         await database.insertTag(TagsCompanion(name: drift.Value(newTagController.text.trim()), emoji: drift.Value(newTagEmoji), isCustom: const drift.Value(true)));
// //                         selectedCategory = newTagController.text.trim();
// //                       }
// //                       final amount = double.tryParse(amountController.text);
// //                       if (amount != null && selectedCategory != null) {
// //                         // ✅ Save (or Update) Budget
// //                         database.setBudget(selectedCategory!, amount);
// //                         Navigator.pop(ctx);
// //                       }
// //                     },
// //                     style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
// //                     child: Text(budget == null ? "Set Limit" : "Update Limit", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }
// //       ),
// //     );
// //   }

// //   Widget _buildEmptyState() {
// //     return Padding(padding: const EdgeInsets.only(top: 40), child: Column(children: [Icon(Icons.savings_outlined, size: 60, color: Colors.grey[300]), const SizedBox(height: 10), Text("No budgets set yet", style: TextStyle(color: Colors.grey[500], fontSize: 16)), Text("Tap + to control your spending", style: TextStyle(color: Colors.grey[400], fontSize: 14))]));
// //   }
// //   Widget _buildLegendDot(Color color, String label) {
// //     return Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 6), Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
// //   }
// // }
// // class ChartData {
// //   final int x;
// //   final double amount;
// //   final String label;
// //   ChartData(this.x, this.amount, this.label);
// // }
// import 'package:bill_buddy/data/local/database.dart';
// import 'package:bill_buddy/util/category_style_helper.dart';
// import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:drift/drift.dart' as drift;
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class BudgetScreen extends StatefulWidget {
//   const BudgetScreen({super.key});

//   @override
//   State<BudgetScreen> createState() => _BudgetScreenState();
// }

// class _BudgetScreenState extends State<BudgetScreen> {
//   DateTime _currentMonth = DateTime.now();
//   late TooltipBehavior _tooltipBehavior;
//   Budget? _selectedBudget;

//   @override
//   void initState() {
//     _tooltipBehavior = TooltipBehavior(
//       enable: true,
//       header: '',
//       canShowMarker: false,
//       builder:
//           (
//             dynamic data,
//             dynamic point,
//             dynamic series,
//             int pointIndex,
//             int seriesIndex,
//           ) {
//             final ChartData chartData = data;
//             return Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.grey[900],
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Text(
//                 "${chartData.label}\n₹${chartData.amount.toStringAsFixed(0)}",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 11,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             );
//           },
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return WillPopScope(
//       onWillPop: () async {
//         if (_selectedBudget != null) {
//           setState(() => _selectedBudget = null);
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: isDark ? Colors.black : Colors.grey[50],

//         // --- APP BAR (Selection Mode) ---
//         appBar: _selectedBudget == null
//             ? AppBar(
//                 title: const Text("Budget & Analytics"),
//                 centerTitle: false,
//                 elevation: 0,
//                 backgroundColor: isDark ? Colors.black : Colors.white,
//                 foregroundColor: isDark ? Colors.white : Colors.black,
//               )
//             : AppBar(
//                 leading: IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => setState(() => _selectedBudget = null),
//                 ),
//                 title: Text(
//                   _selectedBudget!.category,
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 backgroundColor: isDark
//                     ? Colors.grey[900]
//                     : Colors.green[700], // ✅ Green for selection
//                 foregroundColor: Colors.white,
//                 actions: [
//                   IconButton(
//                     icon: const Icon(Icons.edit),
//                     tooltip: "Edit Limit",
//                     onPressed: () {
//                       final budgetToEdit = _selectedBudget!;
//                       setState(() => _selectedBudget = null);
//                       _showAddBudgetSheet(context, budget: budgetToEdit);
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete),
//                     tooltip: "Delete Budget",
//                     onPressed: () async {
//                       final budgetToDelete = _selectedBudget!;
//                       if (await _showDeleteConfirmDialog(
//                         context,
//                         budgetToDelete.category,
//                       )) {
//                         database.deleteBudget(budgetToDelete.category);
//                         setState(() => _selectedBudget = null);
//                       }
//                     },
//                   ),
//                   const SizedBox(width: 8),
//                 ],
//               ),

//         floatingActionButton: _selectedBudget == null
//             ? FloatingActionButton.extended(
//                 onPressed: () => _showAddBudgetSheet(context),
//                 backgroundColor: primaryColor,
//                 elevation: 4,
//                 icon: const Icon(Icons.add_rounded, color: Colors.white),
//                 label: const Text(
//                   "Set Limit",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               )
//             : null,

//         body: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.only(bottom: 100),
//           child: Column(
//             children: [
//               _buildDashboard(context),

//               // HEADER
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Monthly Limits",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w800,
//                         color: Theme.of(context).colorScheme.onSurface,
//                       ),
//                     ),
//                     const Spacer(),
//                     Icon(
//                       Icons.touch_app_outlined,
//                       size: 16,
//                       color: Colors.grey[500],
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       "Long press to edit",
//                       style: TextStyle(fontSize: 12, color: Colors.grey[500]),
//                     ),
//                   ],
//                 ),
//               ),

//               // LIST
//               StreamBuilder<List<Budget>>(
//                 stream: database.watchAllBudgets(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) return const SizedBox();
//                   final budgets = snapshot.data!;
//                   if (budgets.isEmpty) return _buildEmptyState();

//                   return StreamBuilder<List<Expense>>(
//                     stream: database.watchAllExpenses(),
//                     builder: (context, expSnap) {
//                       final expenses = expSnap.data ?? [];
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: budgets.length,
//                         itemBuilder: (context, index) {
//                           return _buildBudgetItem(
//                             context,
//                             budgets[index],
//                             expenses,
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- DASHBOARD (Kept same) ---
//   Widget _buildDashboard(BuildContext context) {
//     final cardColor = Theme.of(context).cardColor;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
//       height: 340,
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "Spending Analysis",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Container(
//                 height: 36,
//                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                 decoration: BoxDecoration(
//                   color: isDark ? Colors.grey[800] : Colors.grey[100],
//                   borderRadius: BorderRadius.circular(18),
//                   border: Border.all(color: Colors.grey.withOpacity(0.2)),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.chevron_left, size: 20),
//                       padding: EdgeInsets.zero,
//                       constraints: const BoxConstraints(
//                         minWidth: 32,
//                         minHeight: 32,
//                       ),
//                       color: Colors.grey[600],
//                       onPressed: () => setState(
//                         () => _currentMonth = DateTime(
//                           _currentMonth.year,
//                           _currentMonth.month - 1,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 4),
//                       child: Text(
//                         DateFormat('MMM yyyy').format(_currentMonth),
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.chevron_right, size: 20),
//                       padding: EdgeInsets.zero,
//                       constraints: const BoxConstraints(
//                         minWidth: 32,
//                         minHeight: 32,
//                       ),
//                       color: Colors.grey[600],
//                       onPressed: () => setState(
//                         () => _currentMonth = DateTime(
//                           _currentMonth.year,
//                           _currentMonth.month + 1,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: StreamBuilder<List<Expense>>(
//               stream: database.watchAllExpenses(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData)
//                   return const Center(child: CircularProgressIndicator());
//                 return _buildSyncfusionChart(snapshot.data!, isDark);
//               },
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildLegendDot(Colors.blueAccent, "Daily Spend"),
//               const SizedBox(width: 16),
//               _buildLegendDot(Colors.redAccent, "Weekly Trend"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSyncfusionChart(List<Expense> allExpenses, bool isDark) {
//     final monthExpenses = allExpenses
//         .where(
//           (e) =>
//               e.date.month == _currentMonth.month &&
//               e.date.year == _currentMonth.year,
//         )
//         .toList();
//     Map<int, double> dailyTotals = {};
//     for (var e in monthExpenses)
//       dailyTotals[e.date.day] = (dailyTotals[e.date.day] ?? 0) + e.amount;
//     List<ChartData> dailyData =
//         dailyTotals.entries
//             .map(
//               (e) => ChartData(
//                 e.key,
//                 e.value,
//                 DateFormat('MMM d').format(
//                   DateTime(_currentMonth.year, _currentMonth.month, e.key),
//                 ),
//               ),
//             )
//             .toList()
//           ..sort((a, b) => a.x.compareTo(b.x));

//     Map<int, double> weeklyTotals = {};
//     for (var e in monthExpenses) {
//       int weekNum = ((e.date.day - 1) / 7).floor() + 1;
//       int plotDay = weekNum * 7;
//       if (plotDay > 30) plotDay = 30;
//       weeklyTotals[plotDay] = (weeklyTotals[plotDay] ?? 0) + e.amount;
//     }
//     List<ChartData> weeklyData =
//         weeklyTotals.entries
//             .map((e) => ChartData(e.key, e.value, "Week ${e.key ~/ 7}"))
//             .toList()
//           ..sort((a, b) => a.x.compareTo(b.x));

//     if (dailyData.isEmpty)
//       return Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.bar_chart, color: Colors.grey[300], size: 48),
//             Text("No data yet", style: TextStyle(color: Colors.grey[400])),
//           ],
//         ),
//       );

//     return SfCartesianChart(
//       plotAreaBorderWidth: 0,
//       tooltipBehavior: _tooltipBehavior,
//       primaryXAxis: NumericAxis(
//         interval: 5,
//         majorGridLines: const MajorGridLines(width: 0),
//         axisLine: const AxisLine(width: 0),
//         labelStyle: TextStyle(color: Colors.grey[600], fontSize: 10),
//         axisLabelFormatter: (args) => ChartAxisLabel(
//           "${args.value.toInt()}",
//           const TextStyle(fontSize: 10, color: Colors.grey),
//         ),
//       ),
//       primaryYAxis: NumericAxis(
//         isVisible: false,
//         majorGridLines: const MajorGridLines(width: 0),
//       ),
//       series: <CartesianSeries>[
//         SplineSeries<ChartData, int>(
//           dataSource: weeklyData,
//           xValueMapper: (ChartData data, _) => data.x,
//           yValueMapper: (ChartData data, _) => data.amount,
//           color: Colors.redAccent.withOpacity(0.5),
//           width: 3,
//           dashArray: <double>[5, 5],
//           enableTooltip: true,
//         ),
//         SplineAreaSeries<ChartData, int>(
//           dataSource: dailyData,
//           xValueMapper: (ChartData data, _) => data.x,
//           yValueMapper: (ChartData data, _) => data.amount,
//           gradient: LinearGradient(
//             colors: [
//               Colors.blueAccent.withOpacity(0.4),
//               Colors.blueAccent.withOpacity(0.0),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderColor: Colors.blueAccent,
//           borderWidth: 3,
//           markerSettings: const MarkerSettings(
//             isVisible: true,
//             color: Colors.white,
//             borderColor: Colors.blueAccent,
//             borderWidth: 2,
//             width: 8,
//             height: 8,
//           ),
//           enableTooltip: true,
//         ),
//       ],
//     );
//   }

//   // --- BUDGET ITEM (UPDATED CHECKMARK) ---
//   Widget _buildBudgetItem(
//     BuildContext context,
//     Budget budget,
//     List<Expense> allExpenses,
//   ) {
//     final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final isSelected = _selectedBudget?.id == budget.id;
//     final spent = allExpenses
//         .where(
//           (e) =>
//               e.category == budget.category &&
//               e.date.month == _currentMonth.month &&
//               e.date.year == _currentMonth.year,
//         )
//         .fold(0.0, (sum, e) => sum + e.amount);
//     final double progress = (spent / budget.limit).clamp(0.0, 1.0);

//     Color statusColor = progress >= 1.0
//         ? Colors.redAccent
//         : (progress >= 0.8 ? Colors.orangeAccent : const Color(0xFF0F766E));
//     String statusText = progress >= 1.0
//         ? "Exceeded"
//         : (progress >= 0.8 ? "Warning" : "Safe");

//     return Dismissible(
//       key: Key("budget_${budget.id}"),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           color: Colors.red[400],
//           borderRadius: BorderRadius.circular(16),
//         ),
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20),
//         child: const Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Text(
//               "Delete",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(width: 8),
//             Icon(Icons.delete_outline, color: Colors.white),
//           ],
//         ),
//       ),
//       confirmDismiss: (_) async =>
//           await _showDeleteConfirmDialog(context, budget.category),
//       onDismissed: (_) => database.deleteBudget(budget.category),
//       child: GestureDetector(
//         onLongPress: () {
//           HapticFeedback.mediumImpact();
//           setState(() => _selectedBudget = budget);
//         },
//         onTap: () {
//           if (_selectedBudget != null) setState(() => _selectedBudget = null);
//         },
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: isSelected
//                 ? Colors.green.withOpacity(0.05)
//                 : Theme.of(context).cardColor, // ✅ Light Green tint
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: isSelected
//                   ? Colors.green
//                   : (isDark
//                         ? Colors.grey[800]!
//                         : Colors.grey[200]!), // ✅ Green Border
//               width: isSelected ? 2 : 1,
//             ),
//             boxShadow: [
//               if (!isSelected)
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.02),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   FutureBuilder<List<Tag>>(
//                     future: database.watchAllTags().first,
//                     builder: (context, tagSnap) {
//                       final tag = tagSnap.data?.firstWhere(
//                         (t) => t.name == budget.category,
//                         orElse: () => Tag(
//                           name: budget.category,
//                           color: 0,
//                           isCustom: false,
//                           emoji: null,
//                         ),
//                       );
//                       return Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           // ✅ GREEN BG if Selected
//                           color: isSelected
//                               ? Colors.green
//                               : (isDark ? Colors.grey[800] : Colors.grey[100]),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         // ✅ SMALL GREEN TICK
//                         child: isSelected
//                             ? const Icon(
//                                 Icons.check,
//                                 size: 18,
//                                 color: Colors.white,
//                               ) // ✅ Small Tick
//                             : CategoryStyleHelper.getTagIcon(
//                                 budget.category,
//                                 size: 22,
//                                 emoji: tag?.emoji,
//                               ),
//                       );
//                     },
//                   ),
//                   const SizedBox(width: 14),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               budget.category,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 2,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: statusColor.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 statusText,
//                                 style: TextStyle(
//                                   color: statusColor,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "$currency${spent.toStringAsFixed(0)} spent",
//                               style: TextStyle(
//                                 color: statusColor,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13,
//                               ),
//                             ),
//                             Text(
//                               "Limit: $currency${budget.limit.toStringAsFixed(0)}",
//                               style: TextStyle(
//                                 color: Colors.grey[500],
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Stack(
//                 children: [
//                   Container(
//                     height: 8,
//                     decoration: BoxDecoration(
//                       color: isDark ? Colors.grey[800] : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                   FractionallySizedBox(
//                     widthFactor: progress,
//                     child: Container(
//                       height: 8,
//                       decoration: BoxDecoration(
//                         color: statusColor,
//                         borderRadius: BorderRadius.circular(4),
//                         boxShadow: [
//                           BoxShadow(
//                             color: statusColor.withOpacity(0.4),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- DIALOGS (Kept same logic) ---
//   Future<bool> _showDeleteConfirmDialog(
//     BuildContext context,
//     String category,
//   ) async {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return await showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             backgroundColor: isDark ? Colors.grey[900] : Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             title: const Text(
//               "Delete Budget?",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             content: Text(
//               "Delete budget for $category? Spending data remains.",
//               style: TextStyle(
//                 color: isDark ? Colors.grey[300] : Colors.grey[700],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(ctx).pop(false),
//                 child: Text(
//                   "Cancel",
//                   style: TextStyle(
//                     color: isDark ? Colors.grey[400] : Colors.grey[600],
//                   ),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () => Navigator.of(ctx).pop(true),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   "Delete",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }

//   void _showAddBudgetSheet(BuildContext context, {Budget? budget}) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final amountController = TextEditingController(
//       text: budget?.limit.toStringAsFixed(0) ?? "",
//     );
//     String? selectedCategory = budget?.category;
//     bool isCreatingNew = false;
//     final newTagController = TextEditingController();
//     String newTagEmoji = "💰";

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (ctx) => StatefulBuilder(
//         builder: (context, setState) {
//           return Padding(
//             padding: EdgeInsets.fromLTRB(
//               20,
//               20,
//               20,
//               MediaQuery.of(context).viewInsets.bottom + 20,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[400],
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   budget == null ? "New Monthly Limit" : "Update Limit",
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Text(
//                   "CATEGORY",
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[500],
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 if (budget != null)
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isDark ? Colors.black26 : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Row(
//                       children: [
//                         CategoryStyleHelper.getTagIcon(
//                           budget.category,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 10),
//                         Text(
//                           budget.category,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const Spacer(),
//                         const Icon(
//                           Icons.lock_outline,
//                           size: 16,
//                           color: Colors.grey,
//                         ),
//                       ],
//                     ),
//                   )
//                 else
//                   AnimatedCrossFade(
//                     duration: const Duration(milliseconds: 300),
//                     crossFadeState: isCreatingNew
//                         ? CrossFadeState.showSecond
//                         : CrossFadeState.showFirst,
//                     firstChild: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: isDark ? Colors.black26 : Colors.grey[100],
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: StreamBuilder<List<Tag>>(
//                         stream: database.watchAllTags(),
//                         builder: (context, snapshot) {
//                           final tags = snapshot.data ?? [];
//                           return DropdownButtonHideUnderline(
//                             child: DropdownButton<String>(
//                               value: selectedCategory,
//                               hint: const Text("Select a category"),
//                               isExpanded: true,
//                               icon: const Icon(
//                                 Icons.keyboard_arrow_down_rounded,
//                               ),
//                               items: [
//                                 ...tags.map(
//                                   (t) => DropdownMenuItem(
//                                     value: t.name,
//                                     child: Row(
//                                       children: [
//                                         CategoryStyleHelper.getTagIcon(
//                                           t.name,
//                                           size: 20,
//                                           emoji: t.emoji,
//                                         ),
//                                         const SizedBox(width: 10),
//                                         Text(t.name),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 const DropdownMenuItem(
//                                   value: "CREATE_NEW",
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.add_circle,
//                                         color: Colors.blueAccent,
//                                       ),
//                                       SizedBox(width: 10),
//                                       Text(
//                                         "Create New Category",
//                                         style: TextStyle(
//                                           color: Colors.blueAccent,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                               onChanged: (val) {
//                                 if (val == "CREATE_NEW")
//                                   setState(() => isCreatingNew = true);
//                                 else
//                                   setState(() => selectedCategory = val);
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     secondChild: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.blueAccent.withOpacity(0.05),
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: Colors.blueAccent.withOpacity(0.3),
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               const Text(
//                                 "New Category",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blueAccent,
//                                 ),
//                               ),
//                               const Spacer(),
//                               IconButton(
//                                 icon: const Icon(Icons.close, size: 18),
//                                 onPressed: () =>
//                                     setState(() => isCreatingNew = false),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               SizedBox(
//                                 width: 50,
//                                 child: TextField(
//                                   textAlign: TextAlign.center,
//                                   decoration: const InputDecoration(
//                                     hintText: "💰",
//                                     border: InputBorder.none,
//                                   ),
//                                   onChanged: (val) => newTagEmoji = val,
//                                 ),
//                               ),
//                               Expanded(
//                                 child: TextField(
//                                   controller: newTagController,
//                                   decoration: const InputDecoration(
//                                     hintText: "Name (e.g. Sushi)",
//                                     border: UnderlineInputBorder(),
//                                     isDense: true,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 const SizedBox(height: 24),
//                 Text(
//                   "MONTHLY LIMIT",
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[500],
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   decoration: InputDecoration(
//                     prefixText:
//                         "${Provider.of<SettingsViewModel>(context, listen: false).currencySymbol} ",
//                     hintText: "0",
//                     filled: true,
//                     fillColor: isDark ? Colors.black26 : Colors.grey[100],
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(16),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 16,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 55,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (isCreatingNew && newTagController.text.isNotEmpty) {
//                         await database.insertTag(
//                           TagsCompanion(
//                             name: drift.Value(newTagController.text.trim()),
//                             emoji: drift.Value(newTagEmoji),
//                             isCustom: const drift.Value(true),
//                           ),
//                         );
//                         selectedCategory = newTagController.text.trim();
//                       }
//                       final amount = double.tryParse(amountController.text);
//                       if (amount != null && selectedCategory != null) {
//                         database.setBudget(selectedCategory!, amount);
//                         Navigator.pop(ctx);
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Theme.of(context).primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     child: Text(
//                       budget == null ? "Set Limit" : "Update Limit",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 40),
//       child: Column(
//         children: [
//           Icon(Icons.savings_outlined, size: 60, color: Colors.grey[300]),
//           const SizedBox(height: 10),
//           Text(
//             "No budgets set yet",
//             style: TextStyle(color: Colors.grey[500], fontSize: 16),
//           ),
//           Text(
//             "Tap + to control your spending",
//             style: TextStyle(color: Colors.grey[400], fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLegendDot(Color color, String label) {
//     return Row(
//       children: [
//         Container(
//           width: 8,
//           height: 8,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 6),
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//       ],
//     );
//   }
// }

// class ChartData {
//   final int x;
//   final double amount;
//   final String label;
//   ChartData(this.x, this.amount, this.label);
// }

import 'package:bill_buddy/data/local/database.dart';
import 'package:bill_buddy/ui/budget/view_model/budget_view_model.dart';
import 'package:bill_buddy/ui/budget/widget/budget_widget.dart';

import 'package:bill_buddy/util/category_style_helper.dart';
import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BudgetViewModel(),
      child: const _BudgetScreenContent(),
    );
  }
}

class _BudgetScreenContent extends StatefulWidget {
  const _BudgetScreenContent();

  @override
  State<_BudgetScreenContent> createState() => _BudgetScreenContentState();
}

class _BudgetScreenContentState extends State<_BudgetScreenContent> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BudgetViewModel>(context);
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        if (viewModel.selectedBudget != null) {
          viewModel.selectBudget(null);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.grey[50],

        // --- APP BAR ---
        appBar: viewModel.selectedBudget == null
            ? AppBar(
                title: const Text("Budget & Analytics"),
                centerTitle: false,
                elevation: 0,
                backgroundColor: isDark ? Colors.black : Colors.white,
                foregroundColor: isDark ? Colors.white : Colors.black,
              )
            : AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => viewModel.selectBudget(null),
                ),
                title: Text(viewModel.selectedBudget!.category, style: const TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: isDark ? Colors.grey[900] : Colors.green[700],
                foregroundColor: Colors.white,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: "Edit Limit",
                    onPressed: () {
                      final budgetToEdit = viewModel.selectedBudget!;
                      viewModel.selectBudget(null);
                      _showAddBudgetSheet(context, viewModel, budget: budgetToEdit);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: "Delete Budget",
                    onPressed: () async {
                      final budget = viewModel.selectedBudget!;
                      if (await _showDeleteConfirmDialog(context, budget.category)) {
                        viewModel.deleteBudget(budget.category);
                        viewModel.selectBudget(null);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),

        // --- FAB ---
        floatingActionButton: viewModel.selectedBudget == null
            ? FloatingActionButton.extended(
                onPressed: () => _showAddBudgetSheet(context, viewModel),
                backgroundColor: primaryColor,
                elevation: 4,
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text("Set Limit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              )
            : null,

        // --- BODY ---
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              // 1. DASHBOARD COMPONENT
              BudgetDashboard(viewModel: viewModel),

              // 2. LIST HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: [
                    Text("Monthly Limits", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface)),
                    const Spacer(),
                    Icon(Icons.touch_app_outlined, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text("Long press to edit", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ),

              // 3. BUDGET LIST
              StreamBuilder<List<Budget>>(
                stream: viewModel.watchBudgets(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();
                  final budgets = snapshot.data!;
                  
                  if (budgets.isEmpty) return _buildEmptyState();

                  return StreamBuilder<List<Expense>>(
                    stream: viewModel.watchExpenses(),
                    builder: (context, expSnap) {
                      final expenses = expSnap.data ?? [];
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: budgets.length,
                        itemBuilder: (context, index) {
                          final budget = budgets[index];
                          return BudgetItem(
                            budget: budget,
                            allExpenses: expenses,
                            currentMonth: viewModel.currentMonth,
                            isSelected: viewModel.selectedBudget?.id == budget.id,
                            onTap: () {
                                if (viewModel.selectedBudget != null) viewModel.selectBudget(null);
                            },
                            onLongPress: () {
                                HapticFeedback.mediumImpact();
                                viewModel.selectBudget(budget);
                            },
                            onDelete: () => viewModel.deleteBudget(budget.category),
                            confirmDelete: () => _showDeleteConfirmDialog(context, budget.category),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER DIALOGS ---
  
  Future<bool> _showDeleteConfirmDialog(BuildContext context, String category) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Budget?", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Delete budget for $category? Spending data remains.", style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700])),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text("Cancel", style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]))),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), child: const Text("Delete", style: TextStyle(color: Colors.white))),
        ],
      )
    ) ?? false;
  }

  void _showAddBudgetSheet(BuildContext context, BudgetViewModel viewModel, {Budget? budget}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final amountController = TextEditingController(text: budget?.limit.toStringAsFixed(0) ?? "");
    String? selectedCategory = budget?.category;
    bool isCreatingNew = false;
    final newTagController = TextEditingController();
    String newTagEmoji = "💰";

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text(budget == null ? "New Monthly Limit" : "Update Limit", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Text("CATEGORY", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.2)),
            const SizedBox(height: 10),
            if (budget != null)
              Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: isDark ? Colors.black26 : Colors.grey[200], borderRadius: BorderRadius.circular(16)), child: Row(children: [CategoryStyleHelper.getTagIcon(budget.category, size: 20), const SizedBox(width: 10), Text(budget.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const Spacer(), const Icon(Icons.lock_outline, size: 16, color: Colors.grey)]))
            else
              AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300), crossFadeState: isCreatingNew ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  firstChild: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), decoration: BoxDecoration(color: isDark ? Colors.black26 : Colors.grey[100], borderRadius: BorderRadius.circular(16)), child: StreamBuilder<List<Tag>>(stream: viewModel.watchTags(), builder: (context, snapshot) { final tags = snapshot.data ?? []; return DropdownButtonHideUnderline(child: DropdownButton<String>(value: selectedCategory, hint: const Text("Select a category"), isExpanded: true, icon: const Icon(Icons.keyboard_arrow_down_rounded), items: [...tags.map((t) => DropdownMenuItem(value: t.name, child: Row(children: [CategoryStyleHelper.getTagIcon(t.name, size: 20, emoji: t.emoji), const SizedBox(width: 10), Text(t.name)]))), const DropdownMenuItem(value: "CREATE_NEW", child: Row(children: [Icon(Icons.add_circle, color: Colors.blueAccent), SizedBox(width: 10), Text("Create New Category", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))]))], onChanged: (val) { if (val == "CREATE_NEW") {
                    setState(() => isCreatingNew = true);
                  } else {
                    setState(() => selectedCategory = val);
                  } })); })),
                  secondChild: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blueAccent.withOpacity(0.3))), child: Column(children: [Row(children: [const Text("New Category", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)), const Spacer(), IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => setState(() => isCreatingNew = false))]), Row(children: [SizedBox(width: 50, child: TextField(textAlign: TextAlign.center, decoration: const InputDecoration(hintText: "💰", border: InputBorder.none), onChanged: (val) => newTagEmoji = val)), Expanded(child: TextField(controller: newTagController, decoration: const InputDecoration(hintText: "Name", border: UnderlineInputBorder(), isDense: true)))] )]))),
            const SizedBox(height: 24),
            Text("MONTHLY LIMIT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.2)),
            const SizedBox(height: 10),
            TextField(controller: amountController, keyboardType: TextInputType.number, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), inputFormatters: [FilteringTextInputFormatter.digitsOnly], decoration: InputDecoration(prefixText: "${Provider.of<SettingsViewModel>(context, listen: false).currencySymbol} ", hintText: "0", filled: true, fillColor: isDark ? Colors.black26 : Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16))),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: () async { if (isCreatingNew && newTagController.text.isNotEmpty) { await viewModel.createNewTag(newTagController.text.trim(), newTagEmoji); selectedCategory = newTagController.text.trim(); } final amount = double.tryParse(amountController.text); if (amount != null && selectedCategory != null) { viewModel.saveBudget(selectedCategory!, amount); Navigator.pop(ctx); } }, style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: Text(budget == null ? "Set Limit" : "Update Limit", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))),
          ]),
        );
      }),
    );
  }

  Widget _buildEmptyState() { return Padding(padding: const EdgeInsets.only(top: 40), child: Column(children: [Icon(Icons.savings_outlined, size: 60, color: Colors.grey[300]), const SizedBox(height: 10), Text("No budgets set yet", style: TextStyle(color: Colors.grey[500], fontSize: 16)), Text("Tap + to control your spending", style: TextStyle(color: Colors.grey[400], fontSize: 14))])); }
}