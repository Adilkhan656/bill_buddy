import 'package:bill_buddy/util/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/auth/auth_service.dart';
import '../../../data/local/database.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(); // Email is usually Read-Only
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController(); // ✨ Added for UI (Visual only for now)
  final _bioController = TextEditingController();   // ✨ Added for UI (Visual only for now)

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 1. Load existing data
  void _loadUserData() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;
    if (user != null) {
      final profile = await database.getUserProfile(user.uid);
      
      setState(() {
        // Pre-fill email from Firebase Auth if DB is empty
        _emailController.text = profile?.email ?? user.email ?? ""; 
        
        if (profile != null) {
          _nameController.text = profile.name;
          _ageController.text = profile.age > 0 ? profile.age.toString() : "";
        }
      });
    }
  }

  // 2. Save updates
  void _handleSave() async {
    setState(() => _isLoading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final user = auth.currentUser;

      if (user != null) {
        await database.saveUserProfile(
          UserProfilesCompanion(
            uid: drift.Value(user.uid),
            name: drift.Value(_nameController.text.trim()),
            email: drift.Value(_emailController.text.trim()),
            age: drift.Value(int.tryParse(_ageController.text) ?? 0),
          )
        );
      }
      
      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Profile Updated Successfully!"), backgroundColor: Colors.green),
        // );
        ToastHelper.show(context,"Profile Updated Successfully");
        Navigator.pop(context, true);
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      ToastHelper.show(context,"Error: $e", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Dynamic Theme Colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    const primaryColor = Color(0xFF0F766E); // Deep Teal

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Edit Profile", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            
            // 1. PROFILE IMAGE (With Edit Badge)
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor.withOpacity(0.5), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor.withOpacity(0.1),
                    child: Text(
                      _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : "U",
                      style: TextStyle(fontSize: 40, color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Camera Icon Badge
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Image upload coming soon!")),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: bgColor, width: 3),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),

            // 2. FORM FIELDS
            _buildSectionTitle("Personal Details", textColor),
            const SizedBox(height: 16),

            // Full Name
            _buildBorderTextField(
              controller: _nameController,
              label: "Full Name",
              icon: Icons.person_outline,
              primaryColor: primaryColor,
              textColor: textColor,
            ),
            const SizedBox(height: 20),

            // Email (Read Only - changing email is complex)
            _buildBorderTextField(
              controller: _emailController,
              label: "Email Address",
              icon: Icons.email_outlined,
              primaryColor: primaryColor,
              textColor: textColor,
              isReadOnly: true, // User cannot edit this directly
            ),
            const SizedBox(height: 20),

            // Age
            _buildBorderTextField(
              controller: _ageController,
              label: "Age",
              icon: Icons.calendar_today_outlined,
              primaryColor: primaryColor,
              textColor: textColor,
              isNumber: true,
            ),
            const SizedBox(height: 20),
            
            // ✨ NEW: Bio / Phone (Visual only for now)
            _buildSectionTitle("More Info", textColor),
            const SizedBox(height: 16),
            
            _buildBorderTextField(
              controller: _phoneController,
              label: "Phone Number (Optional)",
              icon: Icons.phone_outlined,
              primaryColor: primaryColor,
              textColor: textColor,
              isNumber: true,
            ),
            
            const SizedBox(height: 40),

            // 3. SAVE BUTTON
            SizedBox(
              height: 56,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading 
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) 
                  : const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14, 
          fontWeight: FontWeight.bold, 
          color: color.withOpacity(0.6),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ✅ MODERN BORDER TEXT FIELD (Matches Login Screen)
  Widget _buildBorderTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color primaryColor,
    required Color textColor,
    bool isNumber = false,
    bool isReadOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor),
      cursorColor: primaryColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor.withOpacity(0.5), fontSize: 14),
        floatingLabelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
        prefixIcon: Icon(icon, color: textColor.withOpacity(0.4), size: 22),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        
        filled: isReadOnly,
        fillColor: isReadOnly ? textColor.withOpacity(0.05) : Colors.transparent,

        // DEFAULT BORDER
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: textColor.withOpacity(0.2), width: 1.5),
        ),
        
        // FOCUSED BORDER
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
      ),
    );
  }
}