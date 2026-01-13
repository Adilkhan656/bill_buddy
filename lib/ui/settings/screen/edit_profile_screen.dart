// import 'package:bill_buddy/util/toast_helper.dart';
// import 'package:country_code_picker/country_code_picker.dart'; // ✅ Import this
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:drift/drift.dart' as drift;
// import '../../../data/auth/auth_service.dart';
// import '../../../data/local/database.dart';

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   // Controllers
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _ageController = TextEditingController();
//   final _phoneController = TextEditingController();
  
//   // ✅ Store selected code (Default India)
//   String _selectedCountryCode = "+91"; 

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   void _loadUserData() async {
//     final auth = Provider.of<AuthService>(context, listen: false);
//     final user = auth.currentUser;
//     if (user != null) {
//       final profile = await database.getUserProfile(user.uid);
      
//       setState(() {
//         _emailController.text = profile?.email ?? user.email ?? ""; 
        
//         if (profile != null) {
//           _nameController.text = profile.name;
//           _ageController.text = profile.age > 0 ? profile.age.toString() : "";
          
//           // ✅ Load Phone: Split code and number if possible, or just load text
//           // For simplicity, we assume the DB stores the full string "+91 98765..."
//           // If you want to be precise, you'd parse it. For now, we just load the number part manually if needed.
//           // Or keep it simple: just load the number into the controller if you stored them separately.
//           // Here we assume _phoneController just holds the digits.
//           if (profile.phone != null && profile.phone!.contains(" ")) {
//              // split "+91 99999" -> code: "+91", number: "99999"
//              var parts = profile.phone!.split(" ");
//              if(parts.length >= 2) {
//                _selectedCountryCode = parts[0];
//                _phoneController.text = parts[1];
//              }
//           }
//         }
//       });
//     }
//   }

//   void _handleSave() async {
//     setState(() => _isLoading = true);
//     try {
//       final auth = Provider.of<AuthService>(context, listen: false);
//       final user = auth.currentUser;

//       if (user != null) {
//         // ✅ Combine Code + Number (e.g., "+91 9876543210")
//         String fullPhoneNumber = "$_selectedCountryCode ${_phoneController.text.trim()}";

//         await database.saveUserProfile(
//           UserProfilesCompanion(
//             uid: drift.Value(user.uid),
//             name: drift.Value(_nameController.text.trim()),
//             email: drift.Value(_emailController.text.trim()),
//             age: drift.Value(int.tryParse(_ageController.text) ?? 0),
//             phone: drift.Value(fullPhoneNumber), // ✅ Save to DB
//           )
//         );
//       }
      
//       if (mounted) {
//         ToastHelper.show(context,"Profile Updated Successfully");
//         Navigator.pop(context, true);
//       }
//     } catch (e) {
//       ToastHelper.show(context,"Error: $e", isError: true);
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bgColor = Theme.of(context).scaffoldBackgroundColor;
//     final textColor = Theme.of(context).colorScheme.onSurface;
//     const primaryColor = Color(0xFF0F766E); 

//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         backgroundColor: bgColor,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: textColor),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text("Edit Profile", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
            
//             // 1. PROFILE IMAGE (Simpler - No Camera Icon)
//             Container(
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: primaryColor.withOpacity(0.5), width: 2),
//               ),
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: primaryColor.withOpacity(0.1),
//                 child: Text(
//                   _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : "U",
//                   style: TextStyle(fontSize: 40, color: primaryColor, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
            
//             const SizedBox(height: 30),

//             // 2. FORM FIELDS
//             _buildSectionTitle("Personal Details", textColor),
//             const SizedBox(height: 16),

//             _buildBorderTextField(
//               controller: _nameController,
//               label: "Full Name",
//               icon: Icons.person_outline,
//               primaryColor: primaryColor,
//               textColor: textColor,
//             ),
//             const SizedBox(height: 20),

//             _buildBorderTextField(
//               controller: _emailController,
//               label: "Email Address",
//               icon: Icons.email_outlined,
//               primaryColor: primaryColor,
//               textColor: textColor,
//               isReadOnly: true,
//             ),
//             const SizedBox(height: 20),

//             _buildBorderTextField(
//               controller: _ageController,
//               label: "Age",
//               icon: Icons.calendar_today_outlined,
//               primaryColor: primaryColor,
//               textColor: textColor,
//               isNumber: true,
//             ),
//             const SizedBox(height: 20),
            
//             _buildSectionTitle("Contact Info", textColor),
//             const SizedBox(height: 16),
            
//             // ✅ PHONE NUMBER WITH COUNTRY PICKER
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: textColor.withOpacity(0.2), width: 1.5),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Row(
//                 children: [
//                   // Country Picker
//                   CountryCodePicker(
//                     onChanged: (country) {
//                       setState(() => _selectedCountryCode = country.dialCode ?? "+91");
//                     },
//                     initialSelection: 'IN', // Default to India
//                     favorite: const ['+91', 'US'], // Favorites at the top
//                     showCountryOnly: false,
//                     showOnlyCountryWhenClosed: false,
//                     alignLeft: false,
//                     textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
//                     dialogTextStyle: TextStyle(color: Colors.black87), // Ensure dialog text is readable
//                     searchDecoration: InputDecoration(
//                        prefixIcon: Icon(Icons.search),
//                        hintText: "Search country",
//                        contentPadding: const EdgeInsets.all(10),
//                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
//                     ),
//                   ),
                  
//                   // Vertical Divider
//                   Container(height: 30, width: 1, color: textColor.withOpacity(0.2)),

//                   // Phone Number Input
//                   Expanded(
//                     child: TextFormField(
//                       controller: _phoneController,
//                       keyboardType: TextInputType.phone,
//                       style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor),
//                       decoration: InputDecoration(
//                         hintText: "Phone Number",
//                         hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             const SizedBox(height: 40),

//             // 3. SAVE BUTTON
//             SizedBox(
//               height: 56,
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _handleSave,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryColor,
//                   foregroundColor: Colors.white,
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 ),
//                 child: _isLoading 
//                   ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) 
//                   : const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ... (Keep existing helpers: _buildSectionTitle, _buildBorderTextField)
//   Widget _buildSectionTitle(String title, Color color) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 14, 
//           fontWeight: FontWeight.bold, 
//           color: color.withOpacity(0.6),
//           letterSpacing: 0.5,
//         ),
//       ),
//     );
//   }

//   Widget _buildBorderTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     required Color primaryColor,
//     required Color textColor,
//     bool isNumber = false,
//     bool isReadOnly = false,
//   }) {
//     return TextFormField(
//       controller: controller,
//       readOnly: isReadOnly,
//       keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//       style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor),
//       cursorColor: primaryColor,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(color: textColor.withOpacity(0.5), fontSize: 14),
//         floatingLabelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
//         prefixIcon: Icon(icon, color: textColor.withOpacity(0.4), size: 22),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//         filled: isReadOnly,
//         fillColor: isReadOnly ? textColor.withOpacity(0.05) : Colors.transparent,
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: textColor.withOpacity(0.2), width: 1.5),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: primaryColor, width: 2.0),
//         ),
//       ),
//     );
//   }
// }

import 'package:bill_buddy/util/toast_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ NEW IMPORT
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/auth/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String _selectedCountryCode = "+91"; 
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 1. LOAD DATA FROM FIRESTORE ☁️
  void _loadUserData() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;

    if (user != null) {
      // Pre-fill email from Auth
      _emailController.text = user.email ?? "";

      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          
          setState(() {
            _nameController.text = data['name'] ?? "";
            _ageController.text = data['age']?.toString() ?? "";
            
            // Handle Phone Split
            String fullPhone = data['phone'] ?? "";
            if (fullPhone.contains(" ")) {
               var parts = fullPhone.split(" ");
               if(parts.length >= 2) {
                 _selectedCountryCode = parts[0];
                 _phoneController.text = parts[1];
               }
            } else {
               _phoneController.text = fullPhone; // Fallback
            }
          });
        }
      } catch (e) {
        debugPrint("Error loading profile: $e");
      }
    }
  }

  // 2. SAVE DATA TO FIRESTORE ☁️
  void _handleSave() async {
    setState(() => _isLoading = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;

    if (user == null) return;

    try {
      String fullPhoneNumber = "$_selectedCountryCode ${_phoneController.text.trim()}";

      // ✅ WRITE TO FIRESTORE
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'age': int.tryParse(_ageController.text) ?? 0,
        'phone': fullPhoneNumber,
        'updatedAt': FieldValue.serverTimestamp(), // Optional: Track when updated
      }, SetOptions(merge: true)); // Merge ensures we don't overwrite other fields accidentally
      
      if (mounted) {
        ToastHelper.show(context, "Profile Updated Successfully");
        Navigator.pop(context, true);
      }
    } catch (e) {
      ToastHelper.show(context, "Error: $e", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (Keep your UI code exactly the same as before) ...
    // Copy the build method from the previous response here.
    // It works perfectly with these new functions.
    
    // UI Code Summary for context (You don't need to rewrite this part if you have it):
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    const primaryColor = Color(0xFF0F766E); 

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        // ... standard app bar
        title: Text("Edit Profile", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
             // Profile Letter Circle
             Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryColor.withOpacity(0.5), width: 2)),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: primaryColor.withOpacity(0.1),
                child: Text(_nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : "U", style: TextStyle(fontSize: 40, color: primaryColor, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),

            _buildBorderTextField(controller: _nameController, label: "Full Name", icon: Icons.person_outline, primaryColor: primaryColor, textColor: textColor),
            const SizedBox(height: 20),
            
            _buildBorderTextField(controller: _emailController, label: "Email", icon: Icons.email_outlined, primaryColor: primaryColor, textColor: textColor, isReadOnly: true),
            const SizedBox(height: 20),

            _buildBorderTextField(controller: _ageController, label: "Age", icon: Icons.calendar_today_outlined, primaryColor: primaryColor, textColor: textColor, isNumber: true),
            const SizedBox(height: 20),
            
            // Country Code + Phone Row
            Container(
              decoration: BoxDecoration(border: Border.all(color: textColor.withOpacity(0.2), width: 1.5), borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  CountryCodePicker(
                    onChanged: (c) => setState(() => _selectedCountryCode = c.dialCode ?? "+91"),
                    initialSelection: 'IN',
                    favorite: const ['+91', 'US'],
                    textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  Container(height: 30, width: 1, color: textColor.withOpacity(0.2)),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor),
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              height: 56, width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helpers (Keep same as before)
  Widget _buildBorderTextField({required TextEditingController controller, required String label, required IconData icon, required Color primaryColor, required Color textColor, bool isNumber = false, bool isReadOnly = false}) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: textColor.withOpacity(0.4)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryColor, width: 2)),
      ),
    );
  }
}