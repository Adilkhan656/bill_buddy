import 'package:bill_buddy/data/auth/auth_service.dart';
import 'package:bill_buddy/data/local/database.dart';
import 'package:bill_buddy/ui/login/login_screen.dart';
import 'package:bill_buddy/ui/settings/screen/edit_profile_screen.dart';
import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
import 'package:bill_buddy/util/category_style_helper.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsViewModel>(context);
    final auth = Provider.of<AuthService>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      appBar: AppBar(title: const Text("Settings")),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ✅ 1. NEW PROFILE SECTION
          const _SectionHeader(title: "Account"),
          _buildProfileSection(context, auth),
          const SizedBox(height: 10),

          // 2. APPEARANCE
          const _SectionHeader(title: "Appearance"),
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: settings.isDarkMode,
            onChanged: (val) => settings.toggleTheme(val),
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
          ),
          const Divider(),

          // 3. CURRENCY
          const _SectionHeader(title: "Preferences"),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text("Currency"),
            trailing: DropdownButton<String>(
              value: settings.currencySymbol,
              underline: Container(),
              dropdownColor: Theme.of(context).cardColor,
              items: const [
                DropdownMenuItem(value: "\$", child: Text("\$ Dollar")),
                DropdownMenuItem(value: "₹", child: Text("₹ Rupee")),
                DropdownMenuItem(value: "€", child: Text("€ Euro")),
                DropdownMenuItem(value: "£", child: Text("£ Pound")),
              ],
              onChanged: (val) {
                if (val != null) settings.setCurrency(val);
              },
            ),
          ),
          const Divider(),

          // 4. TAGS
          const _SectionHeader(title: "Tags & Categories"),
          ListTile(
            leading: const Icon(Icons.label),
            title: const Text("Manage Custom Tags"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showTagsDialog(context),
          ),
          const Divider(),

          // 5. HELP
          const _SectionHeader(title: "Help Center"),
          ListTile(
            leading: const Icon(Icons.star_rate),
            title: const Text("Rate Us"),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Thanks for 5 stars! ⭐")),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text("Contact Us"),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Contact support@billbuddy.com")),
            ),
          ),
          const Divider(),

          // 6. LOGOUT (Moved below profile for better UX)
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              "Log Out",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => _confirmLogout(context, auth),
          ),
        ],
      ),
    );
  }

Widget _buildProfileSection(BuildContext context, AuthService auth) {
    final user = auth.currentUser;
    final cardColor = Theme.of(context).cardColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currency = Provider.of<SettingsViewModel>(context).currencySymbol;
    final primaryColor = Theme.of(context).primaryColor;

    if (user == null) return const SizedBox.shrink();

    // ✅ FETCH PROFILE & TOTAL SPEND
    return FutureBuilder(
      future: Future.wait([
        database.getUserProfile(user.uid),     // 0: Profile
        database.getTotalSpend()               // 1: Total Lifetime Spend (You need to add this method to database.dart, see below)
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
           return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
        }

        final profile = snapshot.data?[0] as UserProfile?;
        final totalLifetimeSpend = snapshot.data?[1] as double? ?? 0.0;

        final name = (profile?.name != null && profile!.name.isNotEmpty) ? profile.name : (user.displayName ?? "User");
        final email = profile?.email ?? user.email ?? "No Email";

        return InkWell(
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
            (context as Element).markNeedsBuild(); 
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 32,
                  backgroundColor: isDark ? primaryColor : primaryColor.withOpacity(0.1),
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : "U",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: isDark ? Colors.white : primaryColor),
                  ),
                ),
                const SizedBox(width: 20),
                
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(email, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(height: 12),
                      
                      // ✅ LIFETIME SPEND BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Text(
                          "Total Spent: $currency${totalLifetimeSpend.toStringAsFixed(0)}",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.edit_outlined, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context, AuthService auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },

            child: const Text(
              "Log Out",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showTagsDialog(BuildContext context) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Manage Tags"),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: StreamBuilder<List<Tag>>(
                  stream: database.watchAllTags(),
                  builder: (context, snapshot) {
                    final tags = snapshot.data ?? [];
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: tags.length,
                      itemBuilder: (context, index) {
                        final tag = tags[index];
                        return ListTile(
                          dense: true,
                          // ✅ SHOW ASSET ICON
                          leading: CategoryStyleHelper.getTagIcon(
                            tag.name,
                            size: 24,
                          ),
                          title: Text(tag.name),
                          trailing: tag.isCustom
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => database.deleteTag(tag.name),
                                )
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: textController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  labelText: "New Tag Name",
                  labelStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                database.insertTag(
                  TagsCompanion(
                    name: drift.Value(textController.text.trim()),
                    isCustom: const drift.Value(true),
                    color: const drift.Value(0xFF607D8B),
                  ),
                );
                textController.clear();
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerColor = isDark
        ? const Color(0xFF2DD4BF)
        : Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: headerColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
