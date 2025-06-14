import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    const primaryColor = Color(0xFF059669);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // No shadow
        title: Text(
          'Paramètres',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1), // Subtle border
          ),
          child: ListView(
            children: [
              SwitchListTile(
                title: Text(
                  'Mode sombre',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                subtitle: Text(
                  'Activer le thème sombre de l\'application',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                value: isDarkMode,
                activeColor: primaryColor,
                activeTrackColor: primaryColor.withOpacity(0.3),
                inactiveThumbColor: Colors.grey[400],
                inactiveTrackColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                onChanged: (value) {
                  ref.read(isDarkModeProvider.notifier).state = value;
                },
              ),
              const Divider(indent: 16, endIndent: 16),
              ListTile(
                title: Text(
                  'À propos',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                subtitle: Text(
                  'Informations sur l\'application',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Notes App',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2025 Notes App',
                    applicationIcon: Icon(
                      Icons.note_alt_outlined,
                      color: primaryColor,
                      size: 48,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}