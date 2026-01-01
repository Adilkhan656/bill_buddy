// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../../data/local/database.dart'; // Import your DB file
// import '../../data/auth/auth_service.dart';
// import '../../ui/add_expense/screen/add_expense_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   // Modern Colors
//   final Color _primaryColor = const Color(0xFF6C63FF);
//   final Color _bgColor = const Color(0xFFF5F7FA);

//   @override
//   Widget build(BuildContext context) {
//     // Access Auth via Provider, but Database via global variable
//     final auth = Provider.of<AuthService>(context, listen: false);

//     return Scaffold(
//       backgroundColor: _bgColor,
//       // Custom Modern App Bar
//       appBar: AppBar(
//         backgroundColor: _bgColor,
//         elevation: 0,
//         title: const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("My Expenses", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 22)),
//             Text("Track your bills smart", style: TextStyle(color: Colors.grey, fontSize: 12)),
//           ],
//         ),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 16),
//             decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
//               BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)
//             ]),
//             child: IconButton(
//               icon: const Icon(Icons.logout_rounded, color: Colors.black54),
//               onPressed: () => auth.signOut(),
//             ),
//           ),
//         ],
//       ),
      
//       body: StreamBuilder<List<Expense>>(
//         // ✅ Use the global 'database' variable we created earlier
//         stream: database.watchAllExpenses(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator(color: _primaryColor));
//           }

//           final expenses = snapshot.data ?? [];

//           if (expenses.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.receipt_long_rounded, size: 80, color: Colors.grey[300]),
//                   const SizedBox(height: 16),
//                   Text(
//                     "No expenses yet",
//                     style: TextStyle(color: Colors.grey[600], fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Tap the + button to scan a bill",
//                     style: TextStyle(color: Colors.grey[400], fontSize: 14),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return ListView.separated(
//             padding: const EdgeInsets.all(20),
//             itemCount: expenses.length,
//             separatorBuilder: (context, index) => const SizedBox(height: 16),
//             itemBuilder: (context, index) {
//               final expense = expenses[index];
//               return _buildExpenseCard(context, expense);
//             },
//           );
//         },
//       ),

//       // Modern FAB
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: _primaryColor,
//         elevation: 4,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
//           );
//         },
//         label: const Text("Scan Bill", style: TextStyle(fontWeight: FontWeight.bold)),
//         icon: const Icon(Icons.qr_code_scanner_rounded),
//       ),
//     );
//   }

//   // 🎨 Custom Expense Card Widget
//   Widget _buildExpenseCard(BuildContext context, Expense expense) {
//     return Dismissible(
//       key: Key(expense.id.toString()),
//       direction: DismissDirection.endToStart,
//       onDismissed: (_) {
//         database.deleteExpense(expense.id);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Expense deleted")),
//         );
//       },
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 24),
//         decoration: BoxDecoration(
//           color: Colors.redAccent.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 28),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.06),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // 📸 IMAGE PREVIEW CIRCLE
//             Container(
//               height: 55,
//               width: 55,
//               decoration: BoxDecoration(
//                 color: _primaryColor.withOpacity(0.1),
//                 shape: BoxShape.circle,
//                 image: expense.imagePath != null
//                     ? DecorationImage(
//                         image: FileImage(File(expense.imagePath!)),
//                         fit: BoxFit.cover,
//                       )
//                     : null,
//               ),
//               child: expense.imagePath == null
//                   ? Icon(Icons.receipt_rounded, color: _primaryColor)
//                   : null,
//             ),
            
//             const SizedBox(width: 16),
            
//             // 📝 TEXT INFO
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     expense.merchant,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey[400]),
//                       const SizedBox(width: 4),
//                       Text(
//                         DateFormat('MMM d, y').format(expense.date),
//                         style: TextStyle(color: Colors.grey[500], fontSize: 13),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
            
//             // 💰 AMOUNT
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   "\$${expense.amount.toStringAsFixed(2)}",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     fontSize: 18,
//                     color: _primaryColor,
//                   ),
//                 ),
//                 if (expense.tax > 0)
//                   Text(
//                     "+ \$${expense.tax.toStringAsFixed(2)} tax",
//                     style: TextStyle(color: Colors.grey[400], fontSize: 11),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// }

// import 'dart:io';
// import 'package:bill_buddy/ui/home/viewmodel/home_view_model.dart';
// import 'package:bill_buddy/ui/home/widget/dashboard_card.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../data/local/database.dart';
// import '../../data/auth/auth_service.dart';
// import '../add_expense/screen/add_expense_screen.dart';


// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;
//   final HomeViewModel _viewModel = HomeViewModel(); // Instantiate ViewModel

//   final Color _primaryColor = const Color(0xFF6C63FF);
//   final Color _bgColor = const Color(0xFFF5F7FA);

//   // Pages for Bottom Nav
//   late final List<Widget> _pages;

//   @override
//   void initState() {
//     super.initState();
//     _pages = [
//       _buildHomeTab(),  // Tab 0: Dashboard + List
//       const Center(child: Text("Settings Page (Coming Soon)")), // Tab 2: Settings
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Access Auth via Provider
//     final auth = Provider.of<AuthService>(context, listen: false);

//     return Scaffold(
//       backgroundColor: _bgColor,
      
//       // 1. TOP APP BAR (Only show on Home Tab)
//       appBar: _currentIndex == 0 ? AppBar(
//         backgroundColor: _bgColor,
//         elevation: 0,
//         title: const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Dashboard", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 22)),
//             Text("Overview & Expenses", style: TextStyle(color: Colors.grey, fontSize: 12)),
//           ],
//         ),
//         actions: [
//           IconButton(
//              icon: const Icon(Icons.logout_rounded, color: Colors.black54),
//              onPressed: () => auth.signOut(),
//           )
//         ],
//       ) : null,

//       // 2. BODY CONTENT
//       body: _currentIndex == 1 ? _pages[1] : _buildHomeTab(), // Simple switch

//       // 3. BOTTOM NAVIGATION BAR
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
//           );
//         },
//         backgroundColor: _primaryColor,
//         elevation: 4,
//         child: const Icon(Icons.qr_code_scanner_rounded, size: 30),
//       ),
      
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 10,
//         child: SizedBox(
//           height: 60,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildNavIcon(Icons.home_rounded, 0, "Home"),
//               const SizedBox(width: 40), // Space for FAB
//               _buildNavIcon(Icons.settings_rounded, 1, "Settings"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavIcon(IconData icon, int index, String label) {
//     final isSelected = _currentIndex == index;
//     return InkWell(
//       onTap: () => setState(() => _currentIndex = index),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon, 
//             color: isSelected ? _primaryColor : Colors.grey,
//             size: 26,
//           ),
//           Text(
//             label, 
//             style: TextStyle(
//               color: isSelected ? _primaryColor : Colors.grey, 
//               fontSize: 10, 
//               fontWeight: FontWeight.w600
//             )
//           )
//         ],
//       ),
//     );
//   }

//   // 🏠 HOME TAB CONTENT (Dashboard + List)
//   Widget _buildHomeTab() {
//     return StreamBuilder<List<Expense>>(
//       stream: database.watchAllExpenses(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator(color: _primaryColor));
//         }

//         final expenses = snapshot.data ?? [];
        
//         // 🧠 MVVM: Pass data to ViewModel to calculate stats
//         _viewModel.calculateStats(expenses);

//         return CustomScrollView(
//           slivers: [
//             // A. DASHBOARD CARD (Non-scrollable header)
//             SliverToBoxAdapter(
//               child: DashboardCard(viewModel: _viewModel), // 
//             ),

//             // B. TITLE FOR LIST
//             const SliverToBoxAdapter(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: Text("Recent Transactions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               ),
//             ),

//             // C. EXPENSE LIST
//             expenses.isEmpty 
//             ? const SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 50),
//                   child: Center(child: Text("No transactions yet")),
//                 ),
//               )
//             : SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (context, index) {
//                     final expense = expenses[index];
//                     return _buildExpenseRow(context, expense);
//                   },
//                   childCount: expenses.length,
//                 ),
//               ),
              
//             const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom padding
//           ],
//         );
//       },
//     );
//   }

//   // 🎨 Expense Row Item (Same as before but compact)
//   Widget _buildExpenseRow(BuildContext context, Expense expense) {
//     return Dismissible(
//       key: Key(expense.id.toString()),
//       direction: DismissDirection.endToStart,
//       onDismissed: (_) => database.deleteExpense(expense.id),
//       background: Container(color: Colors.redAccent, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)],
//         ),
//         child: Row(
//           children: [
//             // Image / Icon
//             Container(
//               height: 45, width: 45,
//               decoration: BoxDecoration(
//                 color: _primaryColor.withOpacity(0.1),
//                 shape: BoxShape.circle,
//                 image: expense.imagePath != null
//                     ? DecorationImage(image: FileImage(File(expense.imagePath!)), fit: BoxFit.cover)
//                     : null,
//               ),
//               child: expense.imagePath == null ? Icon(Icons.receipt, color: _primaryColor, size: 20) : null,
//             ),
//             const SizedBox(width: 15),
//             // Text
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(expense.merchant, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
//                   Text(DateFormat('MMM d').format(expense.date), style: TextStyle(color: Colors.grey[400], fontSize: 12)),
//                 ],
//               ),
//             ),
//             // Amount
//             Text(
//               "\$${expense.amount.toStringAsFixed(2)}",
//               style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _primaryColor),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:bill_buddy/ui/home/viewmodel/home_view_model.dart';
import 'package:bill_buddy/ui/home/widget/dashboard_card.dart';
import 'package:bill_buddy/ui/settings/screen/setting_screen.dart';
import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/local/database.dart';
import '../add_expense/screen/add_expense_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String _selectedFilterTag = "All"; // Filter State
  final HomeViewModel _viewModel = HomeViewModel(); 

  final Color _primaryColor = const Color(0xFF6C63FF);

  @override
  Widget build(BuildContext context) {
    // Pages: 0 = Dashboard/Home, 1 = Settings
    final List<Widget> pages = [
      _buildHomeTab(),
      const SettingsScreen(), // ✅ Links to Settings Page
    ];

    return Scaffold(
      body: pages[_currentIndex], // Switch body based on tab

      // FAB - Scan Bill
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExpenseScreen()));
        },
        backgroundColor: _primaryColor,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
      ),
      
      // Bottom Nav
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.dashboard_rounded, color: _currentIndex == 0 ? _primaryColor : Colors.grey),
                onPressed: () => setState(() => _currentIndex = 0),
              ),
              const SizedBox(width: 40), // Gap for FAB
              IconButton(
                icon: Icon(Icons.settings_rounded, color: _currentIndex == 1 ? _primaryColor : Colors.grey),
                onPressed: () => setState(() => _currentIndex = 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🏠 HOME TAB (Dashboard + Filters + List)
 // 🏠 HOME TAB (Dashboard + Dropdown Filter + List)
Widget _buildHomeTab() {
  // Get Currency Symbol for dashboard
  final currency = Provider.of<SettingsViewModel>(context).currencySymbol;

  return Scaffold(
    appBar: AppBar(
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text("Overview & Spendings", style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    ),
    body: StreamBuilder<List<Expense>>(
      // Watch expenses with the selected filter
      stream: database.watchExpenses(filterTag: _selectedFilterTag == "All" ? null : _selectedFilterTag),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: _primaryColor));
        }

        final expenses = snapshot.data ?? [];
        _viewModel.calculateStats(expenses);

        return CustomScrollView(
          slivers: [
            // 1. DASHBOARD CARD
            SliverToBoxAdapter(child: DashboardCard(viewModel: _viewModel)),

            // 2. HEADER ROW: Title + Filter Dropdown
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recent Transactions", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                    ),
                    
                    // ✅ NEW DROPDOWN ON RIGHT SIDE
                    _buildFilterDropdown(),
                  ],
                ),
              ),
            ),

            // 3. TRANSACTIONS LIST
            expenses.isEmpty
                ? const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50), 
                      child: Center(child: Text("No transactions found"))
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final expense = expenses[index];
                        return Dismissible(
                          key: Key(expense.id.toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => database.deleteExpense(expense.id),
                          background: Container(
                            color: Colors.red, 
                            alignment: Alignment.centerRight, 
                            padding: const EdgeInsets.only(right: 20), 
                            child: const Icon(Icons.delete, color: Colors.white)
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: _primaryColor.withOpacity(0.1),
                              backgroundImage: expense.imagePath != null ? FileImage(File(expense.imagePath!)) : null,
                              child: expense.imagePath == null ? Icon(Icons.receipt, color: _primaryColor) : null,
                            ),
                            title: Text(expense.merchant, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(DateFormat('MMM d').format(expense.date)),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "$currency${expense.amount.toStringAsFixed(2)}", 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _primaryColor)
                                ),
                                Text(
                                  expense.category, 
                                  style: const TextStyle(fontSize: 10, color: Colors.grey)
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: expenses.length,
                    ),
                  ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        );
      },
    ),
  );
}

// 🔽 HELPER WIDGET: The Filter Dropdown
Widget _buildFilterDropdown() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(

      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
      ],
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: StreamBuilder<List<Tag>>(
      stream: database.watchAllTags(),
      builder: (context, snapshot) {
        final tags = snapshot.data ?? [];
        final filterOptions = [
          
          "All",...tags.map((e) => e.name)
          ];

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedFilterTag,
            borderRadius: BorderRadius.circular(20),
            icon: Icon(Icons.filter_list_rounded, color: _primaryColor, size: 20),
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 13),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() => _selectedFilterTag = newValue);
              }
            },
            items: filterOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                
                value: value,
                child: Row(
                  children: [
                    if (value != "All") ...[
                      // Small color dot for tags
                      Container(
                        width: 8, height: 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          
                          color: _primaryColor.withOpacity(0.7),
                          shape: BoxShape.circle
                        ),
                      )
                    ],
                    Text(value),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    ),
  );
}
}