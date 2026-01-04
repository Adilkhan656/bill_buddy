
// import 'dart:io';
// import 'package:bill_buddy/ui/expense_detail/expense_detail_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// // Internal App Imports
// import '../../data/local/database.dart';
// import '../../data/auth/auth_service.dart';
// import '../../util/category_style_helper.dart';
// import '../add_expense/screen/add_expense_screen.dart';

// import '../home/viewmodel/home_view_model.dart';
// import '../home/widget/dashboard_card.dart';
// import '../settings/screen/setting_screen.dart';
// import '../settings/view_model/setting_view_model.dart';
// import '../chatbot/chatbot_screen.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;

//   // ✅ FIX 1: Make this Nullable (DateTime?) to support "All Time"
//   DateTime? _dashboardMonth = DateTime.now();

//   // List filters
//   DateTime? _listMonthFilter;
//   String _selectedCategoryFilter = "All";

//   final HomeViewModel _viewModel = HomeViewModel();

//   // ✅ FIX 2: Store the stream here so it doesn't reload on every click
//   late Stream<List<Expense>> _expensesStream;

//   @override
//   void initState() {
//     super.initState();
//     // ✅ FIX 2: Initialize ONLY ONCE. This stops the "Loading..." flash.
//     _expensesStream = database.watchAllExpenses();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;

//     final pages = [_buildHomeTab(context), const SettingsScreen()];

//     return Scaffold(

//       body: pages[_currentIndex],
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: primaryColor,
//         shape: const CircleBorder(),
//         child: const Icon(Icons.qr_code_scanner, color: Colors.white),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
//           );
//         },
//       ),
//       bottomNavigationBar: BottomAppBar(

       
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 10,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//         IconButton(
//   style: ButtonStyle(
//     foregroundColor: WidgetStateProperty.resolveWith((states) {
//       if (_currentIndex == 0) {
//         return Theme.of(context).colorScheme.primary; // GREEN always
//       }
//       return Colors.grey;
//     }),
//     overlayColor: WidgetStateProperty.all(Colors.transparent),
//   ),
//   icon: const Icon(Icons.home_rounded),
//   onPressed: () => setState(() => _currentIndex = 0),
// ),
//             const SizedBox(width: 30),
//            IconButton(
//   style: ButtonStyle(
//     foregroundColor: WidgetStateProperty.resolveWith((states) {
//       if (_currentIndex == 1) {
//         return Theme.of(context).colorScheme.primary; // GREEN always
//       }
//       return Colors.grey;
//     }),
//     overlayColor: WidgetStateProperty.all(Colors.transparent),
//   ),
//   icon: const Icon(Icons.settings_rounded),
//   onPressed: () => setState(() => _currentIndex = 1),
// ),
//           ],
//         ),
//       ),
//     );
//   }
  

//   // ---------------------------------------------------------------------------
//   // HOME TAB
//   // ---------------------------------------------------------------------------
//   Widget _buildHomeTab(BuildContext context) {
//     final auth = Provider.of<AuthService>(context, listen: false);
//     final user = auth.currentUser;
//     final currency = Provider.of<SettingsViewModel>(context).currencySymbol;

// final isDark = Theme.of(context).brightness == Brightness.dark;

// final Color primaryColor = Theme.of(context).primaryColor;
// final Color textColor = Theme.of(context).colorScheme.onSurface;
// final Color subTextColor =
//     isDark ? Colors.grey.shade400 : Colors.grey.shade600;
// final Color chipTextColor =
//     isDark ? Colors.white : Colors.grey.shade700;
// final Color chipBgColor =
//     isDark ? Colors.grey.shade800 : Colors.grey.shade100;
//     // final primaryColor = Theme.of(context).primaryColor;
//     // final textColor = Theme.of(context).colorScheme.onSurface;
//     // final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         toolbarHeight: 70,
//         title: user == null
//             ? const Text("Dashboard")
//             : FutureBuilder<UserProfile?>(
//                 future: database.getUserProfile(user.uid),
//                 builder: (_, snap) {
//                   final name = snap.data?.name ?? user.displayName ?? "User";
//                   return Text(
//                     "Hi, ${name.split(" ").first} 👋",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: textColor,
//                     ),
//                   );
//                 },
//               ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.smart_toy_outlined),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const ChatbotScreen()),
//               );
//             },
//           ),
//         ],
//       ),

//       // ✅ FIX 2: Use the pre-initialized stream. No more reloading spinner!
//       body: StreamBuilder<List<Expense>>(
//         stream: _expensesStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(color: primaryColor),
//             );
//           }

//           final allExpenses = snapshot.data ?? [];

//           // ---------------------------------------------------
//           // 🧠 FILTER LOGIC (IN MEMORY - INSTANT)
//           // ---------------------------------------------------

//           // 1. Dashboard Logic
//           _viewModel.calculateStats(allExpenses, _dashboardMonth);

//           // 2. List Logic
//           final listExpenses = allExpenses.where((e) {
//             // Category Filter
//             if (_selectedCategoryFilter != "All" &&
//                 e.category != _selectedCategoryFilter) {
//               return false;
//             }
//             // Month Filter
//             if (_listMonthFilter != null) {
//               if (e.date.year != _listMonthFilter!.year ||
//                   e.date.month != _listMonthFilter!.month) {
//                 return false;
//               }
//             }
//             return true;
//           }).toList();

//           return CustomScrollView(
//             slivers: [
//               // ---------------- DASHBOARD ----------------
//               SliverToBoxAdapter(
//                 child: DashboardCard(
//                   viewModel: _viewModel,
//                   selectedDate: _dashboardMonth,
//                   // ✅ FIX 1: Removed '!' check. Now accepts null for All Time.
//                   onDateChanged: (date) {
//                     setState(() => _dashboardMonth = date);
//                   },
//                 ),
//               ),

//               // ---------------- FILTERS ----------------
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 10,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Transactions",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: [
//                             _buildListMonthFilter(context),
//                             const SizedBox(width: 120),
//                             _buildCategoryFilter(context),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // ---------------- TRANSACTIONS LIST ----------------
//               listExpenses.isEmpty
//                   ? SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 50),
//                         child: Center(
//                           child: Text(
//                             "No transactions found",
//                             style: TextStyle(color: Colors.grey[400]),
//                           ),
//                         ),
//                       ),
//                     )
//                   : SliverList(
//                       delegate: SliverChildBuilderDelegate((context, index) {
//                         final e = listExpenses[index];

//                         return InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => ExpenseDetailScreen(expense: e),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 6,
//                             ),
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).cardColor,
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: Colors.grey.withOpacity(0.1),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 // Leading
//                                 Container(
//                                   width: 46,
//                                   height: 46,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: isDark
//                                         ? Colors.grey[800]
//                                         : Colors.grey[100],
//                                     image: e.imagePath != null
//                                         ? DecorationImage(
//                                             image: FileImage(
//                                               File(e.imagePath!),
//                                             ),
//                                             fit: BoxFit.cover,
//                                           )
//                                         : null,
//                                   ),
//                                   child: e.imagePath == null
//                                       ? Icon(
//                                           Icons.receipt_outlined,
//                                           color: primaryColor,
//                                         )
//                                       : null,
//                                 ),
//                                 const SizedBox(width: 16),

//                                 // Middle
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         e.merchant,
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           color: textColor,
//                                         ),
//                                       ),
//                                       Text(
//                                         DateFormat(
//                                           'MMM d, yyyy',
//                                         ).format(e.date),
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey[500],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),

//                                 // Right
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                         vertical: 4,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: isDark
//                                             ? Colors.grey[800]
//                                             : Colors.grey[100],
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           CategoryStyleHelper.getTagIcon(
//                                             e.category,
//                                             size: 12,
//                                           ),
//                                           const SizedBox(width: 4),
//                                           Text(
//                                             e.category,
//                                             style: TextStyle(
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.bold,
//                                               color: chipTextColor,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       "$currency${e.amount.toStringAsFixed(0)}",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: textColor,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }, childCount: listExpenses.length),
//                     ),

//               const SliverToBoxAdapter(child: SizedBox(height: 80)),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // MONTH FILTER FOR LIST
//   // ---------------------------------------------------------------------------
//   // ---------------------------------------------------------------------------
//   // MONTH FILTER FOR LIST
//   // ---------------------------------------------------------------------------
//   Widget _buildListMonthFilter(BuildContext context) {
//     final Color textColor = Theme.of(context).colorScheme.onSurface;
//     final cardColor = Theme.of(context).cardColor;
//     final iconColor = Theme.of(context).colorScheme.onSurface;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final months = <DateTime?>[null];
//     final now = DateTime.now();
//     for (int i = 0; i < 12; i++) {
//       months.add(DateTime(now.year, now.month - i, 1));
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ✅ LABEL ABOVE
//         Padding(
//           padding: const EdgeInsets.only(left: 4, bottom: 6),
//           child: Text(
//             "Period",
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ),
//         // ✅ SMALLER BOX
//         Container(
//           height: 40, // Fixed small height
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
            
//             color: cardColor,
//             borderRadius: BorderRadius.circular(20), // Tighter radius
//             border: Border.all(
//               color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//             ),
//           ),
//           child: DropdownButtonHideUnderline(
         
//             child: DropdownButton<DateTime?>(
//               menuMaxHeight: 300,
//                   borderRadius: BorderRadius.circular(12),
//               value: _listMonthFilter,
//               isDense: true, // ✅ Compresses height
//               icon: Icon(
//                 Icons.keyboard_arrow_down_rounded, // Cleaner icon
//                 size: 20,
//                 color: iconColor,
//               ),
//               onChanged: (val) => setState(() => _listMonthFilter = val),
//               items: months.map((m) {
//                 return DropdownMenuItem(
//                   value: m,
//                   child: Text(
//                     m == null ? "All Time" : DateFormat('MMM yyyy').format(m),
//                     style: TextStyle(
//                       fontSize: 13, // Smaller font
//                       color: textColor,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // CATEGORY FILTER FOR LIST
//   // ---------------------------------------------------------------------------
// Widget _buildCategoryFilter(BuildContext context) {
//     final cardColor = Theme.of(context).cardColor;
//     final iconColor = Theme.of(context).colorScheme.onSurface;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ✅ LABEL ABOVE
//         Padding(
//           padding: const EdgeInsets.only(left: 4, bottom: 6),
//           child: Text(
//             "Category/Tags",
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ),
//         // ✅ SMALLER BOX
//         Container(
//           height: 40, // Fixed small height
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: cardColor,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//             ),
//           ),
//           child: StreamBuilder<List<Tag>>(
//             stream: database.watchAllTags(),
//             builder: (_, snap) {
//               final tags = snap.data ?? [];
//               final items = ["All", ...tags.map((e) => e.name)];

//               return DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   menuMaxHeight: 300,
//                   borderRadius: BorderRadius.circular(12),
//                   value: _selectedCategoryFilter,
//                   isDense: true, // ✅ Compresses height
//                   icon: Icon(
//                     Icons.keyboard_arrow_down_rounded, // Cleaner icon
//                     size: 20,
//                     color: iconColor,
//                   ),
//                   onChanged: (val) =>
//                       setState(() => _selectedCategoryFilter = val!),
//                   items: items.map((e) {
//                     return DropdownMenuItem(
//                       value: e,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           if (e != "All") ...[
//                             CategoryStyleHelper.getTagIcon(e, size: 14),
//                             const SizedBox(width: 8),
//                           ],
//                           Text(
//                             e,
//                             style: const TextStyle(
//                               fontSize: 13, // Smaller font
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:io';
import 'package:bill_buddy/ui/expense_detail/expense_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Internal App Imports
import '../../data/local/database.dart';
import '../../data/auth/auth_service.dart';
import '../../util/category_style_helper.dart';
import '../add_expense/screen/add_expense_screen.dart';

import '../home/viewmodel/home_view_model.dart';
import '../home/widget/dashboard_card.dart';
import '../settings/screen/setting_screen.dart';
import '../settings/view_model/setting_view_model.dart';
import '../chatbot/chatbot_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Dashboard Month
  DateTime? _dashboardMonth = DateTime.now();

  // List filters
  DateTime? _listMonthFilter;
  String _selectedCategoryFilter = "All";

  // ✅ SEARCH STATE
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final HomeViewModel _viewModel = HomeViewModel();
  late Stream<List<Expense>> _expensesStream;

  @override
  void initState() {
    super.initState();
    _expensesStream = database.watchAllExpenses();
    // Removed listener from here to fix Hot Reload issues
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final pages = [_buildHomeTab(context), const SettingsScreen()];

    return Scaffold(
      resizeToAvoidBottomInset: false, // Keeps FAB behind keyboard
      body: pages[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (_currentIndex == 0) {
                    return Theme.of(context).colorScheme.primary; 
                  }
                  return Colors.grey;
                }),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
              ),
              icon: const Icon(Icons.home_rounded),
              onPressed: () => setState(() => _currentIndex = 0),
            ),
            const SizedBox(width: 30),
            IconButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (_currentIndex == 1) {
                    return Theme.of(context).colorScheme.primary;
                  }
                  return Colors.grey;
                }),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
              ),
              icon: const Icon(Icons.settings_rounded),
              onPressed: () => setState(() => _currentIndex = 1),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HOME TAB
  // ---------------------------------------------------------------------------
  Widget _buildHomeTab(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final Color chipTextColor = isDark ? Colors.white : Colors.grey.shade700;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 70,
        title: user == null
            ? const Text("Dashboard")
            : FutureBuilder<UserProfile?>(
                future: database.getUserProfile(user.uid),
                builder: (_, snap) {
                  final name = snap.data?.name ?? user.displayName ?? "User";
                  return Text(
                    "Hi, ${name.split(" ").first} 👋",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  );
                },
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatbotScreen()),
              );
            },
          ),
        ],
      ),

      body: StreamBuilder<List<Expense>>(
        stream: _expensesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
          }

          final allExpenses = snapshot.data ?? [];

          // 1. Dashboard Logic
          _viewModel.calculateStats(allExpenses, _dashboardMonth);

          // 2. Filter Logic
          final listExpenses = allExpenses.where((e) {
            
            // ✅ SEARCH FILTER LOGIC
            if (_searchQuery.isNotEmpty) {
              final merchant = e.merchant.toLowerCase();
              final category = e.category.toLowerCase();
              
              // Formats: "03 January 2026", "03/01/2026", and "Jan 3, 2026" (Visible format)
              final dateString1 = DateFormat('dd MMMM yyyy').format(e.date).toLowerCase(); 
              final dateString2 = DateFormat('dd/MM/yyyy').format(e.date); 
              final dateString3 = DateFormat('MMM d, yyyy').format(e.date).toLowerCase(); 

              final matchesSearch = merchant.contains(_searchQuery) || 
                                    category.contains(_searchQuery) ||
                                    dateString1.contains(_searchQuery) ||
                                    dateString2.contains(_searchQuery) ||
                                    dateString3.contains(_searchQuery);

              if (!matchesSearch) return false;
            }

            // Standard Filters
            if (_selectedCategoryFilter != "All" && e.category != _selectedCategoryFilter) {
              return false;
            }
            if (_listMonthFilter != null) {
              if (e.date.year != _listMonthFilter!.year ||
                  e.date.month != _listMonthFilter!.month) {
                return false;
              }
            }
            return true;
          }).toList();

          return CustomScrollView(
            slivers: [
              // DASHBOARD
              SliverToBoxAdapter(
                child: DashboardCard(
                  viewModel: _viewModel,
                  selectedDate: _dashboardMonth,
                  onDateChanged: (date) {
                    setState(() => _dashboardMonth = date);
                  },
                ),
              ),

              // SEARCH & FILTERS HEADER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ANIMATED SEARCH HEADER
                      AnimatedCrossFade(
                        firstChild: _buildTitleRow(context),
                        secondChild: _buildSearchBar(context),
                        crossFadeState: _isSearching 
                            ? CrossFadeState.showSecond 
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                        firstCurve: Curves.easeOut,
                        secondCurve: Curves.easeIn,
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // FILTERS
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildListMonthFilter(context),
                            const SizedBox(width: 120), 
                            _buildCategoryFilter(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // TRANSACTIONS LIST
              listExpenses.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                             _searchQuery.isNotEmpty 
                                ? "No results found for '$_searchQuery'"
                                : "No transactions found",
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final e = listExpenses[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ExpenseDetailScreen(expense: e)),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.withOpacity(0.1)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                                    image: e.imagePath != null
                                        ? DecorationImage(
                                            image: FileImage(File(e.imagePath!)),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: e.imagePath == null
                                      ? Icon(Icons.receipt_outlined, color: primaryColor)
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.merchant,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
                                      ),
                                      Text(
                                        DateFormat('MMM d, yyyy').format(e.date),
                                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          CategoryStyleHelper.getTagIcon(e.category, size: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            e.category,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: chipTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "$currency${e.amount.toStringAsFixed(0)}",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }, childCount: listExpenses.length),
                    ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
      ),
    );
  }

  // ✅ 1. Normal Title Row with Search Icon
  Widget _buildTitleRow(BuildContext context) {
    return SizedBox(
      height: 50, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Transactions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
            icon: const Icon(Icons.search_rounded, size: 24),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(8),
            ),
          )
        ],
      ),
    );
  }

  // ✅ 2. Expanded Search Bar with ONCHANGED logic (Fixed)
  Widget _buildSearchBar(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: _searchController,
        autofocus: true, 
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        // ✅ THIS FIXES THE SEARCH NOT UPDATING:
        onChanged: (val) {
          setState(() {
            _searchQuery = val.trim().toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: "Search merchant, tag, date...",
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchController.clear();
                _searchQuery = "";
              });
            },
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FILTER WIDGETS
  // ---------------------------------------------------------------------------
  Widget _buildListMonthFilter(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final cardColor = Theme.of(context).cardColor;
    final iconColor = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final months = <DateTime?>[null];
    final now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      months.add(DateTime(now.year, now.month - i, 1));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            "Period",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DateTime?>(
              menuMaxHeight: 300,
              borderRadius: BorderRadius.circular(12),
              value: _listMonthFilter,
              isDense: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: iconColor),
              onChanged: (val) => setState(() => _listMonthFilter = val),
              items: months.map((m) {
                return DropdownMenuItem(
                  value: m,
                  child: Text(
                    m == null ? "All Time" : DateFormat('MMM yyyy').format(m),
                    style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final iconColor = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            "Category/Tags",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            ),
          ),
          child: StreamBuilder<List<Tag>>(
            stream: database.watchAllTags(),
            builder: (_, snap) {
              final tags = snap.data ?? [];
              final items = ["All", ...tags.map((e) => e.name)];

              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  menuMaxHeight: 300,
                  borderRadius: BorderRadius.circular(12),
                  value: _selectedCategoryFilter,
                  isDense: true,
                  icon: Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: iconColor),
                  onChanged: (val) => setState(() => _selectedCategoryFilter = val!),
                  items: items.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (e != "All") ...[
                            CategoryStyleHelper.getTagIcon(e, size: 14),
                            const SizedBox(width: 8),
                          ],
                          Text(e, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}