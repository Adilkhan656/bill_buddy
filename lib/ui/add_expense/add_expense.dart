import 'dart:io';
import 'package:bill_buddy/data/auth/auth_service.dart';
import 'package:bill_buddy/util/google_phrase.dart';
import 'package:bill_buddy/util/rapid_api_pharse.dart';
import 'package:bill_buddy/util/recipt_logic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../data/local/database.dart';


class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form Controllers
  final _merchantController = TextEditingController();
  final _dateController = TextEditingController();
  final _taxController = TextEditingController();
  final _totalController = TextEditingController(); 
  
  // State
  File? _receiptImage;
  List<ReceiptItem> _items = []; 
  bool _isLoading = false;

  // --- SCANNING LOGIC ---
  Future<void> _scanReceipt() async {
    final picker = ImagePicker();
    // Use high quality for better text recognition
    final XFile? photo = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    
    if (photo == null) return;

    setState(() {
      _isLoading = true;
      _receiptImage = File(photo.path); 
    });

    try {
      // 1. EYES: Use ML Kit to read the raw text (Offline & Free)
      final inputImage = InputImage.fromFilePath(photo.path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      // 2. BRAIN: Send text to Gemini to figure out the details
      // Using our new secure RapidApiParser
      ReceiptData data = await RapidApiParser.parse(recognizedText.text);

      // 3. Update UI
      setState(() {
        _merchantController.text = data.merchant;
        if (data.date != null) {
          _dateController.text = DateFormat('yyyy-MM-dd').format(data.date!);
        }
        _taxController.text = data.taxAmount.toStringAsFixed(2);
        
        // Populate Items
        _items = data.items;
        
        // Fallback: If AI found a total but no items, make one "Total" item
        if (_items.isEmpty && data.totalAmount > 0) {
           _items.add(ReceiptItem("Total Bill Amount", data.totalAmount));
        }

        _updateTotal(); 
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✨ Gemini AI Analysis Complete!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Recalculate Total from Items + Tax
  void _updateTotal() {
    double itemTotal = _items.fold(0, (sum, item) => sum + item.amount);
    double tax = double.tryParse(_taxController.text) ?? 0.0;
    _totalController.text = (itemTotal + tax).toStringAsFixed(2);
  }

  void _addItem() {
    setState(() {
      _items.add(ReceiptItem("", 0.0)); // Add blank row
    });
  }

  // --- SAVE TO DATABASE ---
  void _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;
    
    final db = Provider.of<AppDatabase>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      // 1. Insert the Header (Expense)
      final expenseId = await db.insertExpense(
        ExpensesCompanion(
          userId: drift.Value(user.uid),
          merchant: drift.Value(_merchantController.text),
          amount: drift.Value(double.parse(_totalController.text)),
          tax: drift.Value(double.tryParse(_taxController.text) ?? 0.0),
          category: drift.Value("General"), 
          date: drift.Value(DateTime.tryParse(_dateController.text) ?? DateTime.now()),
        ),
      );

      // 2. Insert the Items (Linked to expenseId)
      if (_items.isNotEmpty) {
        final billItems = _items.map((item) => BillItemsCompanion(
          expenseId: drift.Value(expenseId),
          name: drift.Value(item.description.isEmpty ? "Item" : item.description),
          amount: drift.Value(item.amount),
        )).toList();

        await db.insertBillItems(billItems);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Save Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Bill"), actions: [
        IconButton(onPressed: _scanReceipt, icon: const Icon(Icons.camera_alt)),
      ]),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : Column(
          children: [
            // --- 1. IMAGE AREA (Zoomable) ---
            if (_receiptImage != null)
              SizedBox(
                height: 200, 
                width: double.infinity,
                child: Container(
                  color: Colors.black87,
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: Image.file(_receiptImage!, fit: BoxFit.contain),
                  ),
                ),
              )
            else
              Container(
                height: 100,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: TextButton.icon(
                  onPressed: _scanReceipt, 
                  icon: const Icon(Icons.camera_alt), 
                  label: const Text("Tap to Scan Receipt")
                ),
              ),

            // --- 2. FORM AREA ---
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
                        decoration: const InputDecoration(labelText: "Merchant", border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? "Required" : null,
                      ),
                      const SizedBox(height: 12),
                      
                      // Date & Tax
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: const InputDecoration(labelText: "Date", border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_month)),
                              onTap: () async {
                                DateTime? p = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030));
                                if(p != null) _dateController.text = DateFormat('yyyy-MM-dd').format(p);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _taxController,
                              decoration: const InputDecoration(labelText: "Tax/GST", border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() => _updateTotal()),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Items Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Items Breakdown", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ElevatedButton.icon(
                            onPressed: _addItem, 
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text("Add Item"),
                            style: ElevatedButton.styleFrom(visualDensity: VisualDensity.compact),
                          ),
                        ],
                      ),
                      const Divider(),

                      // Dynamic List
                      if (_items.isEmpty) 
                        const Padding(padding: EdgeInsets.all(16), child: Text("No items detected. Add manually.", style: TextStyle(color: Colors.grey))),
                      
                      ..._items.asMap().entries.map((entry) {
                        int index = entry.key;
                        ReceiptItem item = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  key: ValueKey("desc_$index"), 
                                  initialValue: item.description,
                                  decoration: const InputDecoration(hintText: "Item Name", contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                  onChanged: (val) => item.description = val,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  key: ValueKey("amt_$index"),
                                  initialValue: item.amount.toStringAsFixed(2),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(hintText: "0.00", prefixText: "\$", contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                  onChanged: (val) {
                                    item.amount = double.tryParse(val) ?? 0.0;
                                    setState(() => _updateTotal());
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _items.removeAt(index);
                                    _updateTotal();
                                  });
                                },
                              )
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 20),
                      // Grand Total (Read Only - Calculated)
                      TextFormField(
                        controller: _totalController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Grand Total (Calculated)", 
                          border: OutlineInputBorder(),
                          fillColor: Colors.black12,
                          filled: true
                        ),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _saveExpense,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text("SAVE BILL"),
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