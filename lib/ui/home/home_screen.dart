import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Internal App Imports
import '../../data/local/database.dart';
import '../../data/auth/auth_service.dart';
import '../add_expense/screen/add_expense_screen.dart';
import '../home/viewmodel/home_view_model.dart';
import '../home/widget/dashboard_card.dart';
import '../settings/screen/setting_screen.dart'; // Ensure filename matches exactly
import '../settings/view_model/setting_view_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Navigation State
  int _currentIndex = 0;
  
  // Filter State
  String _selectedFilterTag = "All"; 
  
  // ViewModel
  final HomeViewModel _viewModel = HomeViewModel(); 

  @override
  Widget build(BuildContext context) {
    // Theme Colors
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Pages: 0 = Dashboard, 1 = Settings
    final List<Widget> pages = [
      _buildHomeTab(context),
      const SettingsScreen(), 
    ];

    return Scaffold(
      // ✅ Switch Body based on Tab
      body: pages[_currentIndex], 

      // ✅ FAB - Scan Bill
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
      
      // ✅ Bottom Navigation Bar
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
                icon: Icon(Icons.home_rounded, color: _currentIndex == 0 ? isDark ? Colors.white : Colors.black : Colors.grey),
                onPressed: () => setState(() => _currentIndex = 0),
              ),
              const SizedBox(width: 30), // Gap for FAB
              IconButton(
                icon: Icon(Icons.settings_rounded, color: _currentIndex == 1 ? isDark ? Colors.white : Colors.black : Colors.grey),
                onPressed: () => setState(() => _currentIndex = 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // 🏠 HOME TAB (Dashboard + Filters + List)
  // ---------------------------------------------------
  Widget _buildHomeTab(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
      ? Colors.black
      : Colors.white,
      // AppBar with Username Logic
      appBar: AppBar(
        toolbarHeight: 80,
        title: user == null 
          ? const Text("Dashboard") 
          : FutureBuilder<UserProfile?>(
              future: database.getUserProfile(user.uid),
              builder: (context, snapshot) {
                // Logic: DB Name -> Google Name -> "User"
                final name = snapshot.data?.name ?? user.displayName ?? "User";
                final firstName = name.split(" ")[0]; // Just the first name

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, $firstName 👋",
                      style: TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      "Here is your spending summary",
                      style: TextStyle(
                        fontSize: 14, 
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  ],
                );
              },
            ),
      ),

      // Main Content
      body: StreamBuilder<List<Expense>>(
        // Watch expenses based on selected filter
        stream: database.watchExpenses(filterTag: _selectedFilterTag == "All" ? null : _selectedFilterTag),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
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
                      
                      // Filter Dropdown Widget
                      _buildFilterDropdown(context),
                    ],
                  ),
                ),
              ),

              // 3. TRANSACTIONS LIST
              expenses.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50), 
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.receipt_long, size: 60, color: Colors.grey.withOpacity(0.3)),
                              const SizedBox(height: 10),
                              const Text("No transactions found", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final expense = expenses[index];
                          return Dismissible(
                            key: Key(expense.id.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              database.deleteExpense(expense.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Expense deleted"))
                              );
                            },
                            background: Container(
                              color: Colors.redAccent, 
                              alignment: Alignment.centerRight, 
                              padding: const EdgeInsets.only(right: 20), 
                              child: const Icon(Icons.delete, color: Colors.white)
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: primaryColor.withOpacity(0.1),
                                backgroundImage: expense.imagePath != null ? FileImage(File(expense.imagePath!)) : null,
                                child: expense.imagePath == null ? Icon(Icons.receipt, color: primaryColor) : null,
                              ),
                              title: Text(expense.merchant, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(DateFormat('MMM d, y').format(expense.date)),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "$currency${expense.amount.toStringAsFixed(2)}", 
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor)
                                  ),
                                  Text(
                                    expense.category, 
                                    style: const TextStyle(fontSize: 12, color: Colors.grey)
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: expenses.length,
                      ),
                    ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 80)), // Bottom padding
            ],
          );
        },
      ),
    );
  }

  // ---------------------------------------------------
  // 🔽 HELPER WIDGET: Filter Dropdown
  // ---------------------------------------------------
  Widget _buildFilterDropdown(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).primaryColor;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey.shade200;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
        ],
        border: Border.all(color: borderColor),
      ),
      child: StreamBuilder<List<Tag>>(
        stream: database.watchAllTags(),
        builder: (context, snapshot) {
          final tags = snapshot.data ?? [];
          
          // Create list: ["All", "Grocery", "Rent", ...]
          final filterOptions = ["All", ...tags.map((e) => e.name)];

          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: filterOptions.contains(_selectedFilterTag) ? _selectedFilterTag : "All",
              dropdownColor: cardColor,
              borderRadius: BorderRadius.circular(20),
              icon: Icon(Icons.filter_list_rounded, color: primaryColor, size: 20),
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 13),
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
                        // Small colored dot for categories
                        Container(
                          width: 8, height: 8,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.7),
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