// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// // Internal App Imports
// import '../../data/local/database.dart';
// import '../../data/auth/auth_service.dart';
// import '../add_expense/screen/add_expense_screen.dart';
// import '../home/viewmodel/home_view_model.dart';
// import '../home/widget/dashboard_card.dart';
// import '../settings/screen/setting_screen.dart'; // Ensure filename matches exactly
// import '../settings/view_model/setting_view_model.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   // Navigation State
//   int _currentIndex = 0;
  
//   // Filter State
//   String _selectedFilterTag = "All"; 
  
//   // ViewModel
//   final HomeViewModel _viewModel = HomeViewModel(); 

//   @override
//   Widget build(BuildContext context) {
//     // Theme Colors
//     final primaryColor = Theme.of(context).primaryColor;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     // Pages: 0 = Dashboard, 1 = Settings
//     final List<Widget> pages = [
//       _buildHomeTab(context),
//       const SettingsScreen(), 
//     ];

//     return Scaffold(
//       // ✅ Switch Body based on Tab
//       body: pages[_currentIndex], 

//       // ✅ FAB - Scan Bill
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context, 
//             MaterialPageRoute(builder: (context) => const AddExpenseScreen())
//           );
//         },
//         backgroundColor: primaryColor,
//         elevation: 4,
//         shape: const CircleBorder(),
//         child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
//       ),
      
//       // ✅ Bottom Navigation Bar
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 8,
//         color: Theme.of(context).cardColor,
//         child: SizedBox(
//           height: 60,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.home_rounded, color: _currentIndex == 0 ? isDark ? Colors.white : Colors.black : Colors.grey),
//                 onPressed: () => setState(() => _currentIndex = 0),
//               ),
//               const SizedBox(width: 30), // Gap for FAB
//               IconButton(
//                 icon: Icon(Icons.settings_rounded, color: _currentIndex == 1 ? isDark ? Colors.white : Colors.black : Colors.grey),
//                 onPressed: () => setState(() => _currentIndex = 1),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------------------------------------------------
//   // 🏠 HOME TAB (Dashboard + Filters + List)
//   // ---------------------------------------------------
//   Widget _buildHomeTab(BuildContext context) {
//     final authService = Provider.of<AuthService>(context, listen: false);
//     final user = authService.currentUser;
//     final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
//     final primaryColor = Theme.of(context).primaryColor;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//         backgroundColor: Theme.of(context).brightness == Brightness.dark
//       ? Colors.black
//       : Colors.white,
//       // AppBar with Username Logic
//       appBar: AppBar(
//         toolbarHeight: 80,
//         title: user == null 
//           ? const Text("Dashboard") 
//           : FutureBuilder<UserProfile?>(
//               future: database.getUserProfile(user.uid),
//               builder: (context, snapshot) {
//                 // Logic: DB Name -> Google Name -> "User"
//                 final name = snapshot.data?.name ?? user.displayName ?? "User";
//                 final firstName = name.split(" ")[0]; // Just the first name

//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Hi, $firstName 👋",
//                       style: TextStyle(
//                         fontSize: 24, 
//                         fontWeight: FontWeight.bold,
//                         color: isDark ? Colors.white : Colors.black87,
//                       ),
//                     ),
//                     Text(
//                       "Here is your spending summary",
//                       style: TextStyle(
//                         fontSize: 14, 
//                         color: isDark ? Colors.grey[400] : Colors.grey[600],
//                         fontWeight: FontWeight.normal
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//       ),

//       // Main Content
//       body: StreamBuilder<List<Expense>>(
//         // Watch expenses based on selected filter
//         stream: database.watchExpenses(filterTag: _selectedFilterTag == "All" ? null : _selectedFilterTag),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator(color: primaryColor));
//           }

//           final expenses = snapshot.data ?? [];
//           _viewModel.calculateStats(expenses);

//           return CustomScrollView(
//             slivers: [
//               // 1. DASHBOARD CARD
//               SliverToBoxAdapter(child: DashboardCard(viewModel: _viewModel)),

//               // 2. HEADER ROW: Title + Filter Dropdown
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Recent Transactions", 
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
//                       ),
                      
//                       // Filter Dropdown Widget
//                       _buildFilterDropdown(context),
//                     ],
//                   ),
//                 ),
//               ),

//               // 3. TRANSACTIONS LIST
//               expenses.isEmpty
//                   ? SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 50), 
//                         child: Center(
//                           child: Column(
//                             children: [
//                               Icon(Icons.receipt_long, size: 60, color: Colors.grey.withOpacity(0.3)),
//                               const SizedBox(height: 10),
//                               const Text("No transactions found", style: TextStyle(color: Colors.grey)),
//                             ],
//                           ),
//                         )
//                       ),
//                     )
//                   : SliverList(
//                       delegate: SliverChildBuilderDelegate(
//                         (context, index) {
//                           final expense = expenses[index];
//                           return Dismissible(
//                             key: Key(expense.id.toString()),
//                             direction: DismissDirection.endToStart,
//                             onDismissed: (_) {
//                               database.deleteExpense(expense.id);
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text("Expense deleted"))
//                               );
//                             },
//                             background: Container(
//                               color: Colors.redAccent, 
//                               alignment: Alignment.centerRight, 
//                               padding: const EdgeInsets.only(right: 20), 
//                               child: const Icon(Icons.delete, color: Colors.white)
//                             ),
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                               leading: CircleAvatar(
//                                 radius: 25,
//                                 backgroundColor: primaryColor.withOpacity(0.1),
//                                 backgroundImage: expense.imagePath != null ? FileImage(File(expense.imagePath!)) : null,
//                                 child: expense.imagePath == null ? Icon(Icons.receipt, color: primaryColor) : null,
//                               ),
//                               title: Text(expense.merchant, style: const TextStyle(fontWeight: FontWeight.bold)),
//                               subtitle: Text(DateFormat('MMM d, y').format(expense.date)),
//                               trailing: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     "$currency${expense.amount.toStringAsFixed(2)}", 
//                                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor)
//                                   ),
//                                   Text(
//                                     expense.category, 
//                                     style: const TextStyle(fontSize: 12, color: Colors.grey)
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                         childCount: expenses.length,
//                       ),
//                     ),
              
//               const SliverToBoxAdapter(child: SizedBox(height: 80)), // Bottom padding
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // ---------------------------------------------------
//   // 🔽 HELPER WIDGET: Filter Dropdown
//   // ---------------------------------------------------
//   Widget _buildFilterDropdown(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final cardColor = Theme.of(context).cardColor;
//     final textColor = Theme.of(context).colorScheme.onSurface;
//     final primaryColor = Theme.of(context).primaryColor;
//     final borderColor = isDark ? Colors.grey[800]! : Colors.grey.shade200;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
//         ],
//         border: Border.all(color: borderColor),
//       ),
//       child: StreamBuilder<List<Tag>>(
//         stream: database.watchAllTags(),
//         builder: (context, snapshot) {
//           final tags = snapshot.data ?? [];
          
//           // Create list: ["All", "Grocery", "Rent", ...]
//           final filterOptions = ["All", ...tags.map((e) => e.name)];

//           return DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: filterOptions.contains(_selectedFilterTag) ? _selectedFilterTag : "All",
//               dropdownColor: cardColor,
//               borderRadius: BorderRadius.circular(20),
//               icon: Icon(Icons.filter_list_rounded, color: primaryColor, size: 20),
//               style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 13),
//               onChanged: (String? newValue) {
//                 if (newValue != null) {
//                   setState(() => _selectedFilterTag = newValue);
//                 }
//               },
//               items: filterOptions.map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Row(
//                     children: [
//                       if (value != "All") ...[
//                         // Small colored dot for categories
//                         Container(
//                           width: 8, height: 8,
//                           margin: const EdgeInsets.only(right: 8),
//                           decoration: BoxDecoration(
//                             color: primaryColor.withOpacity(0.7),
//                             shape: BoxShape.circle
//                           ),
//                         )
//                       ],
//                       Text(value),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:bill_buddy/ui/expense_detail/expense_detail_screen.dart';
import 'package:bill_buddy/util/category_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Internal App Imports
import '../../data/local/database.dart';
import '../../data/auth/auth_service.dart';
import '../../util/category_icon_helper.dart'; // ✅ Import Helper
import '../add_expense/screen/add_expense_screen.dart';
import '../home/viewmodel/home_view_model.dart';
import '../home/widget/dashboard_card.dart';
import '../settings/screen/setting_screen.dart';
import '../settings/view_model/setting_view_model.dart';

import '../chatbot/chatbot_screen.dart'; // ✅ Import Chatbot

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String _selectedFilterTag = "All"; 
  final HomeViewModel _viewModel = HomeViewModel(); 

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final List<Widget> pages = [
      _buildHomeTab(context),
      const SettingsScreen(), 
    ];

    return Scaffold(
      body: pages[_currentIndex], 

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AddExpenseScreen())
          );
        },
        backgroundColor: primaryColor,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
      ),
      
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Theme.of(context).cardColor,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home_rounded, color: _currentIndex == 0 ? primaryColor : Colors.grey),
                onPressed: () => setState(() => _currentIndex = 0),
              ),
              const SizedBox(width: 30), 
              IconButton(
                icon: Icon(Icons.settings_rounded, color: _currentIndex == 1 ? primaryColor : Colors.grey),
                onPressed: () => setState(() => _currentIndex = 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // 🏠 HOME TAB
  // ---------------------------------------------------
Widget _buildHomeTab(BuildContext context) {
    // ... (Keep existing variable setup: auth, user, currency, etc.)
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        // ... (Keep your existing AppBar code with "Hi Name" and Chatbot)
        toolbarHeight: 70,
        title: user == null ? const Text("Dashboard") : FutureBuilder<UserProfile?>(
           future: database.getUserProfile(user.uid),
           builder: (ctx, snap) {
             final name = snap.data?.name ?? user.displayName ?? "User";
             return Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text("Hi, ${name.split(' ')[0]} 👋", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                 Text("Spending Summary", style: TextStyle(fontSize: 12, color: Colors.grey)),
               ],
             );
           }
        ),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.smart_toy_outlined))
        ],
      ),

      body: StreamBuilder<List<Expense>>(
        stream: database.watchExpenses(filterTag: _selectedFilterTag == "All" ? null : _selectedFilterTag),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
          }

          final expenses = snapshot.data ?? [];
          _viewModel.calculateStats(expenses);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: DashboardCard(viewModel: _viewModel)),

              // FILTER HEADER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Transactions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      _buildFilterDropdown(context), // ✅ Updated Dropdown
                    ],
                  ),
                ),
              ),

              expenses.isEmpty
                  ? const SliverToBoxAdapter(child: Center(child: Text("No transactions found")))
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final expense = expenses[index];
                          
                          return InkWell(
                            onTap: () {
                               // Navigate to details (keep existing logic)
                               Navigator.push(context, MaterialPageRoute(builder: (_) => ExpenseDetailScreen(expense: expense)));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                                ],
                              ),
                              child: Row(
                                children: [
                                  // ✅ 1. LEADING: RECEIPT IMAGE (Circular)
                                  Container(
                                    width: 50, height: 50,
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                      image: expense.imagePath != null
                                          ? DecorationImage(
                                              image: FileImage(File(expense.imagePath!)), // Show Bill Photo
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    // Fallback if no bill photo
                                    child: expense.imagePath == null
                                        ? Icon(Icons.receipt_outlined, color: primaryColor)
                                        : null,
                                  ),
                                  
                                  const SizedBox(width: 16),
                                  
                                  // ✅ 2. TITLE: MERCHANT NAME
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          expense.merchant, // Merchant on TOP
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16,
                                            color: textColor
                                          )
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('MMM d').format(expense.date),
                                          style: TextStyle(color: Colors.grey[500], fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // ✅ 3. RIGHT SIDE: AMOUNT + TAG ICON
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "$currency${expense.amount.toStringAsFixed(0)}", 
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, 
                                          fontSize: 16, 
                                          color: textColor
                                        )
                                      ),
                                      const SizedBox(height: 6),
                                      
                                      // The Tag Chip with Custom Image
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isDark ? Colors.grey[800] : Colors.grey[100],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Tag Icon from Assets
                                            CategoryStyleHelper.getTagIcon(expense.category, size: 14),
                                            const SizedBox(width: 6),
                                            Text(
                                              expense.category, 
                                              style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w600)
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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

Widget _buildFilterDropdown(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: StreamBuilder<List<Tag>>(
        stream: database.watchAllTags(),
        builder: (context, snapshot) {
          final tags = snapshot.data ?? [];
          final filterOptions = ["All", ...tags.map((e) => e.name)];

          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: filterOptions.contains(_selectedFilterTag) ? _selectedFilterTag : "All",
              dropdownColor: cardColor,
              borderRadius: BorderRadius.circular(20),
              icon: Icon(Icons.filter_list_rounded, color: primaryColor, size: 20),
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 13),
              
              // ✅ THIS IS THE FIX: Limits height and enables scrolling
              menuMaxHeight: 300, 
              
              onChanged: (val) {
                 if(val != null) setState(() => _selectedFilterTag = val);
              },
              items: filterOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      if (value != "All") ...[
                        CategoryStyleHelper.getTagIcon(value, size: 18),
                        const SizedBox(width: 8),
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