// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../../data/local/database.dart';
// import '../../data/auth/auth_service.dart';
// import '../../util/category_style_helper.dart';
// import '../add_expense/screen/add_expense_screen.dart';
// import '../expense_detail/expense_detail_screen.dart';
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

//   // Dashboard month
//   DateTime _dashboardMonth = DateTime.now();

//   // List filters
//   DateTime? _listMonthFilter; // null = all time
//   String _selectedCategoryFilter = "All";

//   final HomeViewModel _viewModel = HomeViewModel();

//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;

//     final pages = [
//       _buildHomeTab(context),
//       const SettingsScreen(),
//     ];

//     return Scaffold(
//       body: pages[_currentIndex],
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: primaryColor,
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
//         notchMargin: 8,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: Icon(Icons.home_rounded,
//                   color:
//                       _currentIndex == 0 ? primaryColor : Colors.grey),
//               onPressed: () => setState(() => _currentIndex = 0),
//             ),
//             const SizedBox(width: 30),
//             IconButton(
//               icon: Icon(Icons.settings_rounded,
//                   color:
//                       _currentIndex == 1 ? primaryColor : Colors.grey),
//               onPressed: () => setState(() => _currentIndex = 1),
//             ),
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
//     final currency =
//         Provider.of<SettingsViewModel>(context).currencySymbol;

//     final primaryColor = Theme.of(context).primaryColor;
//     final textColor = Theme.of(context).colorScheme.onSurface;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 70,
//         title: user == null
//             ? const Text("Dashboard")
//             : FutureBuilder<UserProfile?>(
//                 future: database.getUserProfile(user.uid),
//                 builder: (_, snap) {
//                   final name =
//                       snap.data?.name ?? user.displayName ?? "User";
//                   return Text(
//                     "Hi, ${name.split(" ").first} 👋",
//                     style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: textColor),
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
//           )
//         ],
//       ),

//       // 🔥 NO STREAMBUILDER HERE
//       body: CustomScrollView(
//         slivers: [
//           // ---------------- DASHBOARD ----------------
//           SliverToBoxAdapter(
//             child: DashboardCard(
//   viewModel: _viewModel,
//   selectedDate: _dashboardMonth,
//   // This is the SINGLE callback you need
//   onDateChanged: (date) {
//     setState(() => _dashboardMonth = date!); // Logic handles null inside DashboardCard usually, but here mainscreen expects non-null for dashboardMonth currently.
//     // WAIT! We updated HomeViewModel to accept NULL for "All Time".
//     // So update _dashboardMonth to be DateTime? (nullable) in MainScreenState.
//   },
// ),
//           ),

//           // ---------------- FILTERS ----------------
//           SliverToBoxAdapter(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Transactions",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       _buildListMonthFilter(context),
//                       const SizedBox(width: 10),
//                       _buildCategoryFilter(context),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),

//           // ---------------- TRANSACTIONS (ONLY STREAM) ----------------
//           _buildTransactionList(
//             currency: currency,
//             primaryColor: primaryColor,
//             textColor: textColor,
//             isDark: isDark,
//           ),

//           const SliverToBoxAdapter(child: SizedBox(height: 80)),
//         ],
//       ),
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // TRANSACTION LIST (FIXED)
//   // ---------------------------------------------------------------------------
//   Widget _buildTransactionList({
//     required String currency,
//     required Color primaryColor,
//     required Color textColor,
//     required bool isDark,
//   }) {
//     return StreamBuilder<List<Expense>>(
//       stream: database.watchAllExpenses(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const SliverToBoxAdapter(
//             child: Padding(
//               padding: EdgeInsets.only(top: 50),
//               child: Center(child: CircularProgressIndicator()),
//             ),
//           );
//         }

//         final allExpenses = snapshot.data!;
//         _viewModel.calculateStats(allExpenses, _dashboardMonth);

//         final expenses = _applyFilters(allExpenses);

//         if (expenses.isEmpty) {
//           return const SliverToBoxAdapter(
//             child: Padding(
//               padding: EdgeInsets.only(top: 50),
//               child: Center(child: Text("No transactions found")),
//             ),
//           );
//         }

//         return SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (context, index) {
//               final e = expenses[index];

//               return InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (_) =>
//                             ExpenseDetailScreen(expense: e)),
//                   );
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(
//                       horizontal: 20, vertical: 6),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor,
//                     borderRadius: BorderRadius.circular(16),
//                     border:
//                         Border.all(color: Colors.grey.withOpacity(0.1)),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 46,
//                         height: 46,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: isDark
//                               ? Colors.grey[800]
//                               : Colors.grey[100],
//                           image: e.imagePath != null
//                               ? DecorationImage(
//                                   image: FileImage(File(e.imagePath!)),
//                                   fit: BoxFit.cover)
//                               : null,
//                         ),
//                         child: e.imagePath == null
//                             ? Icon(Icons.receipt_outlined,
//                                 color: primaryColor)
//                             : null,
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(e.merchant,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     color: textColor)),
//                             Text(
//                               DateFormat('MMM d, yyyy').format(e.date),
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey[500]),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: isDark
//                                   ? Colors.grey[800]
//                                   : Colors.grey[100],
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Row(
//                               children: [
//                                 CategoryStyleHelper.getTagIcon(
//                                     e.category,
//                                     size: 12),
//                                 const SizedBox(width: 4),
//                                 Text(e.category,
//                                     style: TextStyle(
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.grey[600])),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "$currency${e.amount.toStringAsFixed(0)}",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: primaryColor),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//             childCount: expenses.length,
//           ),
//         );
//       },
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // FILTER LOGIC (UNCHANGED)
//   // ---------------------------------------------------------------------------
//   List<Expense> _applyFilters(List<Expense> expenses) {
//     return expenses.where((e) {
//       if (_selectedCategoryFilter != "All" &&
//           e.category != _selectedCategoryFilter) {
//         return false;
//       }

//       if (_listMonthFilter != null) {
//         if (e.date.year != _listMonthFilter!.year ||
//             e.date.month != _listMonthFilter!.month) {
//           return false;
//         }
//       }
//       return true;
//     }).toList();
//   }

//   // ---------------------------------------------------------------------------
//   // MONTH FILTER
//   // ---------------------------------------------------------------------------
//   Widget _buildListMonthFilter(BuildContext context) {
//     final cardColor = Theme.of(context).cardColor;
//     final primaryColor = Theme.of(context).primaryColor;

//     final months = <DateTime?>[null];
//     final now = DateTime.now();
//     for (int i = 0; i < 12; i++) {
//       months.add(DateTime(now.year, now.month - i, 1));
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.grey.withOpacity(0.2)),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<DateTime?>(
//           value: _listMonthFilter,
//           icon: Icon(Icons.calendar_month_rounded,
//               size: 18, color: primaryColor),
//           onChanged: (val) =>
//               setState(() => _listMonthFilter = val),
//           items: months
//               .map((m) => DropdownMenuItem(
//                     value: m,
//                     child: Text(
//                         m == null ? "All Time" : DateFormat('MMM yyyy').format(m)),
//                   ))
//               .toList(),
//         ),
//       ),
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // CATEGORY FILTER
//   // ---------------------------------------------------------------------------
//   Widget _buildCategoryFilter(BuildContext context) {
//     final cardColor = Theme.of(context).cardColor;
//     final primaryColor = Theme.of(context).primaryColor;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.grey.withOpacity(0.2)),
//       ),
//       child: StreamBuilder<List<Tag>>(
//         stream: database.watchAllTags(),
//         builder: (_, snap) {
//           final tags = snap.data ?? [];
//           final items = ["All", ...tags.map((e) => e.name)];

//           return DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: _selectedCategoryFilter,
//               icon: Icon(Icons.filter_list_rounded,
//                   size: 18, color: primaryColor),
//               onChanged: (val) =>
//                   setState(() => _selectedCategoryFilter = val!),
//               items: items
//                   .map((e) => DropdownMenuItem(
//                         value: e,
//                         child: Row(
//                           children: [
//                             if (e != "All") ...[
//                               CategoryStyleHelper.getTagIcon(e, size: 16),
//                               const SizedBox(width: 6),
//                             ],
//                             Text(e),
//                           ],
//                         ),
//                       ))
//                   .toList(),
//             ),
//           );
//         },
//       ),
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

  // ✅ FIX 1: Make this Nullable (DateTime?) to support "All Time"
  DateTime? _dashboardMonth = DateTime.now();

  // List filters
  DateTime? _listMonthFilter;
  String _selectedCategoryFilter = "All";

  final HomeViewModel _viewModel = HomeViewModel();

  // ✅ FIX 2: Store the stream here so it doesn't reload on every click
  late Stream<List<Expense>> _expensesStream;

  @override
  void initState() {
    super.initState();
    // ✅ FIX 2: Initialize ONLY ONCE. This stops the "Loading..." flash.
    _expensesStream = database.watchAllExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final pages = [_buildHomeTab(context), const SettingsScreen()];

    return Scaffold(

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
    foregroundColor: MaterialStateProperty.resolveWith((states) {
      if (_currentIndex == 0) {
        return Theme.of(context).colorScheme.primary; // GREEN always
      }
      return Colors.grey;
    }),
    overlayColor: MaterialStateProperty.all(Colors.transparent),
  ),
  icon: const Icon(Icons.home_rounded),
  onPressed: () => setState(() => _currentIndex = 0),
),
            const SizedBox(width: 30),
           IconButton(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith((states) {
      if (_currentIndex == 1) {
        return Theme.of(context).colorScheme.primary; // GREEN always
      }
      return Colors.grey;
    }),
    overlayColor: MaterialStateProperty.all(Colors.transparent),
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
final Color subTextColor =
    isDark ? Colors.grey.shade400 : Colors.grey.shade600;
final Color chipTextColor =
    isDark ? Colors.white : Colors.grey.shade700;
final Color chipBgColor =
    isDark ? Colors.grey.shade800 : Colors.grey.shade100;
    // final primaryColor = Theme.of(context).primaryColor;
    // final textColor = Theme.of(context).colorScheme.onSurface;
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

      // ✅ FIX 2: Use the pre-initialized stream. No more reloading spinner!
      body: StreamBuilder<List<Expense>>(
        stream: _expensesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          final allExpenses = snapshot.data ?? [];

          // ---------------------------------------------------
          // 🧠 FILTER LOGIC (IN MEMORY - INSTANT)
          // ---------------------------------------------------

          // 1. Dashboard Logic
          _viewModel.calculateStats(allExpenses, _dashboardMonth);

          // 2. List Logic
          final listExpenses = allExpenses.where((e) {
            // Category Filter
            if (_selectedCategoryFilter != "All" &&
                e.category != _selectedCategoryFilter) {
              return false;
            }
            // Month Filter
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
              // ---------------- DASHBOARD ----------------
              SliverToBoxAdapter(
                child: DashboardCard(
                  viewModel: _viewModel,
                  selectedDate: _dashboardMonth,
                  // ✅ FIX 1: Removed '!' check. Now accepts null for All Time.
                  onDateChanged: (date) {
                    setState(() => _dashboardMonth = date);
                  },
                ),
              ),

              // ---------------- FILTERS ----------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Transactions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildListMonthFilter(context),
                            const SizedBox(width: 100),
                            _buildCategoryFilter(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ---------------- TRANSACTIONS LIST ----------------
              listExpenses.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            "No transactions found",
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
                              MaterialPageRoute(
                                builder: (_) => ExpenseDetailScreen(expense: e),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                // Leading
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDark
                                        ? Colors.grey[800]
                                        : Colors.grey[100],
                                    image: e.imagePath != null
                                        ? DecorationImage(
                                            image: FileImage(
                                              File(e.imagePath!),
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: e.imagePath == null
                                      ? Icon(
                                          Icons.receipt_outlined,
                                          color: primaryColor,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 16),

                                // Middle
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.merchant,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
                                      ),
                                      Text(
                                        DateFormat(
                                          'MMM d, yyyy',
                                        ).format(e.date),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Right
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.grey[800]
                                            : Colors.grey[100],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          CategoryStyleHelper.getTagIcon(
                                            e.category,
                                            size: 12,
                                          ),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
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

  // ---------------------------------------------------------------------------
  // MONTH FILTER FOR LIST
  // ---------------------------------------------------------------------------
  Widget _buildListMonthFilter(BuildContext context) {

final Color textColor = Theme.of(context).colorScheme.onSurface;

    final cardColor = Theme.of(context).cardColor;
    final iconColor = Theme.of(context).colorScheme.onSurface;
  

    final months = <DateTime?>[null];
    final now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      months.add(DateTime(now.year, now.month - i, 1));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DateTime?>(
          value: _listMonthFilter,
          icon: Icon(
            Icons.calendar_month_rounded,
            size: 18,
            color: iconColor,
          ),
          onChanged: (val) => setState(() => _listMonthFilter = val),
          items: months
              .map(
                (m) => DropdownMenuItem(
                  value: m,
                  child: Text(
  m == null ? "All Time" : DateFormat('MMM yyyy').format(m),
  style: TextStyle(color: textColor),
),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CATEGORY FILTER FOR LIST
  // ---------------------------------------------------------------------------
  Widget _buildCategoryFilter(BuildContext context) {


    final cardColor = Theme.of(context).cardColor;
   
    final iconColor = Theme.of(context).colorScheme.onSurface;


    

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: StreamBuilder<List<Tag>>(
        
        stream: database.watchAllTags(),
        builder: (_, snap) {
          
          final tags = snap.data ?? [];
          final items = ["All", ...tags.map((e) => e.name)];

          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              menuMaxHeight: 350,
              borderRadius: BorderRadius.circular(20),
              value: _selectedCategoryFilter,
              icon: Icon(
                Icons.filter_list_rounded,
                size: 18,
                color: iconColor,
              ),
              onChanged: (val) =>
                  setState(() => _selectedCategoryFilter = val!),
              items: items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Row(
                        children: [
                          if (e != "All") ...[
                            CategoryStyleHelper.getTagIcon(e, size: 16),
                            const SizedBox(width: 6),
                          ],
                          Text(e),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
