// import 'dart:io';
// import 'package:bill_buddy/data/remote/groq_service.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';


// class AddExpenseViewModel extends ChangeNotifier {
//   // State Variables
//   File? selectedImage;
//   bool isLoading = false;
//   List<Map<String, dynamic>> items = [];
  
//   // Text Controllers (Managed here to keep View clean)
//   final merchantController = TextEditingController();
//   final dateController = TextEditingController();
//   final totalController = TextEditingController();
//   final taxController = TextEditingController();

//   // 📸 Pick Image & Scan
//   Future<void> pickImage(ImageSource source, BuildContext context) async {
//     try {
//       final picker = ImagePicker();
//       final XFile? photo = await picker.pickImage(source: source, imageQuality: 60);

//       if (photo == null) return;

//       selectedImage = File(photo.path);
//       isLoading = true;
//       items.clear(); // Reset items
//       notifyListeners(); // Update UI to show loading

//       // Call AI Service
//       final BillData? data = await GroqService.scanReceipt(selectedImage!);

//       isLoading = false;

//       if (data != null) {
//         merchantController.text = data.merchant;
//         dateController.text = data.date;
//         totalController.text = data.total;
//         taxController.text = data.tax;
//         items = List.from(data.items); // Copy list
        
//         _showSnack(context, "✨ Receipt Analyzed!", isError: false);
//       } else {
//         _showSnack(context, "⚠️ Could not read receipt. Enter manually.", isError: true);
//       }
//     } catch (e) {
//       isLoading = false;
//       _showSnack(context, "Error: $e", isError: true);
//     }
//     notifyListeners();
//   }

//   // 📅 Date Picker Logic
//   Future<void> selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(primary: Color(0xFF6C63FF)),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       dateController.text = DateFormat('yyyy-MM-dd').format(picked);
//       notifyListeners();
//     }
//   }

//   // ➕ Add Manual Item
//   void addItem() {
//     items.add({"name": "New Item", "price": 0.00});
//     notifyListeners();
//   }

//   // 🗑️ Remove Item
//   void removeItem(int index) {
//     items.removeAt(index);
//     notifyListeners();
//   }

//   // 📝 Update Item Field
//   void updateItem(int index, String key, dynamic value) {
//     items[index][key] = value;
//     // We don't necessarily need to notifyListeners for text input to prevent lag, 
//     // but if you have totals calculation, you might want to.
//   }

//   void _showSnack(BuildContext context, String msg, {required bool isError}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: isError ? Colors.redAccent : Colors.green,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }
  
//   @override
//   void dispose() {
//     merchantController.dispose();
//     dateController.dispose();
//     totalController.dispose();
//     taxController.dispose();
//     super.dispose();
//   }
// }


// import 'dart:io';
// import 'package:bill_buddy/data/local/database.dart';
// import 'package:bill_buddy/data/remote/groq_service.dart';
// import 'package:flutter/material.dart';
// import 'package:drift/drift.dart' as drift; // Alias to avoid conflicts
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';


// class AddExpenseViewModel extends ChangeNotifier {
//   // ==========================================
//   // 1. STATE VARIABLES
//   // ==========================================
//   File? selectedImage;
//   bool isLoading = false;
//   List<Map<String, dynamic>> items = []; // Holds items like {"name": "Milk", "price": 2.50}

//   // ==========================================
//   // 2. TEXT CONTROLLERS
//   // ==========================================
//   final merchantController = TextEditingController();
//   final dateController = TextEditingController();
//   final totalController = TextEditingController();
//   final taxController = TextEditingController();

//   // ==========================================
//   // 3. LOGIC: IMAGE PICKING & AI SCAN
//   // ==========================================
//   Future<void> pickImage(ImageSource source, BuildContext context) async {
//     try {
//       final picker = ImagePicker();
//       // Quality 60 is a sweet spot for AI readability vs upload speed
//       final XFile? photo = await picker.pickImage(source: source, imageQuality: 60);

//       if (photo == null) return;

//       selectedImage = File(photo.path);
//       isLoading = true;
//       items.clear(); // Clear previous items
//       notifyListeners(); 

//       // 🧠 CALL AI SERVICE
//       final BillData? data = await GroqService.scanReceipt(selectedImage!);

//       isLoading = false;

//       if (data != null) {
//         // Auto-fill fields
//         merchantController.text = data.merchant;
//         dateController.text = data.date;
//         totalController.text = data.total;
//         taxController.text = data.tax;
        
//         // Clone items list (so it's editable)
//         items = List.from(data.items); 
        
//         _showSnack(context, "✨ Receipt Analyzed Successfully!", isError: false);
//       } else {
//         _showSnack(context, "⚠️ AI couldn't read receipt. Please enter manually.", isError: true);
//       }
//     } catch (e) {
//       isLoading = false;
//       _showSnack(context, "Error: $e", isError: true);
//     }
//     notifyListeners();
//   }

//   // ==========================================
//   // 4. LOGIC: DATABASE SAVING (The New Part)
//   // ==========================================
//   Future<bool> saveExpense(BuildContext context) async {
//     // A. Validation
//     if (merchantController.text.isEmpty) {
//       _showSnack(context, "Please enter a Merchant Name", isError: true);
//       return false;
//     }
//     if (totalController.text.isEmpty) {
//       _showSnack(context, "Please enter a Total Amount", isError: true);
//       return false;
//     }

//     try {
//       isLoading = true;
//       notifyListeners();

//       // B. Parse Numbers (Safe conversion)
//       final double totalAmount = double.tryParse(totalController.text) ?? 0.0;
//       final double taxAmount = double.tryParse(taxController.text) ?? 0.0;
      
//       // C. Parse Date (Safe conversion)
//       DateTime billDate;
//       if (dateController.text.isNotEmpty) {
//         try {
//           billDate = DateFormat('yyyy-MM-dd').parse(dateController.text);
//         } catch (e) {
//           billDate = DateTime.now(); // Fallback if format is weird
//         }
//       } else {
//         billDate = DateTime.now();
//       }

//       // D. Create Database Entry Object
//       final expenseEntry = ExpensesCompanion(
//         merchant: drift.Value(merchantController.text),
//         amount: drift.Value(totalAmount),
//         tax: drift.Value(taxAmount),
//         date: drift.Value(billDate),
//         category: const drift.Value("General"), // Default category
//         userId: const drift.Value(null), // Nullable for now
//         imagePath: selectedImage != null 
//             ? drift.Value(selectedImage!.path) 
//             : const drift.Value(null),
      
//       );
      

//       // E. Insert Header -> Get ID
//       // 'database' is the global variable we defined in database.dart
//       final int newExpenseId = await database.insertExpense(expenseEntry);

//       // F. Insert Items (if any)
//       if (items.isNotEmpty) {
//         final List<ExpenseItemsCompanion> itemEntries = items.map((item) {
//           return ExpenseItemsCompanion(
//             expenseId: drift.Value(newExpenseId), // Link to parent ID
//             name: drift.Value(item['name'].toString()),
//             amount: drift.Value(double.tryParse(item['price'].toString()) ?? 0.0),
//           );
//         }).toList();

//         await database.insertExpenseItems(itemEntries);
//       }

//       isLoading = false;
//       notifyListeners();
      
//       print("✅ Expense Saved! ID: $newExpenseId");
//       return true; // Return success signal

//     } catch (e) {
//       isLoading = false;
//       notifyListeners();
//       print("❌ Save Error: $e");
//       _showSnack(context, "Database Error: $e", isError: true);
//       return false;
//     }
//   }

//   // ==========================================
//   // 5. HELPER METHODS (Date, List Editing)
//   // ==========================================
  
//   // 📅 Show Date Picker
//   Future<void> selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(primary: Color(0xFF6C63FF)),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       dateController.text = DateFormat('yyyy-MM-dd').format(picked);
//       notifyListeners();
//     }
//   }

//   // ➕ Add empty item row
//   void addItem() {
//     items.add({"name": "", "price": 0.00});
//     notifyListeners();
//   }

//   // 🗑️ Remove item row
//   void removeItem(int index) {
//     items.removeAt(index);
//     notifyListeners();
//   }

//   // 📝 Update item data when user types
//   void updateItem(int index, String key, dynamic value) {
//     items[index][key] = value;
//     // Note: We don't call notifyListeners() here to prevent keyboard lag while typing
//   }

//   // 🔔 SnackBar Helper
//   void _showSnack(BuildContext context, String msg, {required bool isError}) {
//     if (!context.mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: isError ? Colors.redAccent : Colors.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
  
//   // 🧹 Clean up controllers
//   @override
//   void dispose() {
//     merchantController.dispose();
//     dateController.dispose();
//     totalController.dispose();
//     taxController.dispose();
//     super.dispose();
//   }
// }

import 'dart:io';
import 'package:bill_buddy/data/local/database.dart';
import 'package:bill_buddy/data/remote/groq_service.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift; 
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class AddExpenseViewModel extends ChangeNotifier {
  // State
  File? selectedImage;
  bool isLoading = false;
  List<Map<String, dynamic>> items = [];
  
  // ✅ NEW: Selected Category (Default)
  String selectedCategory = "General"; 

  // Controllers
  final merchantController = TextEditingController();
  final dateController = TextEditingController();
  final totalController = TextEditingController();
  final taxController = TextEditingController();

  // 1. Pick Image & Scan
  Future<void> pickImage(ImageSource source, BuildContext context) async {
    try {
      final picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: source, imageQuality: 60);

      if (photo == null) return;

      selectedImage = File(photo.path);
      isLoading = true;
      items.clear();
      notifyListeners(); 

      final BillData? data = await GroqService.scanReceipt(selectedImage!);

      isLoading = false;

      if (data != null) {
        merchantController.text = data.merchant;
        dateController.text = data.date;
        totalController.text = data.total;
        taxController.text = data.tax;
        items = List.from(data.items); 
        _showSnack(context, "✨ Receipt Analyzed!", isError: false);
      } else {
        _showSnack(context, "⚠️ Could not read receipt.", isError: true);
      }
    } catch (e) {
      isLoading = false;
      _showSnack(context, "Error: $e", isError: true);
    }
    notifyListeners();
  }

  // 2. Save Expense
  Future<bool> saveExpense(BuildContext context) async {
    if (merchantController.text.isEmpty || totalController.text.isEmpty) {
      _showSnack(context, "Please enter Merchant and Total", isError: true);
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

      final double totalAmount = double.tryParse(totalController.text) ?? 0.0;
      final double taxAmount = double.tryParse(taxController.text) ?? 0.0;
      
      DateTime billDate;
      try {
        billDate = DateFormat('yyyy-MM-dd').parse(dateController.text);
      } catch (e) {
        billDate = DateTime.now();
      }

      final expenseEntry = ExpensesCompanion(
        merchant: drift.Value(merchantController.text),
        amount: drift.Value(totalAmount),
        tax: drift.Value(taxAmount),
        date: drift.Value(billDate),
        userId: const drift.Value(null),
        imagePath: selectedImage != null ? drift.Value(selectedImage!.path) : const drift.Value(null),
        
        // ✅ SAVE SELECTED TAG
        category: drift.Value(selectedCategory), 
      );

      final int newExpenseId = await database.insertExpense(expenseEntry);

      if (items.isNotEmpty) {
        final List<ExpenseItemsCompanion> itemEntries = items.map((item) {
          return ExpenseItemsCompanion(
            expenseId: drift.Value(newExpenseId),
            name: drift.Value(item['name'].toString()),
            amount: drift.Value(double.tryParse(item['price'].toString()) ?? 0.0),
          );
        }).toList();
        await database.insertExpenseItems(itemEntries);
      }

      isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      isLoading = false;
      notifyListeners();
      _showSnack(context, "Error: $e", isError: true);
      return false;
    }
  }

  // Helpers
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  void addItem() {
    items.add({"name": "", "price": 0.00});
    notifyListeners();
  }

  void removeItem(int index) {
    items.removeAt(index);
    notifyListeners();
  }

  void updateItem(int index, String key, dynamic value) {
    items[index][key] = value;
  }

  void _showSnack(BuildContext context, String msg, {required bool isError}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: isError ? Colors.red : Colors.green));
  }
}