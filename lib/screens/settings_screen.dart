import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Mode sombre'),
            subtitle: const Text('Activer le thème sombre de l\'application'),
            value: isDarkMode,
            onChanged: (value) {
              ref.read(isDarkModeProvider.notifier).state = value;
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('À propos'),
            subtitle: const Text('Informations sur l\'application'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Notes App',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 Notes App',
              );
            },
          ),
        ],
      ),
    );
  }
}