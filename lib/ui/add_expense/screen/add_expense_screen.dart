// // import 'dart:io';
// // import 'package:bill_buddy/data/auth/auth_service.dart';
// // import 'package:bill_buddy/data/local/database.dart';
// // import 'package:bill_buddy/util/heuristic_parser.dart';
// // import 'package:bill_buddy/util/recipt_logic.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:drift/drift.dart' as drift;
// // import 'package:intl/intl.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// // class AddExpenseScreen extends StatefulWidget {
// //   const AddExpenseScreen({super.key});

// //   @override
// //   State<AddExpenseScreen> createState() => _AddExpenseScreenState();
// // }

// // class _AddExpenseScreenState extends State<AddExpenseScreen> {
// //   final _formKey = GlobalKey<FormState>();
  
// //   // Controllers
// //   final _merchantController = TextEditingController();
// //   final _dateController = TextEditingController();
// //   final _taxController = TextEditingController();
// //   final _totalController = TextEditingController(); 
// //   final _categoryController = TextEditingController();
  
// //   // State
// //   File? _receiptImage;
// //   List<ReceiptItem> _items = []; 
// //   bool _isLoading = false;
// //   double _confidence = 0.0;
// //   List<String> _warnings = [];

// //   @override
// //   void dispose() {
// //     _merchantController.dispose();
// //     _dateController.dispose();
// //     _taxController.dispose();
// //     _totalController.dispose();
// //     _categoryController.dispose();
// //     super.dispose();
// //   }

// //   // --- SCANNING LOGIC ---
// //   Future<void> _scanReceipt() async {
// //     final picker = ImagePicker();
// //     // 100% Quality is crucial for OCR parsing
// //     final XFile? photo = await picker.pickImage(
// //       source: ImageSource.camera, 
// //       imageQuality: 100
// //     );
    
// //     if (photo == null) return;

// //     setState(() {
// //       _isLoading = true;
// //       _receiptImage = File(photo.path); 
// //     });

// //     try {
// //       // 1. ML Kit OCR (Offline Text Recognition)
// //       final inputImage = InputImage.fromFilePath(photo.path);
// //       final textRecognizer = TextRecognizer();
// //       final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
// //       await textRecognizer.close();

// //       if (recognizedText.text.isEmpty) {
// //         throw Exception("No text detected in image. Try again with better lighting.");
// //       }

// //       // 2. Parse with Improved Heuristic Logic
// //       ParseResult result = ImprovedReceiptParser.parse(recognizedText.text);
// //       ReceiptData data = result.data;

// //       // 3. Update UI with parsed data
// //       setState(() {
// //         // Basic Info
// //         _merchantController.text = data.merchant;
// //         _categoryController.text = data.category;
        
// //         // Date
// //         if (data.date != null) {
// //           _dateController.text = DateFormat('yyyy-MM-dd').format(data.date!);
// //         } else {
// //           _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
// //         }
        
// //         // Tax
// //         _taxController.text = data.taxAmount.toStringAsFixed(2);
        
// //         // Items
// //         _items = List.from(data.items); // Create a copy
        
// //         // Fallback: If no items detected but total exists
// //         if (_items.isEmpty && data.totalAmount > 0) {
// //           _items.add(ReceiptItem("Total Bill Amount", data.totalAmount));
// //         }

// //         // Store metadata
// //         _confidence = result.confidence;
// //         _warnings = result.warnings;

// //         // Calculate total
// //         _updateTotal(); 
// //       });

// //       // Show appropriate feedback
// //       if (mounted) {
// //         _showScanFeedback(result.confidence, result.warnings);
// //       }

// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text("Scan Error: ${e.toString()}"),
// //             backgroundColor: Colors.red,
// //             duration: const Duration(seconds: 4),
// //           )
// //         );
// //       }
// //     } finally {
// //       if (mounted) setState(() => _isLoading = false);
// //     }
// //   }

// //   void _showScanFeedback(double confidence, List<String> warnings) {
// //     String message;
// //     Color bgColor;
// //     IconData icon;

// //     if (confidence >= 0.8) {
// //       message = "✅ Receipt scanned successfully!";
// //       bgColor = Colors.green;
// //       icon = Icons.check_circle;
// //     } else if (confidence >= 0.6) {
// //       message = "⚠️ Scan complete. Please verify all details.";
// //       bgColor = Colors.orange;
// //       icon = Icons.warning;
// //     } else {
// //       message = "⚠️ Low confidence scan. Please check and correct the data.";
// //       bgColor = Colors.deepOrange;
// //       icon = Icons.error_outline;
// //     }

// //     // Show main message
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Row(
// //           children: [
// //             Icon(icon, color: Colors.white),
// //             const SizedBox(width: 8),
// //             Expanded(child: Text(message)),
// //           ],
// //         ),
// //         backgroundColor: bgColor,
// //         duration: const Duration(seconds: 3),
// //         action: warnings.isNotEmpty 
// //           ? SnackBarAction(
// //               label: "Details",
// //               textColor: Colors.white,
// //               onPressed: () => _showWarningsDialog(),
// //             )
// //           : null,
// //       )
// //     );
// //   }

// //   void _showWarningsDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Row(
// //           children: [
// //             Icon(Icons.info_outline, color: Colors.orange.shade700),
// //             const SizedBox(width: 8),
// //             const Text("Scan Warnings"),
// //           ],
// //         ),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               "Confidence: ${(_confidence * 100).toStringAsFixed(0)}%",
// //               style: const TextStyle(fontWeight: FontWeight.bold),
// //             ),
// //             const Divider(),
// //             ..._warnings.map((w) => Padding(
// //               padding: const EdgeInsets.symmetric(vertical: 4),
// //               child: Row(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   const Text("• ", style: TextStyle(fontSize: 16)),
// //                   Expanded(child: Text(w)),
// //                 ],
// //               ),
// //             )),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text("OK"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Recalculate Grand Total
// //   void _updateTotal() {
// //     double itemTotal = _items.fold(0.0, (sum, item) => sum + item.amount);
// //     double tax = double.tryParse(_taxController.text) ?? 0.0;
// //     _totalController.text = (itemTotal + tax).toStringAsFixed(2);
// //   }

// //   void _addItem() {
// //     setState(() {
// //       _items.add(ReceiptItem("", 0.0));
// //     });
// //   }

// //   // --- SAVE TO DATABASE ---
// //   void _saveExpense() async {
// //     if (!_formKey.currentState!.validate()) return;
    
// //     // Validate items
// //     if (_items.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Please add at least one item"))
// //       );
// //       return;
// //     }

// //     final db = Provider.of<AppDatabase>(context, listen: false);
// //     final auth = Provider.of<AuthService>(context, listen: false);
// //     final user = auth.currentUser;
    
// //     if (user == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Please login first"))
// //       );
// //       return;
// //     }

// //     setState(() => _isLoading = true);

// //     try {
// //       // 1. Insert Expense Header
// //       final expenseId = await db.insertExpense(
// //         ExpensesCompanion(
// //           userId: drift.Value(user.uid),
// //           merchant: drift.Value(_merchantController.text.trim()),
// //           amount: drift.Value(double.tryParse(_totalController.text) ?? 0.0),
// //           tax: drift.Value(double.tryParse(_taxController.text) ?? 0.0),
// //           category: drift.Value(_categoryController.text.isNotEmpty 
// //               ? _categoryController.text 
// //               : "General"
// //           ), 
// //           date: drift.Value(DateTime.tryParse(_dateController.text) ?? DateTime.now()),
// //         ),
// //       );

// //       // 2. Insert Line Items
// //       final validItems = _items.where((item) => 
// //         item.description.trim().isNotEmpty && item.amount > 0
// //       ).toList();

// //       if (validItems.isNotEmpty) {
// //         final expenseItems = validItems.map((item) => ExpenseItemsCompanion(
// //           expenseId: drift.Value(expenseId),
// //           name: drift.Value(item.description.trim()),
// //           amount: drift.Value(item.amount),
// //         )).toList();

// //         await db.insertExpenseItems(expenseItems);
// //       }

// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text("✅ Bill saved successfully!"),
// //             backgroundColor: Colors.green,
// //           )
// //         );
// //         Navigator.pop(context);
// //       }

// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text("Save Error: $e"),
// //             backgroundColor: Colors.red,
// //           )
// //         );
// //       }
// //     } finally {
// //       if (mounted) setState(() => _isLoading = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("New Bill"),
// //         actions: [
// //           IconButton(
// //             onPressed: _isLoading ? null : _scanReceipt,
// //             icon: const Icon(Icons.camera_alt),
// //             tooltip: "Scan Receipt",
// //           ),
// //           if (_warnings.isNotEmpty)
// //             IconButton(
// //               onPressed: _showWarningsDialog,
// //               icon: Badge(
// //                 label: Text(_warnings.length.toString()),
// //                 child: const Icon(Icons.info_outline),
// //               ),
// //               tooltip: "View Warnings",
// //             ),
// //         ],
// //       ),
// //       body: _isLoading 
// //         ? const Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 CircularProgressIndicator(),
// //                 SizedBox(height: 16),
// //                 Text("Processing receipt...", style: TextStyle(color: Colors.grey)),
// //               ],
// //             ),
// //           )
// //         : Column(
// //           children: [
// //             // --- IMAGE VIEWER ---
// //             if (_receiptImage != null)
// //               Container(
// //                 height: 200, 
// //                 width: double.infinity,
// //                 decoration: BoxDecoration(
// //                   color: Colors.black87,
// //                   border: Border(
// //                     bottom: BorderSide(color: Colors.grey.shade300),
// //                   ),
// //                 ),
// //                 child: Stack(
// //                   children: [
// //                     InteractiveViewer(
// //                       minScale: 1.0, 
// //                       maxScale: 4.0,
// //                       child: Center(
// //                         child: Image.file(_receiptImage!, fit: BoxFit.contain),
// //                       ),
// //                     ),
// //                     // Confidence Badge
// //                     if (_confidence > 0)
// //                       Positioned(
// //                         top: 8,
// //                         right: 8,
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                           decoration: BoxDecoration(
// //                             color: _confidence >= 0.7 
// //                               ? Colors.green 
// //                               : _confidence >= 0.5 
// //                                 ? Colors.orange 
// //                                 : Colors.red,
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Text(
// //                             "${(_confidence * 100).toStringAsFixed(0)}%",
// //                             style: const TextStyle(
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.bold,
// //                               fontSize: 12,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                   ],
// //                 ),
// //               )
// //             else
// //               Container(
// //                 height: 120,
// //                 color: Colors.grey.shade100,
// //                 alignment: Alignment.center,
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Icon(Icons.receipt_long, size: 48, color: Colors.grey.shade400),
// //                     const SizedBox(height: 8),
// //                     TextButton.icon(
// //                       onPressed: _scanReceipt, 
// //                       icon: const Icon(Icons.camera_alt), 
// //                       label: const Text("Tap to Scan Receipt"),
// //                       style: TextButton.styleFrom(
// //                         foregroundColor: Colors.deepPurple,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //             // --- FORM FIELDS ---
// //             Expanded(
// //               child: SingleChildScrollView(
// //                 padding: const EdgeInsets.all(16),
// //                 child: Form(
// //                   key: _formKey,
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.stretch,
// //                     children: [
// //                       // Merchant
// //                       TextFormField(
// //                         controller: _merchantController,
// //                         decoration: const InputDecoration(
// //                           labelText: "Merchant *", 
// //                           border: OutlineInputBorder(),
// //                           prefixIcon: Icon(Icons.store),
// //                         ),
// //                         validator: (v) => v == null || v.trim().isEmpty 
// //                           ? "Merchant name is required" 
// //                           : null,
// //                       ),
// //                       const SizedBox(height: 12),
                      
// //                       // Date & Category
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: TextFormField(
// //                               controller: _dateController,
// //                               decoration: const InputDecoration(
// //                                 labelText: "Date *", 
// //                                 border: OutlineInputBorder(), 
// //                                 suffixIcon: Icon(Icons.calendar_today),
// //                               ),
// //                               readOnly: true,
// //                               onTap: () async {
// //                                 DateTime? picked = await showDatePicker(
// //                                   context: context, 
// //                                   initialDate: DateTime.tryParse(_dateController.text) ?? DateTime.now(),
// //                                   firstDate: DateTime(2000), 
// //                                   lastDate: DateTime.now().add(const Duration(days: 1)),
// //                                 );
// //                                 if (picked != null) {
// //                                   _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
// //                                 }
// //                               },
// //                               validator: (v) => v == null || v.isEmpty 
// //                                 ? "Date is required" 
// //                                 : null,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 8),
// //                           Expanded(
// //                             child: TextFormField(
// //                               controller: _categoryController,
// //                               decoration: const InputDecoration(
// //                                 labelText: "Category", 
// //                                 border: OutlineInputBorder(),
// //                                 prefixIcon: Icon(Icons.category),
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 12),

// //                       // Tax
// //                       TextFormField(
// //                         controller: _taxController,
// //                         decoration: const InputDecoration(
// //                           labelText: "Tax/GST", 
// //                           border: OutlineInputBorder(),
// //                           prefixIcon: Icon(Icons.receipt),
// //                           prefixText: "₹ ",
// //                         ),
// //                         keyboardType: const TextInputType.numberWithOptions(decimal: true),
// //                         onChanged: (_) => setState(() => _updateTotal()),
// //                       ),
                      
// //                       const SizedBox(height: 24),

// //                       // Items Section Header
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Row(
// //                             children: [
// //                               const Icon(Icons.list_alt, size: 20),
// //                               const SizedBox(width: 8),
// //                               const Text(
// //                                 "Items Breakdown", 
// //                                 style: TextStyle(
// //                                   fontWeight: FontWeight.bold, 
// //                                   fontSize: 16,
// //                                 ),
// //                               ),
// //                               if (_items.isNotEmpty)
// //                                 Container(
// //                                   margin: const EdgeInsets.only(left: 8),
// //                                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.deepPurple.shade100,
// //                                     borderRadius: BorderRadius.circular(10),
// //                                   ),
// //                                   child: Text(
// //                                     "${_items.length}",
// //                                     style: TextStyle(
// //                                       fontSize: 12,
// //                                       fontWeight: FontWeight.bold,
// //                                       color: Colors.deepPurple.shade700,
// //                                     ),
// //                                   ),
// //                                 ),
// //                             ],
// //                           ),
// //                           ElevatedButton.icon(
// //                             onPressed: _addItem, 
// //                             icon: const Icon(Icons.add, size: 16),
// //                             label: const Text("Add"),
// //                             style: ElevatedButton.styleFrom(
// //                               visualDensity: VisualDensity.compact,
// //                               backgroundColor: Colors.deepPurple,
// //                               foregroundColor: Colors.white,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const Divider(height: 24),

// //                       // Items List
// //                       if (_items.isEmpty) 
// //                         Container(
// //                           padding: const EdgeInsets.all(24),
// //                           alignment: Alignment.center,
// //                           child: Column(
// //                             children: [
// //                               Icon(Icons.inbox, size: 48, color: Colors.grey.shade300),
// //                               const SizedBox(height: 8),
// //                               const Text(
// //                                 "No items detected",
// //                                 style: TextStyle(color: Colors.grey, fontSize: 14),
// //                               ),
// //                               const SizedBox(height: 4),
// //                               const Text(
// //                                 "Tap 'Add' to add items manually",
// //                                 style: TextStyle(color: Colors.grey, fontSize: 12),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
                      
// //                       ..._items.asMap().entries.map((entry) {
// //                         int index = entry.key;
// //                         ReceiptItem item = entry.value;
// //                         return Card(
// //                           margin: const EdgeInsets.only(bottom: 8),
// //                           elevation: 0,
// //                           color: Colors.grey.shade50,
// //                           child: Padding(
// //                             padding: const EdgeInsets.all(8.0),
// //                             child: Row(
// //                               children: [
// //                                 // Item number badge
// //                                 Container(
// //                                   width: 28,
// //                                   height: 28,
// //                                   alignment: Alignment.center,
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.deepPurple.shade100,
// //                                     shape: BoxShape.circle,
// //                                   ),
// //                                   child: Text(
// //                                     "${index + 1}",
// //                                     style: TextStyle(
// //                                       fontSize: 12,
// //                                       fontWeight: FontWeight.bold,
// //                                       color: Colors.deepPurple.shade700,
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 const SizedBox(width: 8),
// //                                 // Description
// //                                 Expanded(
// //                                   flex: 2,
// //                                   child: TextFormField(
// //                                     key: ValueKey("desc_$index"), 
// //                                     initialValue: item.description,
// //                                     decoration: const InputDecoration(
// //                                       hintText: "Item name",
// //                                       border: OutlineInputBorder(),
// //                                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
// //                                       isDense: true,
// //                                     ),
// //                                     onChanged: (val) => item.description = val,
// //                                   ),
// //                                 ),
// //                                 const SizedBox(width: 8),
// //                                 // Amount
// //                                 Expanded(
// //                                   flex: 1,
// //                                   child: TextFormField(
// //                                     key: ValueKey("amt_$index"),
// //                                     initialValue: item.amount.toStringAsFixed(2),
// //                                     keyboardType: const TextInputType.numberWithOptions(decimal: true),
// //                                     decoration: const InputDecoration(
// //                                       hintText: "0.00",
// //                                       border: OutlineInputBorder(),
// //                                       prefixText: "₹",
// //                                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
// //                                       isDense: true,
// //                                     ),
// //                                     onChanged: (val) {
// //                                       item.amount = double.tryParse(val) ?? 0.0;
// //                                       setState(() => _updateTotal());
// //                                     },
// //                                   ),
// //                                 ),
// //                                 // Delete button
// //                                 IconButton(
// //                                   icon: const Icon(Icons.delete_outline, size: 20),
// //                                   color: Colors.red.shade400,
// //                                   onPressed: () {
// //                                     setState(() {
// //                                       _items.removeAt(index);
// //                                       _updateTotal();
// //                                     });
// //                                   },
// //                                 )
// //                               ],
// //                             ),
// //                           ),
// //                         );
// //                       }),

// //                       const SizedBox(height: 24),
                      
// //                       // Grand Total
// //                       TextFormField(
// //                         controller: _totalController,
// //                         readOnly: true,
// //                         decoration: InputDecoration(
// //                           labelText: "Grand Total", 
// //                           border: const OutlineInputBorder(),
// //                           fillColor: Colors.deepPurple.shade50,
// //                           filled: true,
// //                           prefixText: "₹ ",
// //                           prefixIcon: const Icon(Icons.currency_rupee),
// //                         ),
// //                         style: const TextStyle(
// //                           fontWeight: FontWeight.bold, 
// //                           fontSize: 20,
// //                           color: Colors.deepPurple,
// //                         ),
// //                       ),
                      
// //                       const SizedBox(height: 24),
                      
// //                       // Save Button
// //                       ElevatedButton(
// //                         onPressed: _isLoading ? null : _saveExpense,
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.deepPurple,
// //                           foregroundColor: Colors.white,
// //                           padding: const EdgeInsets.symmetric(vertical: 16),
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                         ),
// //                         child: const Text(
// //                           "SAVE BILL",
// //                           style: TextStyle(
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.bold,
// //                             letterSpacing: 1,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //     );
// //   }
// // }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import '../../../data/remote/groq_service.dart'; // Ensure this path matches your project

// class AddExpenseScreen extends StatefulWidget {
//   const AddExpenseScreen({super.key});

//   @override
//   State<AddExpenseScreen> createState() => _AddExpenseScreenState();
// }

// class _AddExpenseScreenState extends State<AddExpenseScreen> {
//   // Form Key & Controllers
//   final _formKey = GlobalKey<FormState>();
//   final _merchantController = TextEditingController();
//   final _dateController = TextEditingController();
//   final _totalController = TextEditingController();
//   final _taxController = TextEditingController();

//   File? _selectedImage;
//   bool _isLoading = false;
//   List<Map<String, dynamic>> _items = [];

//   // Colors for Modern UI
//   final Color _primaryColor = const Color(0xFF6C63FF); // Modern Indigo
//   final Color _surfaceColor = Colors.white;
//   final Color _backgroundColor = const Color(0xFFF5F7FA);

//   @override
//   void dispose() {
//     _merchantController.dispose();
//     _dateController.dispose();
//     _totalController.dispose();
//     _taxController.dispose();
//     super.dispose();
//   }

//   // 📸 PICK IMAGE (Camera or Gallery)
//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final picker = ImagePicker();
//       final XFile? photo = await picker.pickImage(
//         source: source,
//         imageQuality: 60, // Optimized for AI speed
//       );

//       if (photo == null) return;

//       setState(() {
//         _selectedImage = File(photo.path);
//         _isLoading = true;
//         _items.clear(); // Clear old items
//       });

//       // 🧠 AI MAGIC
//       await _processReceipt();

//     } catch (e) {
//       setState(() => _isLoading = false);
//       _showSnackBar("Failed to pick image: $e", isError: true);
//     }
//   }

//   // 🧠 PROCESS RECEIPT
//   Future<void> _processReceipt() async {
//     if (_selectedImage == null) return;

//     try {
//       final BillData? data = await GroqService.scanReceipt(_selectedImage!);

//       if (!mounted) return;

//       setState(() => _isLoading = false);

//       if (data != null) {
//         setState(() {
//           _merchantController.text = data.merchant;
//           _dateController.text = data.date;
//           _totalController.text = data.total;
//           _taxController.text = data.tax;
//           _items = List.from(data.items); // Clone list to make it editable
//         });
//         _showSnackBar("✨ Receipt Analyzed Successfully!");
//       } else {
//         _showSnackBar("⚠️ AI couldn't read the receipt. Please enter details manually.", isError: true);
//       }
//     } catch (e) {
//       if (mounted) setState(() => _isLoading = false);
//       _showSnackBar("Error analyzing receipt: $e", isError: true);
//     }
//   }

//   // 📅 DATE PICKER
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(primary: _primaryColor),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       setState(() {
//         _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
//       });
//     }
//   }

//   // 🗑️ DELETE ITEM
//   void _removeItem(int index) {
//     setState(() {
//       _items.removeAt(index);
//     });
//   }

//   // ➕ ADD MANUAL ITEM
//   void _addManualItem() {
//     setState(() {
//       _items.add({"name": "New Item", "price": 0.00});
//     });
//   }

//   // 🔔 SNACKBAR HELPER
//   void _showSnackBar(String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.redAccent : Colors.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _backgroundColor,
//       appBar: AppBar(
//         title: const Text("Add Expense", style: TextStyle(fontWeight: FontWeight.w600)),
//         backgroundColor: _backgroundColor,
//         elevation: 0,
//         foregroundColor: Colors.black87,
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           // MAIN SCROLLABLE CONTENT
//           SingleChildScrollView(
//             padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // --- 1. MODERN IMAGE HEADER ---
//                   _buildImageHeader(),
//                   const SizedBox(height: 25),

//                   // --- 2. MAIN DETAILS CARD ---
//                   const Text("Bill Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
//                   const SizedBox(height: 10),
//                   _buildDetailsCard(),
                  
//                   const SizedBox(height: 25),

//                   // --- 3. ITEMS LIST SECTION ---
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text("Items Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
//                       TextButton.icon(
//                         onPressed: _addManualItem,
//                         icon: const Icon(Icons.add_circle_outline, size: 18),
//                         label: const Text("Add Item"),
//                         style: TextButton.styleFrom(foregroundColor: _primaryColor),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   _buildItemsList(),
//                 ],
//               ),
//             ),
//           ),

//           // --- 4. LOADING OVERLAY ---
//           if (_isLoading) _buildLoadingOverlay(),

//           // --- 5. BOTTOM SAVE BUTTON ---
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: _backgroundColor,
//                 boxShadow: [
//                   BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
//                 ],
//               ),
//               child: ElevatedButton(
//                 onPressed: () {
//                   // TODO: Save logic here
//                   if (_formKey.currentState!.validate()) {
//                     _showSnackBar("Expense Saved Successfully!");
//                     Navigator.pop(context);
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _primaryColor,
//                   foregroundColor: Colors.white,
//                   minimumSize: const Size(double.infinity, 55),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                   elevation: 4,
//                   shadowColor: _primaryColor.withOpacity(0.4),
//                 ),
//                 child: const Text("Save Expense", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- WIDGET BUILDERS ---

//   Widget _buildImageHeader() {
//     return Center(
//       child: GestureDetector(
//         onTap: () => _showImagePickerOptions(),
//         child: Container(
//           height: 220,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 8)),
//             ],
//           ),
//           child: _selectedImage != null
//               ? ClipRRect(
//                   borderRadius: BorderRadius.circular(24),
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       Image.file(_selectedImage!, fit: BoxFit.cover),
//                       Container(color: Colors.black12), // Subtle overlay
//                       const Center(
//                         child: Icon(Icons.edit, color: Colors.white70, size: 40),
//                       )
//                     ],
//                   ),
//                 )
//               : Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: _primaryColor.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(Icons.camera_alt_rounded, size: 40, color: _primaryColor),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       "Tap to Scan Receipt",
//                       style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 16),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailsCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: _surfaceColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
//         ],
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           _buildModernTextField(
//             controller: _merchantController,
//             label: "Merchant / Biller",
//             icon: Icons.store_mall_directory_rounded,
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildModernTextField(
//                   controller: _totalController,
//                   label: "Total",
//                   icon: Icons.attach_money_rounded,
//                   isNumber: true,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildModernTextField(
//                   controller: _taxController,
//                   label: "Tax",
//                   icon: Icons.percent_rounded,
//                   isNumber: true,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           GestureDetector(
//             onTap: () => _selectDate(context),
//             child: AbsorbPointer(
//               child: _buildModernTextField(
//                 controller: _dateController,
//                 label: "Date",
//                 icon: Icons.calendar_today_rounded,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildItemsList() {
//     if (_items.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Text("No items detected", style: TextStyle(color: Colors.grey[400])),
//         ),
//       );
//     }

//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: _items.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 8),
//       itemBuilder: (context, index) {
//         final item = _items[index];
//         return Dismissible(
//           key: Key(UniqueKey().toString()),
//           direction: DismissDirection.endToStart,
//           onDismissed: (_) => _removeItem(index),
//           background: Container(
//             alignment: Alignment.centerRight,
//             padding: const EdgeInsets.only(right: 20),
//             decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
//             child: const Icon(Icons.delete_outline, color: Colors.redAccent),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               color: _surfaceColor,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey.withOpacity(0.1)),
//             ),
//             child: ListTile(
//               contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//               leading: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
//                 child: const Icon(Icons.shopping_bag_outlined, size: 20, color: Colors.black54),
//               ),
//               title: TextFormField(
//                 initialValue: item['name'].toString(),
//                 decoration: const InputDecoration(border: InputBorder.none, isDense: true),
//                 style: const TextStyle(fontWeight: FontWeight.w600),
//                 onChanged: (val) => _items[index]['name'] = val,
//               ),
//               trailing: SizedBox(
//                 width: 80,
//                 child: TextFormField(
//                   initialValue: item['price'].toString(),
//                   keyboardType: TextInputType.number,
//                   textAlign: TextAlign.end,
//                   decoration: const InputDecoration(border: InputBorder.none, isDense: true, prefixText: "\$"),
//                   style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
//                   onChanged: (val) => _items[index]['price'] = double.tryParse(val) ?? 0.0,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildModernTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool isNumber = false,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.grey[400], size: 22),
//         filled: true,
//         fillColor: Colors.grey[50],
//         contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _primaryColor, width: 1.5)),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) return '$label is required';
//         return null;
//       },
//     );
//   }

//   Widget _buildLoadingOverlay() {
//     return Container(
//       color: Colors.black.withOpacity(0.5),
//       child: Center(
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(color: _primaryColor),
//               const SizedBox(height: 16),
//               const Text("AI is reading your bill...", style: TextStyle(fontWeight: FontWeight.bold)),
//               const Text("This takes about 2-3 seconds", style: TextStyle(color: Colors.grey, fontSize: 12)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showImagePickerOptions() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text("Select Image Source", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildOptionBtn(Icons.camera_alt, "Camera", () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera);
//                 }),
//                 _buildOptionBtn(Icons.photo_library, "Gallery", () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery);
//                 }),
//               ],
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionBtn(IconData icon, String label, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(color: _primaryColor.withOpacity(0.1), shape: BoxShape.circle),
//             child: Icon(icon, size: 30, color: _primaryColor),
//           ),
//           const SizedBox(height: 8),
//           Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }
// }
import 'package:bill_buddy/data/local/database.dart';
import 'package:bill_buddy/ui/add_expense/view_model/add_expanse_view_model.dart';
import 'package:bill_buddy/ui/add_expense/widget/expense_widget.dart';
import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';


class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final AddExpenseViewModel _viewModel = AddExpenseViewModel();

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: const Text("New Expense"), centerTitle: true),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Header Image
                    ReceiptHeader(
                      imageFile: _viewModel.selectedImage,
                      onTap: () => _showPickerSheet(context),
                    ),
                    const SizedBox(height: 20),

                    // Main Fields
                    ModernTextField(controller: _viewModel.merchantController, label: "Merchant", icon: Icons.store),
                    
                    Row(
                      children: [
                        Expanded(child: ModernTextField(controller: _viewModel.totalController, label: "Total ($currency)", icon: Icons.attach_money, isNumber: true)),
                        const SizedBox(width: 10),
                        Expanded(child: ModernTextField(controller: _viewModel.dateController, label: "Date", icon: Icons.calendar_today, readOnly: true, onTap: () => _viewModel.selectDate(context))),
                      ],
                    ),

                    // ✅ CATEGORY DROPDOWN
                    StreamBuilder<List<Tag>>(
                      stream: database.watchAllTags(), // Fetch tags from DB
                      builder: (context, snapshot) {
                        final tags = snapshot.data ?? [];
                        // Default fallback if DB is empty (shouldn't happen due to migration)
                        if (tags.isEmpty) return const SizedBox.shrink();

                        // Ensure selectedCategory is valid
                        final validCategory = tags.any((t) => t.name == _viewModel.selectedCategory) 
                            ? _viewModel.selectedCategory 
                            : tags.first.name;
                        
                        _viewModel.selectedCategory = validCategory;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(

                           color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _viewModel.selectedCategory,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6C63FF)),
                              items: tags.map((tag) {
                                return DropdownMenuItem(
                                  value: tag.name,
                                  child: Row(
                                    children: [
                                      Icon(Icons.label, size: 16, color: Color(tag.color ?? 0xFF9E9E9E)),
                                      const SizedBox(width: 10),
                                      Text(tag.name),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  // Update ViewModel directly
                                  // (setState needed to refresh just this widget visually immediately)
                                  setState(() => _viewModel.selectedCategory = val);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),

                    // Items List
                    const Align(alignment: Alignment.centerLeft, child: Text("Items", style: TextStyle(fontWeight: FontWeight.bold))),
                    const SizedBox(height: 10),
                    ...List.generate(_viewModel.items.length, (index) {
                      return ExpenseItemRow(
                        item: _viewModel.items[index],
                        onRemove: () => _viewModel.removeItem(index),
                        onNameChanged: (v) => _viewModel.updateItem(index, 'name', v),
                        onPriceChanged: (v) => _viewModel.updateItem(index, 'price', v),
                      );
                    }),
                    
                    TextButton.icon(
                      onPressed: _viewModel.addItem, 
                      icon: const Icon(Icons.add), 
                      label: const Text("Add Manual Item")
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),

              // Save Button
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Theme.of(context).scaffoldBackgroundColor,
                    child: ElevatedButton(
                    onPressed: () async {
                      bool success = await _viewModel.saveExpense(context);
                      if (success && context.mounted) Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006064),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Save Expense"),
                  ),
                ),
              ),

              if (_viewModel.isLoading) 
                Container(color: Colors.black45, child: const Center(child: CircularProgressIndicator())),
            ],
          ),
        );
      },
    );
  }

  void _showPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Wrap(
        children: [
          ListTile(leading: const Icon(Icons.camera), title: const Text("Camera"), onTap: () { Navigator.pop(context); _viewModel.pickImage(ImageSource.camera, context); }),
          ListTile(leading: const Icon(Icons.photo), title: const Text("Gallery"), onTap: () { Navigator.pop(context); _viewModel.pickImage(ImageSource.gallery, context); }),
        ],
      ),
    );
  }
}