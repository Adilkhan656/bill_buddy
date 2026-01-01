import 'package:bill_buddy/data/auth/auth_service.dart';
import 'package:bill_buddy/data/local/database.dart';
import 'package:bill_buddy/ui/settings/view_model/setting_view_model.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsViewModel>(context);
    final auth = Provider.of<AuthService>(context, listen: false); // ✅ Access Auth
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. APPEARANCE
          const _SectionHeader(title: "Appearance"),
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: settings.isDarkMode,
            onChanged: (val) => settings.toggleTheme(val),
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
          ),
          const Divider(),

          // 2. CURRENCY
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

          // 3. TAGS
          const _SectionHeader(title: "Tags & Categories"),
          ListTile(
            leading: const Icon(Icons.label),
            title: const Text("Manage Custom Tags"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showTagsDialog(context),
          ),
          const Divider(),

          // 4. HELP
          const _SectionHeader(title: "Help Center"),
          ListTile(
            leading: const Icon(Icons.star_rate),
            title: const Text("Rate Us"),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Thanks for 5 stars! ⭐"))),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text("Contact Us"),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Contact support@billbuddy.com"))),
          ),
          const Divider(),

          // 5. ACCOUNT (Logout)
          const _SectionHeader(title: "Account"),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Log Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
            onTap: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Theme.of(context).cardColor,
                  title: const Text("Log Out"),
                  content: const Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx); // Close Dialog
                        auth.signOut(); // ✅ Trigger Sign Out
                      },
                      child: const Text("Log Out", style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );
            },
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
                          leading: Icon(Icons.circle, size: 12, color: Color(tag.color ?? 0xFF9E9E9E)),
                          title: Text(tag.name, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                          trailing: tag.isCustom 
                             ? IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => database.deleteTag(tag.name))
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
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: "New Tag Name",
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close")),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                database.insertTag(TagsCompanion(
                  name: drift.Value(textController.text.trim()),
                  isCustom: const drift.Value(true),
                  color: const drift.Value(0xFF607D8B),
                ));
                textController.clear();
              }
            },
            child: const Text("Add"),
          )
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
    final headerColor = isDark ? const Color(0xFF2DD4BF) : Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title, 
        style: TextStyle(
          color: headerColor, 
          fontWeight: FontWeight.bold,
          fontSize: 14,
        )
      ),
    );
  }
}