import 'dart:io';
import 'package:bill_buddy/data/auth/auth_service.dart';
import 'package:bill_buddy/data/local/database.dart';
import 'package:bill_buddy/util/heuristic_parser.dart';
import 'package:bill_buddy/util/recipt_logic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _merchantController = TextEditingController();
  final _dateController = TextEditingController();
  final _taxController = TextEditingController();
  final _totalController = TextEditingController(); 
  final _categoryController = TextEditingController();
  
  // State
  File? _receiptImage;
  List<ReceiptItem> _items = []; 
  bool _isLoading = false;
  double _confidence = 0.0;
  List<String> _warnings = [];

  @override
  void dispose() {
    _merchantController.dispose();
    _dateController.dispose();
    _taxController.dispose();
    _totalController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // --- SCANNING LOGIC ---
  Future<void> _scanReceipt() async {
    final picker = ImagePicker();
    // 100% Quality is crucial for OCR parsing
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera, 
      imageQuality: 100
    );
    
    if (photo == null) return;

    setState(() {
      _isLoading = true;
      _receiptImage = File(photo.path); 
    });

    try {
      // 1. ML Kit OCR (Offline Text Recognition)
      final inputImage = InputImage.fromFilePath(photo.path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      if (recognizedText.text.isEmpty) {
        throw Exception("No text detected in image. Try again with better lighting.");
      }

      // 2. Parse with Improved Heuristic Logic
      ParseResult result = ImprovedReceiptParser.parse(recognizedText.text);
      ReceiptData data = result.data;

      // 3. Update UI with parsed data
      setState(() {
        // Basic Info
        _merchantController.text = data.merchant;
        _categoryController.text = data.category;
        
        // Date
        if (data.date != null) {
          _dateController.text = DateFormat('yyyy-MM-dd').format(data.date!);
        } else {
          _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
        }
        
        // Tax
        _taxController.text = data.taxAmount.toStringAsFixed(2);
        
        // Items
        _items = List.from(data.items); // Create a copy
        
        // Fallback: If no items detected but total exists
        if (_items.isEmpty && data.totalAmount > 0) {
          _items.add(ReceiptItem("Total Bill Amount", data.totalAmount));
        }

        // Store metadata
        _confidence = result.confidence;
        _warnings = result.warnings;

        // Calculate total
        _updateTotal(); 
      });

      // Show appropriate feedback
      if (mounted) {
        _showScanFeedback(result.confidence, result.warnings);
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Scan Error: ${e.toString()}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          )
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showScanFeedback(double confidence, List<String> warnings) {
    String message;
    Color bgColor;
    IconData icon;

    if (confidence >= 0.8) {
      message = "✅ Receipt scanned successfully!";
      bgColor = Colors.green;
      icon = Icons.check_circle;
    } else if (confidence >= 0.6) {
      message = "⚠️ Scan complete. Please verify all details.";
      bgColor = Colors.orange;
      icon = Icons.warning;
    } else {
      message = "⚠️ Low confidence scan. Please check and correct the data.";
      bgColor = Colors.deepOrange;
      icon = Icons.error_outline;
    }

    // Show main message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 3),
        action: warnings.isNotEmpty 
          ? SnackBarAction(
              label: "Details",
              textColor: Colors.white,
              onPressed: () => _showWarningsDialog(),
            )
          : null,
      )
    );
  }

  void _showWarningsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange.shade700),
            const SizedBox(width: 8),
            const Text("Scan Warnings"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Confidence: ${(_confidence * 100).toStringAsFixed(0)}%",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ..._warnings.map((w) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(w)),
                ],
              ),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Recalculate Grand Total
  void _updateTotal() {
    double itemTotal = _items.fold(0.0, (sum, item) => sum + item.amount);
    double tax = double.tryParse(_taxController.text) ?? 0.0;
    _totalController.text = (itemTotal + tax).toStringAsFixed(2);
  }

  void _addItem() {
    setState(() {
      _items.add(ReceiptItem("", 0.0));
    });
  }

  // --- SAVE TO DATABASE ---
  void _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Validate items
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one item"))
      );
      return;
    }

    final db = Provider.of<AppDatabase>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;
    
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first"))
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Insert Expense Header
      final expenseId = await db.insertExpense(
        ExpensesCompanion(
          userId: drift.Value(user.uid),
          merchant: drift.Value(_merchantController.text.trim()),
          amount: drift.Value(double.tryParse(_totalController.text) ?? 0.0),
          tax: drift.Value(double.tryParse(_taxController.text) ?? 0.0),
          category: drift.Value(_categoryController.text.isNotEmpty 
              ? _categoryController.text 
              : "General"
          ), 
          date: drift.Value(DateTime.tryParse(_dateController.text) ?? DateTime.now()),
        ),
      );

      // 2. Insert Line Items
      final validItems = _items.where((item) => 
        item.description.trim().isNotEmpty && item.amount > 0
      ).toList();

      if (validItems.isNotEmpty) {
        final expenseItems = validItems.map((item) => ExpenseItemsCompanion(
          expenseId: drift.Value(expenseId),
          name: drift.Value(item.description.trim()),
          amount: drift.Value(item.amount),
        )).toList();

        await db.insertExpenseItems(expenseItems);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Bill saved successfully!"),
            backgroundColor: Colors.green,
          )
        );
        Navigator.pop(context);
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Save Error: $e"),
            backgroundColor: Colors.red,
          )
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Bill"),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _scanReceipt,
            icon: const Icon(Icons.camera_alt),
            tooltip: "Scan Receipt",
          ),
          if (_warnings.isNotEmpty)
            IconButton(
              onPressed: _showWarningsDialog,
              icon: Badge(
                label: Text(_warnings.length.toString()),
                child: const Icon(Icons.info_outline),
              ),
              tooltip: "View Warnings",
            ),
        ],
      ),
      body: _isLoading 
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Processing receipt...", style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        : Column(
          children: [
            // --- IMAGE VIEWER ---
            if (_receiptImage != null)
              Container(
                height: 200, 
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Stack(
                  children: [
                    InteractiveViewer(
                      minScale: 1.0, 
                      maxScale: 4.0,
                      child: Center(
                        child: Image.file(_receiptImage!, fit: BoxFit.contain),
                      ),
                    ),
                    // Confidence Badge
                    if (_confidence > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _confidence >= 0.7 
                              ? Colors.green 
                              : _confidence >= 0.5 
                                ? Colors.orange 
                                : Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${(_confidence * 100).toStringAsFixed(0)}%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            else
              Container(
                height: 120,
                color: Colors.grey.shade100,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _scanReceipt, 
                      icon: const Icon(Icons.camera_alt), 
                      label: const Text("Tap to Scan Receipt"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),

            // --- FORM FIELDS ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Merchant
                      TextFormField(
                        controller: _merchantController,
                        decoration: const InputDecoration(
                          labelText: "Merchant *", 
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.store),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty 
                          ? "Merchant name is required" 
                          : null,
                      ),
                      const SizedBox(height: 12),
                      
                      // Date & Category
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: const InputDecoration(
                                labelText: "Date *", 
                                border: OutlineInputBorder(), 
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context, 
                                  initialDate: DateTime.tryParse(_dateController.text) ?? DateTime.now(),
                                  firstDate: DateTime(2000), 
                                  lastDate: DateTime.now().add(const Duration(days: 1)),
                                );
                                if (picked != null) {
                                  _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                                }
                              },
                              validator: (v) => v == null || v.isEmpty 
                                ? "Date is required" 
                                : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _categoryController,
                              decoration: const InputDecoration(
                                labelText: "Category", 
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.category),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Tax
                      TextFormField(
                        controller: _taxController,
                        decoration: const InputDecoration(
                          labelText: "Tax/GST", 
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.receipt),
                          prefixText: "₹ ",
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() => _updateTotal()),
                      ),
                      
                      const SizedBox(height: 24),

                      // Items Section Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.list_alt, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                "Items Breakdown", 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16,
                                ),
                              ),
                              if (_items.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "${_items.length}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple.shade700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: _addItem, 
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text("Add"),
                            style: ElevatedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // Items List
                      if (_items.isEmpty) 
                        Container(
                          padding: const EdgeInsets.all(24),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Icon(Icons.inbox, size: 48, color: Colors.grey.shade300),
                              const SizedBox(height: 8),
                              const Text(
                                "No items detected",
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Tap 'Add' to add items manually",
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      
                      ..._items.asMap().entries.map((entry) {
                        int index = entry.key;
                        ReceiptItem item = entry.value;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: 0,
                          color: Colors.grey.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // Item number badge
                                Container(
                                  width: 28,
                                  height: 28,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple.shade700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Description
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    key: ValueKey("desc_$index"), 
                                    initialValue: item.description,
                                    decoration: const InputDecoration(
                                      hintText: "Item name",
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                      isDense: true,
                                    ),
                                    onChanged: (val) => item.description = val,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Amount
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    key: ValueKey("amt_$index"),
                                    initialValue: item.amount.toStringAsFixed(2),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    decoration: const InputDecoration(
                                      hintText: "0.00",
                                      border: OutlineInputBorder(),
                                      prefixText: "₹",
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                      isDense: true,
                                    ),
                                    onChanged: (val) {
                                      item.amount = double.tryParse(val) ?? 0.0;
                                      setState(() => _updateTotal());
                                    },
                                  ),
                                ),
                                // Delete button
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20),
                                  color: Colors.red.shade400,
                                  onPressed: () {
                                    setState(() {
                                      _items.removeAt(index);
                                      _updateTotal();
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 24),
                      
                      // Grand Total
                      TextFormField(
                        controller: _totalController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Grand Total", 
                          border: const OutlineInputBorder(),
                          fillColor: Colors.deepPurple.shade50,
                          filled: true,
                          prefixText: "₹ ",
                          prefixIcon: const Icon(Icons.currency_rupee),
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 20,
                          color: Colors.deepPurple,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Save Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveExpense,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "SAVE BILL",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}