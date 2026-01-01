// import 'package:bill_buddy/ui/home/viewmodel/home_view_model.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';


// class DashboardCard extends StatelessWidget {
//   final HomeViewModel viewModel;

//   const DashboardCard({super.key, required this.viewModel});

//   final Color _primaryColor = const Color(0xFF6C63FF);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(20),
//       padding: const EdgeInsets.all(20),
//       height: 220,
//       decoration: BoxDecoration(
//         color: const Color(0xFF2A2D3E), // Dark card for contrast
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(color: _primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
//         ],
//       ),
//       child: Row(
//         children: [
//           // LEFT: CYCLE GRAPH (Pie Chart)
//           Expanded(
//             flex: 4,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 PieChart(
//                   PieChartData(
//                     sectionsSpace: 0,
//                     centerSpaceRadius: 35,
//                     sections: _buildChartSections(),
//                   ),
//                 ),
//                 // Center Text inside the ring
//                  Column(
//                    mainAxisSize: MainAxisSize.min,
//                    children: [
//                      const Text("Total", style: TextStyle(color: Colors.white54, fontSize: 10)),
//                      Text(
//                        "\$${viewModel.totalSpend.toStringAsFixed(0)}", 
//                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
//                      ),
//                    ],
//                  )
//               ],
//             ),
//           ),
          
//           const SizedBox(width: 20),

//           // RIGHT: DETAILS STATS
//           Expanded(
//             flex: 5,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildStatRow("This Month", viewModel.monthlySpend, Colors.blueAccent),
//                 const SizedBox(height: 12),
//                 _buildStatRow("This Week", viewModel.weeklySpend, Colors.orangeAccent),
//                 const SizedBox(height: 12),
//                 _buildStatRow("Today", viewModel.todaySpend, Colors.greenAccent),
//                 const SizedBox(height: 12),
//                 Divider(color: Colors.white.withOpacity(0.1), height: 1),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text("Avg. Spend", style: TextStyle(color: Colors.white54, fontSize: 12)),
//                     Text("\$${viewModel.averageSpend.toStringAsFixed(1)}", style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper to build rows text
//   Widget _buildStatRow(String label, double amount, Color color) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
//             const SizedBox(width: 8),
//             Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
//           ],
//         ),
//         Text("\$${amount.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
//       ],
//     );
//   }

//   // Helper to build Chart Sections from ViewModel Data
//   List<PieChartSectionData> _buildChartSections() {
//     if (viewModel.categoryData.isEmpty) {
//       // Placeholder if empty
//       return [PieChartSectionData(color: Colors.white10, value: 1, radius: 15, showTitle: false)];
//     }

//     // Colors for different slices
//     List<Color> colors = [const Color(0xFF6C63FF), Colors.blueAccent, Colors.orangeAccent, Colors.greenAccent, Colors.purpleAccent];
    
//     int index = 0;
//     return viewModel.categoryData.entries.map((entry) {
//       final color = colors[index % colors.length];
//       index++;
//       return PieChartSectionData(
//         color: color,
//         value: entry.value,
//         title: "", // Hide title on chart for cleaner look
//         radius: 18,
//       );
//     }).toList();
//   }
// }
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
    // ✅ Get Currency Symbol
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          // LEFT: Pie Chart
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 35,
                    sections: _buildChartSections(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Total", style: TextStyle(color: Colors.white54, fontSize: 10)),
                    // ✅ Dynamic Currency
                    Text(
                      "$currency${viewModel.totalSpend.toStringAsFixed(0)}", 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
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
                _buildStatRow("This Month", viewModel.monthlySpend, Colors.blueAccent, currency),
                const SizedBox(height: 12),
                _buildStatRow("This Week", viewModel.weeklySpend, Colors.orangeAccent, currency),
                const SizedBox(height: 12),
                _buildStatRow("Today", viewModel.todaySpend, Colors.greenAccent, currency),
                const SizedBox(height: 12),
                Divider(color: Colors.white.withOpacity(0.1), height: 1),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Avg.", style: TextStyle(color: Colors.white54, fontSize: 12)),
                    Text("$currency${viewModel.averageSpend.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, double amount, Color color, String currency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        // ✅ Dynamic Currency
        Text("$currency${amount.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  List<PieChartSectionData> _buildChartSections() {
    if (viewModel.categoryData.isEmpty) {
      return [PieChartSectionData(color: Colors.white10, value: 1, radius: 15, showTitle: false)];
    }
    List<Color> colors = [const Color(0xFF6C63FF), Colors.blueAccent, Colors.orangeAccent, Colors.greenAccent, Colors.purpleAccent];
    int index = 0;
    return viewModel.categoryData.entries.map((entry) {
      final color = colors[index % colors.length];
      index++;
      return PieChartSectionData(color: color, value: entry.value, title: "", radius: 18);
    }).toList();
  }
}