
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

//     return Container(
//       margin: const EdgeInsets.all(10),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(28),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 24, 
//             offset: const Offset(0, 8)
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // --------------------------------------------
//           // 1. HEADER (Navigation + All Time Toggle)
//           // --------------------------------------------
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Left: Month Navigation (Hidden if All Time)
//               if (!isAllTime)
//                 IconButton(
//                   icon: Icon(Icons.chevron_left_rounded, color: subTextColor),
//                   onPressed: () {
//                     widget.onDateChanged(DateTime(
//                       widget.selectedDate!.year, 
//                       widget.selectedDate!.month - 1, 
//                       1
//                     ));
//                   },
//                 )
//               else 
//                 const SizedBox(width: 48), // Spacer to keep title centered

//               // Center: Title
//               Column(
//                 children: [
//                   Text(
//                     periodLabel,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold, 
//                       fontSize: 16, 
//                       color: textColor
//                     ),
//                   ),
//                   // New "All Time" Toggle Switch
//                   InkWell(
//                     onTap: () {
//                       if (isAllTime) {
//                         // Switch TO Month View (Current Month)
//                         widget.onDateChanged(DateTime.now());
//                       } else {
//                         // Switch TO All Time
//                         widget.onDateChanged(null);
//                       }
//                     },
//                     borderRadius: BorderRadius.circular(12),
//                     child: Container(
//                       margin: const EdgeInsets.only(top: 4),
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: isAllTime ? Colors.purple.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: isAllTime ? Colors.purple.withOpacity(0.3) : Colors.transparent
//                         )
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             isAllTime ? Icons.check_circle_rounded : Icons.circle_outlined,
//                             size: 12,
//                             color: isAllTime ? Colors.purple : subTextColor,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             "All Time",
//                             style: TextStyle(
//                               fontSize: 10, 
//                               fontWeight: FontWeight.bold,
//                               color: isAllTime ? Colors.purple : subTextColor
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               // Right: Month Navigation (Hidden if All Time or Current Month)
//               if (!isAllTime)
//                 IconButton(
//                   icon: Icon(
//                     Icons.chevron_right_rounded, 
//                     color: _isCurrentMonth(widget.selectedDate) ? Colors.transparent : subTextColor
//                   ),
//                   onPressed: _isCurrentMonth(widget.selectedDate) ? null : () {
//                     widget.onDateChanged(DateTime(
//                       widget.selectedDate!.year, 
//                       widget.selectedDate!.month + 1, 
//                       1
//                     ));
//                   },
//                 )
//               else 
//                 const SizedBox(width: 48), // Spacer
//             ],
//           ),
          
//           const SizedBox(height: 14),

//           // --------------------------------------------
//           // 2. TOTAL SPENDING DISPLAY
//           // --------------------------------------------
//           Center(
//             child: Column(
//               children: [
//                 Text(
//                   isAllTime ? "Lifetime Total" : "Total Spent", 
//                   style: TextStyle(
//                     color: subTextColor, 
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500
//                   )
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   "$currency${widget.viewModel.totalSpend.toStringAsFixed(0)}", 
//                   style: TextStyle(
//                     color: textColor, 
//                     fontWeight: FontWeight.w900, 
//                     fontSize: 40, 
//                     letterSpacing: -1.5
//                   )
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 12),

//           // --------------------------------------------
//           // 3. CHART AND STATS ROW
//           // --------------------------------------------
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Chart Area
//               Expanded(
//                 flex: 6,
//                 child: SizedBox(
//                   height: 100,
//                   child: widget.viewModel.categoryData.isEmpty
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.pie_chart_outline, size: 28, color: Colors.grey.withOpacity(0.3)),
//                               const SizedBox(height: 8),
//                               Text("No data", style: TextStyle(color: subTextColor, fontSize: 12)),
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
//                             sectionsSpace: 1, 
//                             centerSpaceRadius: 50,
//                             sections: _buildAnimatedChartSections(context),
//                           ),
//                         ),
//                 ),
//               ),
              
//               const SizedBox(width: 24),

//               // Stats Area
//               Expanded(
//                 flex: 5,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (isAllTime) ...[
//                       // All Time Stats
//                       _buildStatRow("Peak Month", widget.viewModel.highestSpendMonth, Colors.orangeAccent, textColor),
//                       const SizedBox(height: 14),
//                       _buildStatRow("Peak Amt", "$currency${widget.viewModel.highestSpendAmount.toStringAsFixed(0)}", Colors.redAccent, textColor),
//                       const SizedBox(height: 14),
//                       _buildStatRow("Daily Avg", "$currency${widget.viewModel.dailyAverage.toStringAsFixed(0)}", Colors.blueAccent, textColor),
//                     ] else ...[
//                       // Monthly Stats
//                       _buildStatRow("Weekly Avg", "$currency${widget.viewModel.weeklySpend.toStringAsFixed(0)}", Colors.blueAccent, textColor),
//                       const SizedBox(height: 14),
//                       _buildStatRow("Daily Avg", "$currency${widget.viewModel.dailyAverage.toStringAsFixed(0)}", Colors.greenAccent, textColor),
//                     ]
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 28),
//           Divider(color: Colors.grey.withOpacity(0.12), thickness: 1),
//           const SizedBox(height: 20),

//           // --------------------------------------------
//           // 4. CATEGORY BREAKDOWN LEGEND
//           // --------------------------------------------
//           Text(
//             "Category Breakdown", 
//             style: TextStyle(fontSize: 13, color: subTextColor, fontWeight: FontWeight.bold)
//           ),
//           const SizedBox(height: 16),
          
//           if (widget.viewModel.categoryData.isEmpty)
//             Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text("No categories to display", style: TextStyle(color: subTextColor, fontSize: 12))))
//           else
//             Wrap(
//               spacing: 12,
//               runSpacing: 14,
//               children: _buildLegendItems(context),
//             ),
//         ],
//       ),
//     );
//   }

//   // Helper: Build Legend Items
//   List<Widget> _buildLegendItems(BuildContext context) {
//     if (widget.viewModel.categoryData.isEmpty) return [];

//     int index = 0;
//     List<Color> colors = [
//       const Color(0xFF0F766E), Colors.orangeAccent, Colors.blueAccent, Colors.purpleAccent, Colors.redAccent, Colors.teal
//     ];

//     var sortedEntries = widget.viewModel.categoryData.entries.toList()
//       ..sort((a, b) => b.value.compareTo(a.value));

//     return sortedEntries.take(6).map((entry) {
//       final color = colors[index % colors.length];
//       final isTouched = index == touchedIndex;
//       index++;
      
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isTouched ? color.withOpacity(0.4) : Colors.grey.withOpacity(0.1),
//             width: isTouched ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
//             const SizedBox(width: 8),
//             CategoryStyleHelper.getTagIcon(entry.key, size: 14),
//             const SizedBox(width: 6),
//             Text(
//               entry.key, 
//               style: TextStyle(fontSize: 12, fontWeight: isTouched ? FontWeight.bold : FontWeight.w600, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85)),
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
//             Container(width: 7, height: 7, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
//             const SizedBox(width: 8),
//             Text(label, style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.w500)),
//           ],
//         ),
//         Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
//       ],
//     );
//   }

//   // Helper: Animated Chart Sections
//   List<PieChartSectionData> _buildAnimatedChartSections(BuildContext context) {
//     if (widget.viewModel.categoryData.isEmpty) {
//       return [PieChartSectionData(color: Colors.grey.withOpacity(0.1), value: 1, radius: 10, showTitle: false)];
//     }

//     List<Color> colors = [
//       const Color(0xFF0F766E), Colors.orangeAccent, Colors.blueAccent, Colors.purpleAccent, Colors.redAccent, Colors.teal
//     ];
    
//     int index = 0;
    
//     return widget.viewModel.categoryData.entries.map((entry) {
//       final isTouched = index == touchedIndex;
//       final fontSize = isTouched ? 14.0 : 0.0;
//       final radius = isTouched ? 45.0 : 35.0;
//       final color = colors[index % colors.length];
      
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

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final subTextColor = textColor.withOpacity(0.6);
    final isAllTime = widget.selectedDate == null;

    String periodLabel = isAllTime
        ? "All Time" 
        : DateFormat('MMMM yyyy').format(widget.selectedDate!);

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
          // 1. HEADER (Navigation + All Time Toggle)
          // --------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Month Navigation (Hidden if All Time)
              if (!isAllTime)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.chevron_left_rounded, color: subTextColor, size: 24),
                  onPressed: () {
                    widget.onDateChanged(DateTime(
                      widget.selectedDate!.year, 
                      widget.selectedDate!.month - 1, 
                      1
                    ));
                  },
                )
              else 
                const SizedBox(width: 24),

              // Center: Title
              Column(
                children: [
                  Text(
                    periodLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 15, 
                      color: textColor
                    ),
                  ),
                  // All Time Toggle Switch
                  InkWell(
                    onTap: () {
                      if (isAllTime) {
                        widget.onDateChanged(DateTime.now());
                      } else {
                        widget.onDateChanged(null);
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.only(top: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isAllTime ? Color.fromARGB(255, 13, 152, 1).withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isAllTime ? Color.fromARGB(255, 13, 152, 1).withOpacity(0.3) : Colors.transparent
                        )
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isAllTime ? Icons.check_circle_rounded : Icons.circle_outlined,
                            size: 11,
                            color: isAllTime ? Color.fromARGB(255, 13, 152, 1) : subTextColor,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            "All Time",
                            style: TextStyle(
                              fontSize: 9, 
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

              // Right: Month Navigation
              if (!isAllTime)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.chevron_right_rounded, 
                    color: _isCurrentMonth(widget.selectedDate) ? Colors.transparent : subTextColor,
                    size: 24
                  ),
                  onPressed: _isCurrentMonth(widget.selectedDate) ? null : () {
                    widget.onDateChanged(DateTime(
                      widget.selectedDate!.year, 
                      widget.selectedDate!.month + 1, 
                      1
                    ));
                  },
                )
              else 
                const SizedBox(width: 24),
            ],
          ),
          
          const SizedBox(height: 1),

          // --------------------------------------------
          // 2. TOTAL SPENDING DISPLAY
          // --------------------------------------------
          Center(
            child: Column(
              children: [
                Text(
                  isAllTime ? "Lifetime Total" : "Total Spent", 
                  style: TextStyle(
                    color: subTextColor, 
                    fontSize: 12,
                    fontWeight: FontWeight.w500
                  )
                ),
                const SizedBox(height: 1),
                Text(
                  "$currency${widget.viewModel.totalSpend.toStringAsFixed(0)}", 
                  style: TextStyle(
                    color: textColor, 
                    fontWeight: FontWeight.w900, 
                    fontSize: 36, 
                    letterSpacing: -1.5
                  )
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // --------------------------------------------
          // 3. CHART AND STATS ROW
          // --------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Chart Area
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 100,
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
                            centerSpaceRadius: 42,
                            sections: _buildAnimatedChartSections(context),
                          ),
                        ),
                ),
              ),
              
              const SizedBox(width: 56),

              // Stats Area
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isAllTime) ...[
                      _buildStatRow("Peak Month", widget.viewModel.highestSpendMonth, Colors.orangeAccent, textColor),
                      const SizedBox(height: 10),
                      _buildStatRow("Peak Amt", "$currency${widget.viewModel.highestSpendAmount.toStringAsFixed(0)}", Colors.redAccent, textColor),
                      const SizedBox(height: 10),
                      _buildStatRow("Daily Avg", "$currency${widget.viewModel.dailyAverage.toStringAsFixed(0)}", Colors.blueAccent, textColor),
                    ] else ...[
                      _buildStatRow("Weekly Avg", "$currency${widget.viewModel.weeklySpend.toStringAsFixed(0)}", Colors.blueAccent, textColor),
                      const SizedBox(height: 10),
                      _buildStatRow("Daily Avg", "$currency${widget.viewModel.dailyAverage.toStringAsFixed(0)}", Colors.greenAccent, textColor),
                    ]
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Divider(color: Colors.grey.withOpacity(0.12), thickness: 1),
          const SizedBox(height: 14),

          // --------------------------------------------
          // 4. CATEGORY BREAKDOWN LEGEND
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
              runSpacing: 4,
              children: _buildLegendItems(context),
            ),
        ],
      ),
    );
  }

  // Helper: Build Legend Items
  List<Widget> _buildLegendItems(BuildContext context) {
    if (widget.viewModel.categoryData.isEmpty) return [];

    int index = 0;
    List<Color> colors = [
      const Color(0xFF0F766E), Colors.orangeAccent, Colors.blueAccent, Colors.purpleAccent, Colors.redAccent, Colors.teal
    ];

    var sortedEntries = widget.viewModel.categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.take(6).map((entry) {
      final color = colors[index % colors.length];
      final isTouched = index == touchedIndex;
      index++;
      
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
            Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            CategoryStyleHelper.getTagIcon(entry.key, size: 13),
            const SizedBox(width: 5),
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

  // Helper: Stat Row
  Widget _buildStatRow(String label, String value, Color dotColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 10.5, fontWeight: FontWeight.w500)),
          ],
        ),
        Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11.5)),
      ],
    );
  }

  // Helper: Animated Chart Sections
  List<PieChartSectionData> _buildAnimatedChartSections(BuildContext context) {
    if (widget.viewModel.categoryData.isEmpty) {
      return [PieChartSectionData(color: Colors.grey.withOpacity(0.1), value: 1, radius: 10, showTitle: false)];
    }

    List<Color> colors = [
      const Color(0xFF0F766E), Colors.orangeAccent, Colors.blueAccent, Colors.purpleAccent, Colors.redAccent, Colors.teal
    ];
    
    int index = 0;
    
    return widget.viewModel.categoryData.entries.map((entry) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 13.0 : 0.0;
      final radius = isTouched ? 42.0 : 32.0;
      final color = colors[index % colors.length];
      
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