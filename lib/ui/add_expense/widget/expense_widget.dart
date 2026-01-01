import 'dart:io';
import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🎨 CONSTANTS
const Color kPrimaryColor = Color(0xFF6C63FF);
const Color kSurfaceColor = Colors.white;
const Color kBgColor = Color(0xFFF4F6F8);

// --------------------------------------------------
// 1. HEADER WIDGET (Glassmorphism Image Preview)
// --------------------------------------------------
class ReceiptHeader extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onTap;

  const ReceiptHeader({super.key, required this.imageFile, required this.onTap});

  @override
  Widget build(BuildContext context) {
   
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 240,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kSurfaceColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(imageFile!, fit: BoxFit.cover),
                    // Gradient Overlay for text readability
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 16,
                      right: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.edit, color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.qr_code_scanner_rounded, size: 48, color: kPrimaryColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Scan Receipt",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                  ),
                  Text(
                    "AI will extract details automatically",
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kSurfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          prefixIcon: Icon(icon, color: kPrimaryColor.withOpacity(0.7), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// 3. ITEM ROW WIDGET
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
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.red),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: kSurfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: kBgColor, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.local_offer_outlined, size: 18, color: Colors.black54),
          ),
          title: TextFormField(
            initialValue: item['name'].toString(),
            decoration: const InputDecoration(border: InputBorder.none, hintText: "Item Name"),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            onChanged: onNameChanged,
          ),
          trailing: SizedBox(
            width: 70,
            child: TextFormField(
              initialValue: item['price'].toString(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
             decoration: InputDecoration(
                border: InputBorder.none, 
                prefixText: currency, 
                prefixStyle: const TextStyle(color: Colors.grey)
              ),

              onChanged: onPriceChanged,
            ),
          ),
        ),
      ),
    );
  }
}