// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../../../data/local/database.dart';
// // import '../../settings/view_model/setting_view_model.dart';

// // class BudgetAlerts extends StatefulWidget {
// //   final List<Expense> allExpenses;

// //   const BudgetAlerts({super.key, required this.allExpenses});

// //   @override
// //   State<BudgetAlerts> createState() => _BudgetAlertsState();
// // }

// // class _BudgetAlertsState extends State<BudgetAlerts> {
// //   final Set<String> _dismissedWarnings = {};

// //   @override
// //   Widget build(BuildContext context) {
// //     return StreamBuilder<List<Budget>>(
// //       stream: database.watchAllBudgets(),
// //       builder: (context, snapshot) {
// //         if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox();

// //         final budgets = snapshot.data!;
// //         final now = DateTime.now();
// //         final currency = Provider.of<SettingsViewModel>(context).currencySymbol;

// //         List<Widget> activeAlerts = [];

// //         for (var budget in budgets) {
// //           if (_dismissedWarnings.contains(budget.category)) continue;

// //           final spent = widget.allExpenses
// //               .where((e) =>
// //                   e.category == budget.category &&
// //                   e.date.month == now.month &&
// //                   e.date.year == now.year)
// //               .fold(0.0, (sum, item) => sum + item.amount);

// //           double percentage = (spent / budget.limit);

// //           if (percentage >= 0.7) { // 70% or more
// //             bool isCritical = percentage >= 1.0;
            
// //             activeAlerts.add(
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// //                 child: Material(
// //                   elevation: 2,
// //                   borderRadius: BorderRadius.circular(12),
// //                   color: isCritical ? Colors.red.shade50 : Colors.orange.shade50,
// //                   child: ListTile(
// //                     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// //                     leading: CircleAvatar(
// //                       backgroundColor: isCritical ? Colors.redAccent : Colors.orange,
// //                       radius: 18,
// //                       child: Icon(
// //                         isCritical ? Icons.priority_high_rounded : Icons.warning_amber_rounded,
// //                         color: Colors.white,
// //                         size: 20,
// //                       ),
// //                     ),
// //                     title: Text(
// //                       isCritical ? "Budget Exceeded: ${budget.category}" : "Approaching Limit: ${budget.category}",
// //                       style: TextStyle(
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 14,
// //                         color: Colors.black87,
// //                       ),
// //                     ),
// //                     subtitle: Text(
// //                       "$currency${spent.toStringAsFixed(0)} used of $currency${budget.limit.toStringAsFixed(0)}",
// //                       style: TextStyle(fontSize: 12, color: Colors.grey[700]),
// //                     ),
// //                     trailing: IconButton(
// //                       icon: const Icon(Icons.close, size: 18, color: Colors.grey),
// //                       onPressed: () {
// //                         setState(() {
// //                           _dismissedWarnings.add(budget.category);
// //                         });
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             );
// //           }
// //         }

// //         if (activeAlerts.isEmpty) return const SizedBox();

// //         return Column(children: activeAlerts);
// //       },
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../data/local/database.dart';
// import '../../settings/view_model/setting_view_model.dart';

// class BudgetAlerts extends StatefulWidget {
//   final List<Expense> allExpenses;

//   const BudgetAlerts({super.key, required this.allExpenses});

//   @override
//   State<BudgetAlerts> createState() => _BudgetAlertsState();
// }

// class _BudgetAlertsState extends State<BudgetAlerts> {
//   // ✅ STATIC: Persists until app is killed/restarted
//   static final Set<String> _sessionDismissedWarnings = {};

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
    
//     // Theme Colors
//     final cardColor = isDark ? Colors.white : const Color(0xFF222222);
//     final textColor = isDark ? Colors.black : Colors.white;
//     final subTextColor = isDark ? Colors.grey[700] : Colors.grey[400];

//     return StreamBuilder<List<Budget>>(
//       stream: database.watchAllBudgets(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox();

//         final budgets = snapshot.data!;
//         final now = DateTime.now();
//         final currency = Provider.of<SettingsViewModel>(context).currencySymbol;

//         List<BudgetAlertItem> activeAlerts = [];

//         for (var budget in budgets) {
//           // ✅ Check against the static session set
//           if (_sessionDismissedWarnings.contains(budget.category)) continue;

//           final spent = widget.allExpenses
//               .where((e) =>
//                   e.category == budget.category &&
//                   e.date.month == now.month &&
//                   e.date.year == now.year)
//               .fold(0.0, (sum, item) => sum + item.amount);

//           double percentage = (spent / budget.limit);

//           if (percentage >= 0.7) {
//             bool isCritical = percentage >= 1.0;
//             activeAlerts.add(BudgetAlertItem(
//               budget: budget,
//               spent: spent,
//               isCritical: isCritical,
//             ));
//           }
//         }

//         if (activeAlerts.isEmpty) return const SizedBox();

//         // 3. FLOATING STACK UI
//         return Container(
//           height: 100, // ✅ Increased height to fit "Clear All"
//           margin: const EdgeInsets.symmetric(horizontal: 20),
//           child: Stack(
//             alignment: Alignment.topCenter,
//             children: [
              
//               // --- 1. BACKGROUND CARD (Shadow Effect) ---
//               if (activeAlerts.length > 1)
//                 Positioned(
//                   top: 35, // Pushed down
//                   left: 0, 
//                   right: 0,
//                   child: Transform.scale(
//                     scale: 0.92,
//                     child: Container(
//                       height: 60,
//                       decoration: BoxDecoration(
//                         color: cardColor.withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//                 ),

//               // --- 2. FOREGROUND CARD (The Main Notification) ---
//               Positioned(
//                 top: 25, // Leave space at top for "Clear All"
//                 left: 0,
//                 right: 0,
//                 child: Dismissible(
//                   key: ValueKey(activeAlerts.first.budget.category),
//                   direction: DismissDirection.horizontal, // Slide to delete
//                   onDismissed: (_) {
//                     setState(() {
//                       _sessionDismissedWarnings.add(activeAlerts.first.budget.category);
//                     });
//                   },
//                   child: Container(
//                     height: 65,
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: cardColor,
//                       borderRadius: BorderRadius.circular(35),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 12,
//                           offset: const Offset(0, 6),
//                         )
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         // Icon
//                         Icon(
//                           activeAlerts.first.isCritical ? Icons.error_rounded : Icons.warning_rounded,
//                           color: activeAlerts.first.isCritical ? Colors.redAccent : Colors.orangeAccent,
//                           size: 24,
//                         ),
//                         const SizedBox(width: 14),
                        
//                         // Text
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "${activeAlerts.first.budget.category}: ${activeAlerts.first.isCritical ? 'Over Budget!' : 'Near Limit'}",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 13,
//                                   color: textColor,
//                                 ),
//                               ),
//                               Text(
//                                 "$currency${activeAlerts.first.spent.toStringAsFixed(0)} / $currency${activeAlerts.first.budget.limit.toStringAsFixed(0)}",
//                                 style: TextStyle(fontSize: 11, color: subTextColor),
//                               ),
//                             ],
//                           ),
//                         ),
                        
//                         // Chevron (Hint to swipe)
//                         Icon(Icons.chevron_right_rounded, color: subTextColor?.withOpacity(0.5), size: 18),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               // --- 3. CLEAR ALL BUTTON (Rendered LAST = On Top) ---
//               if (activeAlerts.length > 1)
//                 Positioned(
//                   top: 0,
//                   right: 10,
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         for (var item in activeAlerts) {
//                           _sessionDismissedWarnings.add(item.budget.category);
//                         }
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: isDark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.9),
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2))
//                         ]
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             "Clear All",
//                             style: TextStyle(
//                               fontSize: 11, 
//                               fontWeight: FontWeight.bold, 
//                               color: isDark ? Colors.white : Colors.black87
//                             ),
//                           ),
//                           const SizedBox(width: 4),
//                           Icon(Icons.clear_all_rounded, size: 14, color: isDark ? Colors.white : Colors.black87),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class BudgetAlertItem {
//   final Budget budget;
//   final double spent;
//   final bool isCritical;

//   BudgetAlertItem({required this.budget, required this.spent, required this.isCritical});
// }
import 'package:bill_buddy/ui/budget/screen/budget_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/local/database.dart';
import '../../settings/view_model/setting_view_model.dart';


class BudgetAlerts extends StatefulWidget {
  final List<Expense> allExpenses;

  const BudgetAlerts({super.key, required this.allExpenses});

  @override
  State<BudgetAlerts> createState() => _BudgetAlertsState();
}

class _BudgetAlertsState extends State<BudgetAlerts> {
  static final Set<String> _sessionDismissedWarnings = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme Colors
    final cardColor = isDark ? Colors.white : const Color(0xFF222222);
    final textColor = isDark ? Colors.black : Colors.white;
    final subTextColor = isDark ? Colors.grey[700] : Colors.grey[400];

    return StreamBuilder<List<Budget>>(
      stream: database.watchAllBudgets(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox();

        final budgets = snapshot.data!;
        final now = DateTime.now();
        final currency = Provider.of<SettingsViewModel>(context).currencySymbol;

        List<BudgetAlertItem> activeAlerts = [];

        for (var budget in budgets) {
          if (_sessionDismissedWarnings.contains(budget.category)) continue;

          final spent = widget.allExpenses
              .where((e) =>
                  e.category == budget.category &&
                  e.date.month == now.month &&
                  e.date.year == now.year)
              .fold(0.0, (sum, item) => sum + item.amount);

          double percentage = (spent / budget.limit);

          if (percentage >= 0.7) {
            bool isCritical = percentage >= 1.0;
            activeAlerts.add(BudgetAlertItem(
              budget: budget,
              spent: spent,
              isCritical: isCritical,
            ));
          }
        }

        if (activeAlerts.isEmpty) return const SizedBox();

        // 3. FLOATING STACK UI
        return Container(
          height: 100, 
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              
              // --- 1. BACKGROUND CARD ---
              if (activeAlerts.length > 1)
                Positioned(
                  top: 35,
                  left: 0, 
                  right: 0,
                  child: Transform.scale(
                    scale: 0.92,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: cardColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),

              // --- 2. FOREGROUND CARD (The Main Notification) ---
              Positioned(
                top: 25, 
                left: 0,
                right: 0,
                child: Dismissible(
                  key: ValueKey(activeAlerts.first.budget.category),
                  direction: DismissDirection.horizontal,
                  onDismissed: (_) {
                    setState(() {
                      _sessionDismissedWarnings.add(activeAlerts.first.budget.category);
                    });
                  },
                  // ✅ WRAPPED IN GESTURE DETECTOR
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to Budget Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BudgetScreen()),
                      );
                    },
                    child: Container(
                      height: 65,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          // Icon
                          Icon(
                            activeAlerts.first.isCritical ? Icons.error_rounded : Icons.warning_rounded,
                            color: activeAlerts.first.isCritical ? Colors.redAccent : Colors.orangeAccent,
                            size: 24,
                          ),
                          const SizedBox(width: 14),
                          
                          // Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${activeAlerts.first.budget.category}: ${activeAlerts.first.isCritical ? 'Over Budget!' : 'Near Limit'}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  "$currency${activeAlerts.first.spent.toStringAsFixed(0)} / $currency${activeAlerts.first.budget.limit.toStringAsFixed(0)}",
                                  style: TextStyle(fontSize: 11, color: subTextColor),
                                ),
                              ],
                            ),
                          ),
                          
                          // Chevron
                          Icon(Icons.chevron_right_rounded, color: subTextColor?.withOpacity(0.5), size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // --- 3. CLEAR ALL BUTTON ---
              if (activeAlerts.length > 1)
                Positioned(
                  top: 0,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        for (var item in activeAlerts) {
                          _sessionDismissedWarnings.add(item.budget.category);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2))
                        ]
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Clear All",
                            style: TextStyle(
                              fontSize: 11, 
                              fontWeight: FontWeight.bold, 
                              color: isDark ? Colors.white : Colors.black87
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.clear_all_rounded, size: 14, color: isDark ? Colors.white : Colors.black87),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class BudgetAlertItem {
  final Budget budget;
  final double spent;
  final bool isCritical;

  BudgetAlertItem({required this.budget, required this.spent, required this.isCritical});
}