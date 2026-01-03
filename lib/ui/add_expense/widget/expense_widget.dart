
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../settings/view_model/setting_view_model.dart';

// Color getSurfaceColor(BuildContext context) => Theme.of(context).cardColor;
// Color getTextColor(BuildContext context) => Theme.of(context).colorScheme.onSurface;

// // 1. MODERN HEADER (Clean & Minimal)
// class ReceiptHeader extends StatelessWidget {
//   final File? imageFile;
//   final VoidCallback onTap;
//   const ReceiptHeader({super.key, required this.imageFile, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 200, 
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.grey.withOpacity(0.2)),
//         ),
//         child: imageFile != null
//             ? ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Image.file(imageFile!, fit: BoxFit.cover),
//               )
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey[400]),
//                   const SizedBox(height: 8),
//                   Text("Upload Receipt", style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600)),
//                 ],
//               ),
//       ),
//     );
//   }
// }

// // 2. ULTRA CLEAN TEXT FIELD (No Icons, No Fill)
// class ModernTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final bool isNumber;
//   final VoidCallback? onTap;
//   final bool readOnly;
//   final String? prefixText; 

//   const ModernTextField({
//     super.key,
//     required this.controller,
//     required this.label,
//     this.isNumber = false,
//     this.onTap,
//     this.readOnly = false,
//     this.prefixText, 
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Label above the field looks cleaner
//           Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           TextFormField(
//             controller: controller,
//             readOnly: readOnly,
//             onTap: onTap,
//             keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: getTextColor(context)),
//             decoration: InputDecoration(
//               prefixText: prefixText,
//               prefixStyle: TextStyle(color: getTextColor(context), fontWeight: FontWeight.bold),
//               contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               // Clean Borders
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
//               ),
//               filled: true,
//               fillColor: Theme.of(context).cardColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // 3. CLEAN ITEM ROW (No Prefix Icon, Just Data)
// class ExpenseItemRow extends StatelessWidget {
//   final Map<String, dynamic> item;
//   final VoidCallback onRemove;
//   final Function(String) onNameChanged;
//   final Function(String) onPriceChanged;

//   const ExpenseItemRow({
//     super.key,
//     required this.item,
//     required this.onRemove,
//     required this.onNameChanged,
//     required this.onPriceChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final currency = Provider.of<SettingsViewModel>(context).currencySymbol;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Row(
//         children: [
//           // Name Input
//           Expanded(
//             flex: 2,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey.withOpacity(0.2)),
//               ),
//               child: TextFormField(
//                 initialValue: item['name'].toString(),
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   hintText: "Item Name",
//                   hintStyle: TextStyle(fontSize: 13)
//                 ),
//                 style: const TextStyle(fontWeight: FontWeight.w500),
//                 onChanged: onNameChanged,
//               ),
//             ),
//           ),
          
//           const SizedBox(width: 8),

//           // Price Input
//           Expanded(
//             flex: 1,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey.withOpacity(0.2)),
//               ),
//               child: TextFormField(
//                 initialValue: item['price'].toString(),
//                 keyboardType: TextInputType.number,
//                 textAlign: TextAlign.end,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   prefixText: currency,
//                   prefixStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                 ),
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//                 onChanged: onPriceChanged,
//               ),
//             ),
//           ),

//           const SizedBox(width: 8),

//           // Remove Button (Small and Red)
//           InkWell(
//             onTap: onRemove,
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.redAccent.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.close, size: 18, color: Colors.redAccent),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../settings/view_model/setting_view_model.dart';

// Helper for dynamic colors
Color getSurfaceColor(BuildContext context) => Theme.of(context).cardColor;
Color getTextColor(BuildContext context) => Theme.of(context).colorScheme.onSurface;
Color getPrimaryColor(BuildContext context) => Theme.of(context).primaryColor;

// --------------------------------------------------
// 1. MODERN IMAGE HEADER (Clean, no shadow, just border)
// --------------------------------------------------
class ReceiptHeader extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onTap;

  const ReceiptHeader({super.key, required this.imageFile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.grey[50], // Very subtle background
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1), // Clean border
        ),
        child: imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(imageFile!, fit: BoxFit.cover),
                    // Edit Overlay
                    Container(color: Colors.black12),
                    const Center(child: Icon(Icons.edit, color: Colors.white70, size: 40))
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey[400]),
                  const SizedBox(height: 10),
                  Text(
                    "Tap to Scan Receipt",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600, 
                      fontSize: 14
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// --------------------------------------------------
// 2. ULTRA CLEAN TEXT FIELD (Label above, No Icon inside)
// --------------------------------------------------
class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isNumber;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? prefixText; // Use this for Currency Symbol

  const ModernTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isNumber = false,
    this.onTap,
    this.readOnly = false,
    this.prefixText, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label is outside the box now (Cleaner look)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label, 
              style: TextStyle(
                color: Colors.grey[600], 
                fontSize: 13, 
                fontWeight: FontWeight.bold
              )
            ),
          ),
          
          // The Input Box
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: getTextColor(context)),
            decoration: InputDecoration(
              // Currency Prefix (e.g., $)
              prefixText: prefixText,
              prefixStyle: TextStyle(
                color: getPrimaryColor(context), 
                fontWeight: FontWeight.bold, 
                fontSize: 16
              ),
              
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              
              // Clean Borders
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: getPrimaryColor(context), width: 2),
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// 3. CLEAN ITEM ROW (No Shopping Icon)
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
    // Sync Currency from Settings
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          // 1. Name Input
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: TextFormField(
                initialValue: item['name'].toString(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Item Name",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey)
                ),
                style: const TextStyle(fontWeight: FontWeight.w500),
                onChanged: onNameChanged,
              ),
            ),
          ),
          
          const SizedBox(width: 8),

          // 2. Price Input (With Currency)
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: TextFormField(
                initialValue: item['price'].toString(),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixText: currency, // Shows ₹, $, etc.
                  prefixStyle: TextStyle(color: getPrimaryColor(context), fontWeight: FontWeight.bold, fontSize: 14),
                  hintText: "0.00",
                ),
                style: const TextStyle(fontWeight: FontWeight.bold),
                onChanged: onPriceChanged,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 3. Simple Remove Button
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close, size: 18, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}