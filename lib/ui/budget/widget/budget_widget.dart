// import 'package:bill_buddy/data/local/database.dart';
// import 'package:bill_buddy/ui/budget/view_model/budget_view_model.dart';
// import 'package:bill_buddy/util/category_style_helper.dart';
// import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// // -----------------------------------------------------------------------------
// // 📊 DASHBOARD WIDGET (Chart + Month Switcher)
// // -----------------------------------------------------------------------------
// class BudgetDashboard extends StatelessWidget {
//   final BudgetViewModel viewModel;

//   const BudgetDashboard({super.key, required this.viewModel});

//   @override
//   Widget build(BuildContext context) {
//     final cardColor = Theme.of(context).cardColor;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
//       height: 340,
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
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
//           // ✅ FIXED: ROW OVERFLOW
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Flexible( // Allows text to shrink if needed
//                 child: Text(
//                   "Analysis",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               _buildMonthSwitcher(context),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: StreamBuilder<List<Expense>>(
//               stream: viewModel.watchExpenses(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//                 return _buildSyncfusionChart(context, snapshot.data!, isDark);
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

//   Widget _buildMonthSwitcher(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       height: 36,
//       padding: const EdgeInsets.symmetric(horizontal: 4),
//       decoration: BoxDecoration(
//         color: isDark ? Colors.grey[800] : Colors.grey[100],
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: Colors.grey.withOpacity(0.2)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.chevron_left, size: 20),
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
//             color: Colors.grey[600],
//             onPressed: viewModel.previousMonth,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: Text(
//               viewModel.formattedMonth,
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).colorScheme.onSurface,
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.chevron_right, size: 20),
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
//             color: Colors.grey[600],
//             onPressed: viewModel.nextMonth,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSyncfusionChart(BuildContext context, List<Expense> allExpenses, bool isDark) {
//     final currentMonth = viewModel.currentMonth;
    
//     // Filter Data
//     final monthExpenses = allExpenses.where((e) =>
//         e.date.month == currentMonth.month && e.date.year == currentMonth.year
//     ).toList();

//     // Process Daily Data
//     Map<int, double> dailyTotals = {};
//     for (var e in monthExpenses) {
//       dailyTotals[e.date.day] = (dailyTotals[e.date.day] ?? 0) + e.amount;
//     }
//     List<ChartData> dailyData = dailyTotals.entries
//         .map((e) => ChartData(e.key, e.value, DateFormat('MMM d').format(DateTime(currentMonth.year, currentMonth.month, e.key))))
//         .toList()..sort((a, b) => a.x.compareTo(b.x));

//     // Process Weekly Data
//     Map<int, double> weeklyTotals = {};
//     for (var e in monthExpenses) {
//       int weekNum = ((e.date.day - 1) / 7).floor() + 1;
//       int plotDay = weekNum * 7;
//       if (plotDay > 30) plotDay = 30;
//       weeklyTotals[plotDay] = (weeklyTotals[plotDay] ?? 0) + e.amount;
//     }
//     List<ChartData> weeklyData = weeklyTotals.entries
//         .map((e) => ChartData(e.key, e.value, "Week ${e.key ~/ 7}"))
//         .toList()..sort((a, b) => a.x.compareTo(b.x));

//     if (dailyData.isEmpty) {
//       return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.bar_chart, color: Colors.grey[300], size: 48), Text("No data yet", style: TextStyle(color: Colors.grey[400]))]));
//     }

//     return SfCartesianChart(
//       plotAreaBorderWidth: 0,
//       primaryXAxis: NumericAxis(
//         interval: 5,
//         majorGridLines: const MajorGridLines(width: 0),
//         axisLine: const AxisLine(width: 0),
//         labelStyle: TextStyle(color: Colors.grey[600], fontSize: 10),
//         axisLabelFormatter: (args) => ChartAxisLabel("${args.value.toInt()}", const TextStyle(fontSize: 10, color: Colors.grey)),
//       ),
//       primaryYAxis: NumericAxis(isVisible: false, majorGridLines: const MajorGridLines(width: 0)),
//       series: <CartesianSeries>[
//         SplineSeries<ChartData, int>(
//           dataSource: weeklyData,
//           xValueMapper: (ChartData data, _) => data.x,
//           yValueMapper: (ChartData data, _) => data.amount,
//           color: Colors.redAccent.withOpacity(0.5),
//           width: 3,
//           dashArray: <double>[5, 5],
//         ),
//         SplineAreaSeries<ChartData, int>(
//           dataSource: dailyData,
//           xValueMapper: (ChartData data, _) => data.x,
//           yValueMapper: (ChartData data, _) => data.amount,
//           gradient: LinearGradient(
//             colors: [Colors.blueAccent.withOpacity(0.4), Colors.blueAccent.withOpacity(0.0)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderColor: Colors.blueAccent,
//           borderWidth: 3,
//           markerSettings: const MarkerSettings(isVisible: true, color: Colors.white, borderColor: Colors.blueAccent, borderWidth: 2, width: 8, height: 8),
//         ),
//       ],
//     );
//   }

//   Widget _buildLegendDot(Color color, String label) {
//     return Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 6), Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
//   }
// }

// // -----------------------------------------------------------------------------
// // 📝 BUDGET ITEM WIDGET
// // -----------------------------------------------------------------------------
// class BudgetItem extends StatelessWidget {
//   final Budget budget;
//   final List<Expense> allExpenses;
//   final DateTime currentMonth;
//   final bool isSelected;
//   final VoidCallback onTap;
//   final VoidCallback onLongPress;
//   final VoidCallback onDelete;
//   final Future<bool> Function() confirmDelete;

//   const BudgetItem({
//     super.key,
//     required this.budget,
//     required this.allExpenses,
//     required this.currentMonth,
//     required this.isSelected,
//     required this.onTap,
//     required this.onLongPress,
//     required this.onDelete,
//     required this.confirmDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final spent = allExpenses
//         .where((e) => e.category == budget.category && e.date.month == currentMonth.month && e.date.year == currentMonth.year)
//         .fold(0.0, (sum, e) => sum + e.amount);

//     final double progress = (spent / budget.limit).clamp(0.0, 1.0);
//     Color statusColor = progress >= 1.0 ? Colors.redAccent : (progress >= 0.8 ? Colors.orangeAccent : const Color(0xFF0F766E));
//     String statusText = progress >= 1.0 ? "Exceeded" : (progress >= 0.8 ? "Warning" : "Safe");

//     return Dismissible(
//       key: Key("budget_${budget.id}"),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(color: Colors.red[400], borderRadius: BorderRadius.circular(16)),
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20),
//         child: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), SizedBox(width: 8), Icon(Icons.delete_outline, color: Colors.white)]),
//       ),
//       confirmDismiss: (_) => confirmDelete(),
//       onDismissed: (_) => onDelete(),
//       child: GestureDetector(
//         onLongPress: onLongPress,
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: isSelected ? Colors.green.withOpacity(0.05) : Theme.of(context).cardColor,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: isSelected ? Colors.green : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
//               width: isSelected ? 2 : 1
//             ),
//             boxShadow: [if (!isSelected) BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
//           ),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                    FutureBuilder<List<Tag>>(
//                     future: database.watchAllTags().first,
//                     builder: (context, tagSnap) {
//                       final tag = tagSnap.data?.firstWhere((t) => t.name == budget.category, orElse: () => Tag(name: budget.category, color: 0, isCustom: false, emoji: null));
//                       return Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: isSelected ? Colors.green : (isDark ? Colors.grey[800] : Colors.grey[100]),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: isSelected 
//                             ? const Icon(Icons.check, size: 18, color: Colors.white)
//                             : CategoryStyleHelper.getTagIcon(budget.category, size: 22, emoji: tag?.emoji),
//                       );
//                     }
//                   ),
//                   const SizedBox(width: 14),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(budget.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                             Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)))
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("$currency${spent.toStringAsFixed(0)} spent", style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13)),
//                             Text("Limit: $currency${budget.limit.toStringAsFixed(0)}", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Stack(children: [
//                 Container(height: 8, decoration: BoxDecoration(color: isDark ? Colors.grey[800] : Colors.grey[200], borderRadius: BorderRadius.circular(4))),
//                 FractionallySizedBox(widthFactor: progress, child: Container(height: 8, decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: statusColor.withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 2))])))
//               ])
//             ],
//           ),
//         ),
//       ),
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
import 'package:bill_buddy/util/category_style_helper.dart';
import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// -----------------------------------------------------------------------------
// 📊 DASHBOARD WIDGET (Chart + Month Switcher + Toggle Labels)
// -----------------------------------------------------------------------------
class BudgetDashboard extends StatefulWidget {
  final BudgetViewModel viewModel;

  const BudgetDashboard({super.key, required this.viewModel});

  @override
  State<BudgetDashboard> createState() => _BudgetDashboardState();
}

class _BudgetDashboardState extends State<BudgetDashboard> {
  // ✅ State to toggle data labels (Default: True as per request)
  bool _showLabels = true;

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      // ✅ Tap anywhere on the dashboard to toggle labels
      onTap: () {
        setState(() {
          _showLabels = !_showLabels;
        });
        HapticFeedback.selectionClick(); // Nice vibration feedback
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
        height: 360, // Slightly taller to fit labels
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    "Analysis",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildMonthSwitcher(context),
              ],
            ),
            
            // Hint Text (Optional)
            if (!_showLabels)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "Tap to show data points", 
                  style: TextStyle(fontSize: 10, color: Colors.grey[500], fontStyle: FontStyle.italic)
                ),
              ),

            const SizedBox(height: 10),
            
            // CHART
            Expanded(
              child: StreamBuilder<List<Expense>>(
                stream: widget.viewModel.watchExpenses(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  return _buildSyncfusionChart(context, snapshot.data!, isDark);
                },
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendDot(Colors.blueAccent, "Daily Spend"),
                const SizedBox(width: 16),
                _buildLegendDot(Colors.redAccent, "Weekly Trend"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSwitcher(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            color: Colors.grey[600],
            onPressed: widget.viewModel.previousMonth,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              widget.viewModel.formattedMonth,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            color: Colors.grey[600],
            onPressed: widget.viewModel.nextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildSyncfusionChart(BuildContext context, List<Expense> allExpenses, bool isDark) {
    final currentMonth = widget.viewModel.currentMonth;
    
    final monthExpenses = allExpenses.where((e) =>
        e.date.month == currentMonth.month && e.date.year == currentMonth.year
    ).toList();

    // Daily Data
    Map<int, double> dailyTotals = {};
    for (var e in monthExpenses) {
      dailyTotals[e.date.day] = (dailyTotals[e.date.day] ?? 0) + e.amount;
    }
    List<ChartData> dailyData = dailyTotals.entries
        .map((e) => ChartData(e.key, e.value, DateFormat('MMM d').format(DateTime(currentMonth.year, currentMonth.month, e.key))))
        .toList()..sort((a, b) => a.x.compareTo(b.x));

    // Weekly Data
    Map<int, double> weeklyTotals = {};
    for (var e in monthExpenses) {
      int weekNum = ((e.date.day - 1) / 7).floor() + 1;
      int plotDay = weekNum * 7;
      if (plotDay > 30) plotDay = 30;
      weeklyTotals[plotDay] = (weeklyTotals[plotDay] ?? 0) + e.amount;
    }
    List<ChartData> weeklyData = weeklyTotals.entries
        .map((e) => ChartData(e.key, e.value, "Week ${e.key ~/ 7}"))
        .toList()..sort((a, b) => a.x.compareTo(b.x));

    if (dailyData.isEmpty) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.bar_chart, color: Colors.grey[300], size: 48), Text("No data yet", style: TextStyle(color: Colors.grey[400]))]));
    }

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      
      // ✅ Allow zooming/panning if labels get crowded
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enablePanning: true,
      ),

      primaryXAxis: NumericAxis(
        interval: 5,
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 10),
        axisLabelFormatter: (args) => ChartAxisLabel("${args.value.toInt()}", const TextStyle(fontSize: 10, color: Colors.grey)),
      ),
      primaryYAxis: NumericAxis(isVisible: false, majorGridLines: const MajorGridLines(width: 0)),
      
      series: <CartesianSeries>[
        // Weekly Line
        SplineSeries<ChartData, int>(
          dataSource: weeklyData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.amount,
          color: Colors.redAccent.withOpacity(0.5),
          width: 3,
          dashArray: <double>[5, 5],
          // ✅ Data Labels for Weekly
          dataLabelSettings: DataLabelSettings(
            isVisible: _showLabels, // Controlled by tap
            labelAlignment: ChartDataLabelAlignment.auto,
            textStyle: const TextStyle(fontSize: 10, color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
        ),
        
        // Daily Area
        SplineAreaSeries<ChartData, int>(
          dataSource: dailyData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.amount,
          gradient: LinearGradient(
            colors: [Colors.blueAccent.withOpacity(0.4), Colors.blueAccent.withOpacity(0.0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderColor: Colors.blueAccent,
          borderWidth: 3,
          markerSettings: const MarkerSettings(isVisible: true, color: Colors.white, borderColor: Colors.blueAccent, borderWidth: 2, width: 8, height: 8),
          
          // ✅ Data Labels for Daily (The Dots)
          dataLabelSettings: DataLabelSettings(
            isVisible: _showLabels, // Controlled by tap
            labelAlignment: ChartDataLabelAlignment.top, // Shows above the dot
            offset: const Offset(0, -5), // Slightly higher
            textStyle: TextStyle(fontSize: 9, color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
            // Custom Mapper: Shows Amount (e.g. 500)
            builder: (data, point, series, pointIndex, seriesIndex) {
               final amount = (data as ChartData).amount.toInt();
               return Text(
                 amount > 0 ? "$amount" : "", // Hide 0 values to clean up
                 style: TextStyle(fontSize: 9, color: isDark ? Colors.white : Colors.blue[900], fontWeight: FontWeight.w600),
               );
            }
          ),
        ),
      ],
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 6), Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
  }
}

// -----------------------------------------------------------------------------
// 📝 BUDGET ITEM WIDGET (Unchanged)
// -----------------------------------------------------------------------------
class BudgetItem extends StatelessWidget {
  final Budget budget;
  final List<Expense> allExpenses;
  final DateTime currentMonth;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDelete;
  final Future<bool> Function() confirmDelete;

  const BudgetItem({
    super.key,
    required this.budget,
    required this.allExpenses,
    required this.currentMonth,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onDelete,
    required this.confirmDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final spent = allExpenses
        .where((e) => e.category == budget.category && e.date.month == currentMonth.month && e.date.year == currentMonth.year)
        .fold(0.0, (sum, e) => sum + e.amount);

    final double progress = (spent / budget.limit).clamp(0.0, 1.0);
    Color statusColor = progress >= 1.0 ? Colors.redAccent : (progress >= 0.8 ? Colors.orangeAccent : const Color(0xFF0F766E));
    String statusText = progress >= 1.0 ? "Exceeded" : (progress >= 0.8 ? "Warning" : "Safe");

    return Dismissible(
      key: Key("budget_${budget.id}"),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.red[400], borderRadius: BorderRadius.circular(16)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), SizedBox(width: 8), Icon(Icons.delete_outline, color: Colors.white)]),
      ),
      confirmDismiss: (_) => confirmDelete(),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onLongPress: onLongPress,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green.withOpacity(0.05) : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.green : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
              width: isSelected ? 2 : 1
            ),
            boxShadow: [if (!isSelected) BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
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
                          color: isSelected ? Colors.green : (isDark ? Colors.grey[800] : Colors.grey[100]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: isSelected 
                            ? const Icon(Icons.check, size: 18, color: Colors.white)
                            : CategoryStyleHelper.getTagIcon(budget.category, size: 22, emoji: tag?.emoji),
                      );
                    }
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(budget.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)))
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("$currency${spent.toStringAsFixed(0)} spent", style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13)),
                            Text("Limit: $currency${budget.limit.toStringAsFixed(0)}", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Stack(children: [
                Container(height: 8, decoration: BoxDecoration(color: isDark ? Colors.grey[800] : Colors.grey[200], borderRadius: BorderRadius.circular(4))),
                FractionallySizedBox(widthFactor: progress, child: Container(height: 8, decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: statusColor.withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 2))])))
              ])
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final int x;
  final double amount;
  final String label;
  ChartData(this.x, this.amount, this.label);
}