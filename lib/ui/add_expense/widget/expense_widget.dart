import 'dart:io';
import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Color getSurfaceColor(BuildContext context) => Theme.of(context).cardColor;
Color getTextColor(BuildContext context) => Theme.of(context).colorScheme.onSurface;
Color getPrimaryColor(BuildContext context) => Theme.of(context).colorScheme.primary;

// --------------------------------------------------
// 1. HEADER WIDGET (Image Preview)
// --------------------------------------------------
class ReceiptHeader extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onTap;

  const ReceiptHeader({super.key, required this.imageFile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = getPrimaryColor(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: getSurfaceColor(context), // Dynamic: White vs Dark Grey
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15, 
              offset: const Offset(0, 8)
            ),
          ],
        ),
        child: imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(imageFile!, fit: BoxFit.cover),
                    Container(color: Colors.black12),
                    const Center(child: Icon(Icons.edit, color: Colors.white70, size: 40))
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.camera_alt_rounded, size: 40, color: primaryColor),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Tap to Scan Receipt",
                    style: TextStyle(
                      color: getTextColor(context).withOpacity(0.7),
                      fontWeight: FontWeight.w500, fontSize: 16
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// --------------------------------------------------
// 2. MODERN FORM FIELD
// --------------------------------------------------
class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isNumber;
  final VoidCallback? onTap;
  final bool readOnly;

  const ModernTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isNumber = false,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic Input Fill Color
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? Colors.grey[800] : Colors.grey[50]; 

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: getSurfaceColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: getTextColor(context)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
          prefixIcon: Icon(icon, color: getPrimaryColor(context).withOpacity(0.7), size: 20),
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: getPrimaryColor(context), width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// 3. ITEM ROW WIDGET (Fixed Currency Here)
// --------------------------------------------------
class ExpenseItemRow extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;
  final Function(String) onNameChanged;
  final Function(String) onPriceChanged;

  const ExpenseItemRow({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onNameChanged,
    required this.onPriceChanged,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: Get currency from Settings Provider
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
    final primaryColor = getPrimaryColor(context);

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.delete_outline, color: Colors.redAccent),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: getSurfaceColor(context), // Dynamic Card BG
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(8)
            ),
            child: Icon(Icons.shopping_bag_outlined, size: 20, color: primaryColor),
          ),
          title: TextFormField(
            initialValue: item['name'].toString(),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true, hintText: "Item Name"),
            style: TextStyle(fontWeight: FontWeight.w600, color: getTextColor(context)),
            onChanged: onNameChanged,
          ),
          trailing: SizedBox(
            width: 80,
            child: TextFormField(
              initialValue: item['price'].toString(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              // ✅ FIX: Use the 'currency' variable here as prefix
              decoration: InputDecoration(
                border: InputBorder.none, 
                isDense: true,
                prefixText: currency, // Shows $, ₹, €, etc.
                prefixStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              onChanged: onPriceChanged,
            ),
          ),
        ),
      ),
    );
  }
}