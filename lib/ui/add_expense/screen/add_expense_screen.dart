import 'package:bill_buddy/data/local/database.dart';
import 'package:bill_buddy/data/service/notification_service.dart';
import 'package:bill_buddy/ui/add_expense/view_model/add_expanse_view_model.dart';
import 'package:bill_buddy/ui/add_expense/widget/expense_widget.dart'; // Import the new widgets
import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
import 'package:bill_buddy/util/category_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
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
    // 1. Get Currency from Settings
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
    final primaryColor = Theme.of(context).primaryColor;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          // Clean AppBar
          appBar: AppBar(
            title: const Text("New Expense", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    // 📸 1. RECEIPT IMAGE
                    ReceiptHeader(
                      imageFile: _viewModel.selectedImage,
                      onTap: () => _showPickerSheet(context),
                    ),
                    const SizedBox(height: 30),

                    // 📝 2. MERCHANT NAME
                    ModernTextField(
                      controller: _viewModel.merchantController, 
                      label: "Merchant Name"
                    ),
                    
                    // 💰 3. TOTAL & DATE ROW
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ModernTextField(
                            controller: _viewModel.totalController, 
                            label: "Total Amount", 
                            isNumber: true, 
                            prefixText: currency, // Pass currency here
                          )
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ModernTextField(
                            controller: _viewModel.dateController, 
                            label: "Date", 
                            readOnly: true, 
                            onTap: () => _viewModel.selectDate(context)
                          )
                        ),
                      ],
                    ),

                    // 🏷️ 4. CATEGORY DROPDOWN (Styled to match ModernTextField)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 8),
                            child: Text(
                              "Category", 
                              style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.bold)
                            ),
                          ),
                        StreamBuilder<List<Tag>>(
                          stream: database.watchAllTags(),
                          builder: (context, snapshot) {
                            final tags = snapshot.data ?? [];
                            if (tags.isEmpty) return const SizedBox.shrink();

                            final validCategory = tags.any((t) => t.name == _viewModel.selectedCategory) 
                                ? _viewModel.selectedCategory 
                                : tags.first.name;
                            _viewModel.selectedCategory = validCategory;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 25),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.withOpacity(0.3)), // Matches TextField border
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                   borderRadius: BorderRadius.circular(20),
                                  value: _viewModel.selectedCategory,
                                  isExpanded: true,
                                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor),
                                  menuMaxHeight: 300, // UX Fix
                                  items: tags.map((tag) {
                                    return DropdownMenuItem(
                                      
                                      value: tag.name,
                                      child: Row(
                                        children: [
                                          CategoryStyleHelper.getTagIcon(tag.name, size: 24),
                                          const SizedBox(width: 12),
                                          Text(tag.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _viewModel.selectedCategory = val);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // 🧾 5. ITEMS LIST
                    const Text("Items Breakdown", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    
                    ...List.generate(_viewModel.items.length, (index) {
                      return ExpenseItemRow(
                        item: _viewModel.items[index],
                        onRemove: () => _viewModel.removeItem(index),
                        onNameChanged: (v) => _viewModel.updateItem(index, 'name', v),
                        onPriceChanged: (v) => _viewModel.updateItem(index, 'price', v),
                      );
                    }),
                    
                    // Add Button
                    Center(
                      child: TextButton.icon(
                        onPressed: _viewModel.addItem, 
                        icon: const Icon(Icons.add_circle_outline, size: 18), 
                        label: const Text("Add Item"),
                        style: TextButton.styleFrom(
                          foregroundColor: primaryColor,
                          textStyle: const TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),

              // 💾 6. SAVE BUTTON (Floating at Bottom)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
                    ]
                  ),
                  child: ElevatedButton(
                   onPressed: () async {
  // 1. Let your ViewModel handle the saving (Validation + DB Insert)
  bool success = await _viewModel.saveExpense(context);

  if (success) {
    // ✅ 2. TRIGGER NOTIFICATION CHECK
    // We wait for the save to finish so the new expense is in the DB
    await NotificationService().checkBudgetAndNotify(database);

    // 3. Close the screen
    if (mounted) Navigator.pop(context);
  }
},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Save Expense", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),

              // 🤖 7. LOADING OVERLAY
              if (_viewModel.isLoading) 
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          'assets/lottie/loading.json',
                          width: 180,
                          height: 180,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Reading Receipt...", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Wrap(
        children: [
          ListTile(leading: const Icon(Icons.camera_alt_rounded), title: const Text("Camera"), onTap: () { Navigator.pop(context); _viewModel.pickImage(ImageSource.camera, context); }),
          ListTile(leading: const Icon(Icons.photo_library_rounded), title: const Text("Gallery"), onTap: () { Navigator.pop(context); _viewModel.pickImage(ImageSource.gallery, context); }),
        ],
      ),
    );
  }
}