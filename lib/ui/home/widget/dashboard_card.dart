import 'package:bill_buddy/ui/home/viewmodel/home_view_model.dart';
import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DashboardCard extends StatelessWidget {
  final HomeViewModel viewModel;

  const DashboardCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
    
    // ✅ Dynamic Colors
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final subTextColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      height: 220,
      decoration: BoxDecoration(
        color: cardColor, // ✅ Dynamic Background
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.15), // Softer shadow
            blurRadius: 20, 
            offset: const Offset(0, 10)
          ),
        ],
      ),
      child: Row(
        children: [
          // LEFT: Pie Chart
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 50,
                    sections: _buildChartSections(context), // Pass context for dynamic colors
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Total", style: TextStyle(color: subTextColor, fontSize: 10)),
                    Text(
                      "$currency${viewModel.totalSpend.toStringAsFixed(0)}", 
                      style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14) // ✅ Dynamic Text
                    ),
                  ],
                )
              ],
            ),
          ),
          
          const SizedBox(width: 20),

          // RIGHT: Stats
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatRow("This Month", viewModel.monthlySpend, Colors.blueAccent, currency, textColor),
                const SizedBox(height: 12),
                _buildStatRow("This Week", viewModel.weeklySpend, Colors.orangeAccent, currency, textColor),
                const SizedBox(height: 12),
                _buildStatRow("Today", viewModel.todaySpend, Colors.greenAccent, currency, textColor),
                const SizedBox(height: 12),
                Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Avg.", style: TextStyle(color: subTextColor, fontSize: 12)),
                    Text("$currency${viewModel.averageSpend.toStringAsFixed(0)}", style: TextStyle(color: textColor.withOpacity(0.8), fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, double amount, Color dotColor, String currency, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12)),
          ],
        ),
        Text("$currency${amount.toStringAsFixed(0)}", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  List<PieChartSectionData> _buildChartSections(BuildContext context) {
    if (viewModel.categoryData.isEmpty) {
      // ✅ Dynamic "Empty" color
      return [PieChartSectionData(color: Theme.of(context).disabledColor.withOpacity(0.1), value: 1, radius: 15, showTitle: false)];
    }
    List<Color> colors = [
      Theme.of(context).primaryColor, 
      Colors.blueAccent, 
      Colors.orangeAccent, 
      Colors.greenAccent, 
      Colors.purpleAccent
    ];
    int index = 0;
    return viewModel.categoryData.entries.map((entry) {
      final color = colors[index % colors.length];
      index++;
      return PieChartSectionData(color: color, value: entry.value, title: "", radius: 18);
    }).toList();
  }
}