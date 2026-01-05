// import 'package:bill_buddy/ui/home/viewmodel/home_view_model.dart';
// import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
// import 'package:bill_buddy/util/category_style_helper.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class DashboardCard extends StatefulWidget {
//   final HomeViewModel viewModel;
//   final DateTime? selectedDate; // Null = All Time
//   final Function(DateTime?) onDateChanged;

//   const DashboardCard({
//     super.key, 
//     required this.viewModel,
//     required this.selectedDate,
//     required this.onDateChanged,
//   });

//   @override
//   State<DashboardCard> createState() => _DashboardCardState();
// }

// class _DashboardCardState extends State<DashboardCard> {
//   int touchedIndex = -1;

//   // ✅ 1. Define colors once to ensure consistency
//   final List<Color> _chartColors = const [
//     Color(0xFF0F766E), // Deep Teal
//     Colors.orangeAccent, 
//     Colors.blueAccent, 
//     Colors.purpleAccent, 
//     Colors.redAccent, 
//     Colors.teal,
//     Colors.pinkAccent,
//     Colors.amber,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
//     final cardColor = Theme.of(context).cardColor;
//     final textColor = Theme.of(context).colorScheme.onSurface;
//     final subTextColor = textColor.withOpacity(0.6);
//     final isAllTime = widget.selectedDate == null;

//     String periodLabel = isAllTime
//         ? "All Time" 
//         : DateFormat('MMMM yyyy').format(widget.selectedDate!);

//     // ✅ 2. PREPARE SORTED DATA HERE
//     // We sort the data once, so both Chart and Legend use the exact same order.
//     var sortedEntries = widget.viewModel.categoryData.entries.toList()
//       ..sort((a, b) => b.value.compareTo(a.value));

//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 20, 
//             offset: const Offset(0, 6)
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // --------------------------------------------
//           // HEADER (Navigation + All Time Toggle)
//           // --------------------------------------------
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               if (!isAllTime)
//                 IconButton(
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                   icon: Icon(Icons.chevron_left_rounded, color: subTextColor, size: 24),
//                   onPressed: () {
//                     if (widget.selectedDate != null) {
//                       widget.onDateChanged(DateTime(
//                         widget.selectedDate!.year, 
//                         widget.selectedDate!.month - 1, 
//                         1
//                       ));
//                     }
//                   },
//                 )
//               else 
//                 const SizedBox(width: 24),

//               Column(
//                 children: [
//                   Text(
//                     periodLabel,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold, 
//                       fontSize: 15, 
//                       color: textColor
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       if (isAllTime) {
//                         widget.onDateChanged(DateTime.now());
//                       } else {
//                         widget.onDateChanged(null);
//                       }
//                     },
//                     borderRadius: BorderRadius.circular(10),
//                     child: Container(
//                       margin: const EdgeInsets.only(top: 3),
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: isAllTime ? const Color.fromARGB(255, 13, 152, 1).withOpacity(0.1) : Colors.grey.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: isAllTime ? const Color.fromARGB(255, 13, 152, 1).withOpacity(0.3) : Colors.transparent
//                         )
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             isAllTime ? Icons.check_circle_rounded : Icons.circle_outlined,
//                             size: 11,
//                             color: isAllTime ? const Color.fromARGB(255, 13, 152, 1) : subTextColor,
//                           ),
//                           const SizedBox(width: 3),
//                           Text(
//                             "All Time",
//                             style: TextStyle(
//                               fontSize: 9, 
//                               fontWeight: FontWeight.bold,
//                               color: isAllTime ? const Color.fromARGB(255, 13, 152, 1) : subTextColor
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               if (!isAllTime)
//                 IconButton(
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                   icon: Icon(
//                     Icons.chevron_right_rounded, 
//                     color: _isCurrentMonth(widget.selectedDate) ? Colors.transparent : subTextColor,
//                     size: 24
//                   ),
//                   onPressed: _isCurrentMonth(widget.selectedDate) ? null : () {
//                     if (widget.selectedDate != null) {
//                       widget.onDateChanged(DateTime(
//                         widget.selectedDate!.year, 
//                         widget.selectedDate!.month + 1, 
//                         1
//                       ));
//                     }
//                   },
//                 )
//               else 
//                 const SizedBox(width: 24),
//             ],
//           ),
          
//           const SizedBox(height: 1),

//           // --------------------------------------------
//           // TOTAL SPENDING DISPLAY
//           // --------------------------------------------
//           Center(
//             child: Column(
//               children: [
//                 Text(
//                   isAllTime ? "Lifetime Total" : "Total Spent", 
//                   style: TextStyle(
//                     color: subTextColor, 
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500
//                   )
//                 ),
//                 const SizedBox(height: 1),
//                 Text(
//                   "$currency${widget.viewModel.totalSpend.toStringAsFixed(0)}", 
//                   style: TextStyle(
//                     color: textColor, 
//                     fontWeight: FontWeight.w900, 
//                     fontSize: 36, 
//                     letterSpacing: -1.5
//                   )
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           // --------------------------------------------
//           // CHART AND STATS ROW
//           // --------------------------------------------
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Chart Area
//               Expanded(
//                 flex: 5,
//                 child: SizedBox(
//                   height: 100,
//                   child: widget.viewModel.categoryData.isEmpty
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.pie_chart_outline, size: 40, color: Colors.grey.withOpacity(0.3)),
//                               const SizedBox(height: 6),
//                               Text("No data", style: TextStyle(color: subTextColor, fontSize: 11)),
//                             ],
//                           ),
//                         )
//                       : PieChart(
//                           PieChartData(
//                             pieTouchData: PieTouchData(
//                               touchCallback: (FlTouchEvent event, pieTouchResponse) {
//                                 setState(() {
//                                   if (!event.isInterestedForInteractions ||
//                                       pieTouchResponse == null ||
//                                       pieTouchResponse.touchedSection == null) {
//                                     touchedIndex = -1;
//                                     return;
//                                   }
//                                   touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
//                                 });
//                               },
//                             ),
//                             borderData: FlBorderData(show: false),
//                             sectionsSpace: 4, 
//                             centerSpaceRadius: 42,
//                             // ✅ Pass sorted entries here
//                             sections: _buildAnimatedChartSections(context, sortedEntries), 
//                           ),
//                         ),
//                 ),
//               ),
              
//               const SizedBox(width: 56),

//               // Stats Area
//               Expanded(
//                 flex: 5,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (isAllTime) ...[
//                       _buildStatRow("Peak Month", widget.viewModel.highestSpendMonth, Colors.orangeAccent, textColor),
//                       const SizedBox(height: 10),
//                       _buildStatRow("Peak Amt", "$currency${widget.viewModel.highestSpendAmount.toStringAsFixed(0)}", Colors.redAccent, textColor),
//                       const SizedBox(height: 10),
//                       _buildStatRow("Daily Avg", "$currency${widget.viewModel.dailyAverage.toStringAsFixed(0)}", Colors.blueAccent, textColor),
//                     ] else ...[
//                       _buildStatRow("Weekly Avg", "$currency${widget.viewModel.weeklySpend.toStringAsFixed(0)}", Colors.blueAccent, textColor),
//                       const SizedBox(height: 10),
//                       _buildStatRow("Daily Avg", "$currency${widget.viewModel.dailyAverage.toStringAsFixed(0)}", Colors.greenAccent, textColor),
//                     ]
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 20),
//           Divider(color: Colors.grey.withOpacity(0.12), thickness: 1),
//           const SizedBox(height: 14),

//           // --------------------------------------------
//           // CATEGORY BREAKDOWN LEGEND
//           // --------------------------------------------
//           Text(
//             "Category Breakdown", 
//             style: TextStyle(fontSize: 12, color: subTextColor, fontWeight: FontWeight.bold)
//           ),
//           const SizedBox(height: 10),
          
//           if (widget.viewModel.categoryData.isEmpty)
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4), 
//                 child: Text("No categories to display", style: TextStyle(color: subTextColor, fontSize: 11))
//               )
//             )
//           else
//             Wrap(
//               spacing: 8,
//               runSpacing: 4,
//               // ✅ Pass sorted entries here too
//               children: _buildLegendItems(context, sortedEntries), 
//             ),
//         ],
//       ),
//     );
//   }

//   // ✅ Updated: Accepts sorted entries to match chart colors
//   List<Widget> _buildLegendItems(BuildContext context, List<MapEntry<String, double>> sortedEntries) {
//     int index = 0;

//     return sortedEntries.take(6).map((entry) {
//       final color = _chartColors[index % _chartColors.length];
//       final isTouched = index == touchedIndex;
//       index++;
      
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//         decoration: BoxDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isTouched ? color.withOpacity(0.4) : Colors.grey.withOpacity(0.1),
//             width: isTouched ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
//             const SizedBox(width: 6),
//             CategoryStyleHelper.getTagIcon(entry.key, size: 13),
//             const SizedBox(width: 5),
//             Text(
//               entry.key, 
//               style: TextStyle(
//                 fontSize: 11, 
//                 fontWeight: isTouched ? FontWeight.bold : FontWeight.w600, 
//                 color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85)
//               ),
//             ),
//           ],
//         ),
//       );
//     }).toList();
//   }

//   // Helper: Stat Row
//   Widget _buildStatRow(String label, String value, Color dotColor, Color textColor) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
//             const SizedBox(width: 6),
//             Text(label, style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 10.5, fontWeight: FontWeight.w500)),
//           ],
//         ),
//         Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11.5)),
//       ],
//     );
//   }

//   // ✅ Updated: Accepts sorted entries
//   List<PieChartSectionData> _buildAnimatedChartSections(BuildContext context, List<MapEntry<String, double>> sortedEntries) {
//     if (sortedEntries.isEmpty) {
//       return [PieChartSectionData(color: Colors.grey.withOpacity(0.1), value: 1, radius: 10, showTitle: false)];
//     }

//     int index = 0;
    
//     return sortedEntries.map((entry) {
//       final isTouched = index == touchedIndex;
//       final fontSize = isTouched ? 13.0 : 0.0;
//       final radius = isTouched ? 42.0 : 32.0;
//       final color = _chartColors[index % _chartColors.length];
      
//       final value = entry.value;
//       final total = widget.viewModel.totalSpend;
//       final percentage = total > 0 ? ((value / total) * 100).toStringAsFixed(0) : "0";

//       index++;
      
//       return PieChartSectionData(
//         color: color, 
//         value: entry.value, 
//         title: "$percentage%", 
//         radius: radius,
//         titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
//       );
//     }).toList();
//   }

//   bool _isCurrentMonth(DateTime? date) {
//     if (date == null) return false;
//     final now = DateTime.now();
//     return date.year == now.year && date.month == now.month;
//   }
// }
import 'package:bill_buddy/ui/home/viewmodel/home_view_model.dart';
import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
import 'package:bill_buddy/util/category_style_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardCard extends StatefulWidget {
  final HomeViewModel viewModel;
  final DateTime? selectedDate; // Null = All Time
  final Function(DateTime?) onDateChanged;

  const DashboardCard({
    super.key, 
    required this.viewModel,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  int touchedIndex = -1;

  // 1. Define colors for consistent chart mapping
  final List<Color> _chartColors = const [
    Color(0xFF0F766E), // Deep Teal
    Colors.orangeAccent, 
    Colors.blueAccent, 
    Colors.purpleAccent, 
    Colors.redAccent, 
    Colors.teal,
    Colors.pinkAccent,
    Colors.amber,
  ];

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final subTextColor = textColor.withOpacity(0.6);
    final isAllTime = widget.selectedDate == null;

    // Label for the top-right filter chip
    String periodLabel = isAllTime
        ? "All Time" 
        : DateFormat('MMMM yyyy').format(widget.selectedDate!);

    // 2. Sort data so Chart and Legend match colors
    var sortedEntries = widget.viewModel.categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20, 
            offset: const Offset(0, 6)
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // --------------------------------------------
          // HEADER ROW
          // Left: Navigation Arrows (for months)
          // Right: Filter Chip (All Time / Month Name)
          // --------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Month Navigation (Only show if NOT All Time)
              if (!isAllTime)
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.chevron_left_rounded, color: subTextColor, size: 24),
                      onPressed: () {
                        if (widget.selectedDate != null) {
                          widget.onDateChanged(DateTime(
                            widget.selectedDate!.year, 
                            widget.selectedDate!.month - 1, 
                            1
                          ));
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.chevron_right_rounded, 
                        color: _isCurrentMonth(widget.selectedDate) ? Colors.transparent : subTextColor,
                        size: 24
                      ),
                      onPressed: _isCurrentMonth(widget.selectedDate) ? null : () {
                        if (widget.selectedDate != null) {
                          widget.onDateChanged(DateTime(
                            widget.selectedDate!.year, 
                            widget.selectedDate!.month + 1, 
                            1
                          ));
                        }
                      },
                    ),
                  ],
                )
              else 
                 // Empty spacer if All Time (to keep Right side aligned)
                 const SizedBox(width: 48), 

              // Right: Filter Chip
              InkWell(
                onTap: () {
                  // Toggle Logic: If All Time -> Switch to Now. If Month -> Switch to All Time.
                  if (isAllTime) {
                    widget.onDateChanged(DateTime.now());
                  } else {
                    widget.onDateChanged(null);
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isAllTime ? const Color.fromARGB(255, 13, 152, 1).withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isAllTime ? const Color.fromARGB(255, 13, 152, 1).withOpacity(0.3) : Colors.transparent
                    )
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAllTime ? Icons.check_circle_rounded : Icons.calendar_month,
                        size: 14,
                        color: isAllTime ? const Color.fromARGB(255, 13, 152, 1) : subTextColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        periodLabel,
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.bold,
                          color: isAllTime ? const Color.fromARGB(255, 13, 152, 1) : subTextColor
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),

          // --------------------------------------------
          // MAIN CONTENT ROW
          // Left: Chart | Right: Stats
          // --------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. LEFT: PIE CHART
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 140, // Increased height for better visibility
                  child: widget.viewModel.categoryData.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.pie_chart_outline, size: 40, color: Colors.grey.withOpacity(0.3)),
                              const SizedBox(height: 6),
                              Text("No data", style: TextStyle(color: subTextColor, fontSize: 11)),
                            ],
                          ),
                        )
                      : PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 4, 
                            centerSpaceRadius: 40, // Donut hole size
                            sections: _buildAnimatedChartSections(context, sortedEntries), 
                          ),
                        ),
                ),
              ),
              
              const SizedBox(width: 20), // Spacing between Chart and Stats

              // 2. RIGHT: STATS COLUMN
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to left
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Total Spent Header
                    Text(
                      isAllTime ? "Lifetime Total" : "Total Spent", 
                      style: TextStyle(
                        color: subTextColor, 
                        fontSize: 12,
                        fontWeight: FontWeight.w500
                      )
                    ),
                    Text(
                      "$currency${widget.viewModel.totalSpend.toStringAsFixed(0)}", 
                      style: TextStyle(
                        color: textColor, 
                        fontWeight: FontWeight.w900, 
                        fontSize: 28, // Large Bold Font
                        letterSpacing: -1.0
                      )
                    ),
                    
                    const SizedBox(height: 16), // Spacing
                    
                    // Detailed Stats
                    if (isAllTime) ...[
                      // All Time Stats
                      _buildStatRowWithIcon(Icons.calendar_today, "Peak Month", widget.viewModel.highestSpendMonth, Colors.orangeAccent, textColor),
                      const SizedBox(height: 8),
                      _buildStatRowWithIcon(Icons.trending_up, "Peak Amt", "$currency${widget.viewModel.highestSpendAmount.toStringAsFixed(0)}", Colors.redAccent, textColor),
                      const SizedBox(height: 8),
                      _buildStatRowWithIcon(Icons.bar_chart, "Daily Avg", "$currency${widget.viewModel.dailyAverage.toStringAsFixed(0)}", Colors.blueAccent, textColor),
                    ] else ...[
                      // Monthly Stats
                      _buildStatRowWithIcon(Icons.date_range, "Weekly Avg", "$currency${widget.viewModel.weeklySpend.toStringAsFixed(0)}", Colors.purpleAccent, textColor),
                      const SizedBox(height: 8),
                      _buildStatRowWithIcon(Icons.today, "Daily Avg", "$currency${widget.viewModel.dailyAverage.toStringAsFixed(0)}", Colors.blueAccent, textColor),
                    ]
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),
          Divider(color: Colors.grey.withOpacity(0.12), thickness: 1),
          const SizedBox(height: 15),

          // --------------------------------------------
          // BOTTOM: CATEGORY BREAKDOWN LEGEND
          // --------------------------------------------
          Text(
            "Category Breakdown", 
            style: TextStyle(fontSize: 12, color: subTextColor, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 10),
          
          if (widget.viewModel.categoryData.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4), 
                child: Text("No categories to display", style: TextStyle(color: subTextColor, fontSize: 11))
              )
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _buildLegendItems(context, sortedEntries), 
            ),
        ],
      ),
    );
  }

  // Helper: Stat Row with Icon (Design from your request image)
  Widget _buildStatRowWithIcon(IconData icon, String label, String value, Color iconColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: iconColor), // Icon instead of dot
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
        Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  // Helper: Build Legend Items
  List<Widget> _buildLegendItems(BuildContext context, List<MapEntry<String, double>> sortedEntries) {
    int index = 0;

    return sortedEntries.take(6).map((entry) {
      final color = _chartColors[index % _chartColors.length];
      final isTouched = index == touchedIndex;
      index++;
      
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isTouched ? color.withOpacity(0.4) : Colors.grey.withOpacity(0.1),
            width: isTouched ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            // Updated to fetch Emoji if available (assuming StyleHelper supports it now)
            CategoryStyleHelper.getTagIcon(entry.key, size: 14), 
            const SizedBox(width: 6),
            Text(
              entry.key, 
              style: TextStyle(
                fontSize: 11, 
                fontWeight: isTouched ? FontWeight.bold : FontWeight.w600, 
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85)
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // Helper: Build Pie Chart Sections
  List<PieChartSectionData> _buildAnimatedChartSections(BuildContext context, List<MapEntry<String, double>> sortedEntries) {
    if (sortedEntries.isEmpty) {
      return [PieChartSectionData(color: Colors.grey.withOpacity(0.1), value: 1, radius: 10, showTitle: false)];
    }

    int index = 0;
    
    return sortedEntries.map((entry) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 14.0 : 0.0; // Hide text if not touched
      final radius = isTouched ? 48.0 : 40.0; // Expand on touch
      final color = _chartColors[index % _chartColors.length];
      
      final value = entry.value;
      final total = widget.viewModel.totalSpend;
      final percentage = total > 0 ? ((value / total) * 100).toStringAsFixed(0) : "0";

      index++;
      
      return PieChartSectionData(
        color: color, 
        value: entry.value, 
        title: "$percentage%", 
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  bool _isCurrentMonth(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }
}