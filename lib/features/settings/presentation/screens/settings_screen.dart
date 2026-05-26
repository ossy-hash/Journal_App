import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/'),
        ),
        title: Text('Ossy', style: TextStyle(color: AppTheme.goldAccent)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _SettingsSection(
            title: 'Appearance',
            children: [
              _SettingsTile(
                icon: Icons.dark_mode_rounded,
                title: 'Dark Mode',
                subtitle: 'Toggle dark/light theme',
                trailing: Switch(
                  value: settings.isDarkMode,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).toggleDarkMode();
                  },
                  activeColor: AppTheme.goldAccent,
                ),
              ),
              _SettingsTile(
                icon: Icons.palette_rounded,
                title: 'Accent Color',
                subtitle: 'Gold',
                trailing: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.goldAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sync Section
          _SettingsSection(
            title: 'Sync',
            children: [
              _SettingsTile(
                icon: Icons.sync_rounded,
                title: 'Auto Sync',
                subtitle: 'Automatically sync when online',
                trailing: Switch(
                  value: settings.autoSync,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).toggleAutoSync();
                  },
                  activeColor: AppTheme.goldAccent,
                ),
              ),
              _SettingsTile(
                icon: Icons.cloud_done_rounded,
                title: 'Sync Now',
                subtitle: 'Last synced: ${settings.lastSync ?? "Never"}',
                onTap: () {
                  // Trigger manual sync
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Syncing...'),
                      backgroundColor: AppTheme.goldAccent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Data Section
          _SettingsSection(
            title: 'Data & Storage',
            children: [
              _SettingsTile(
                icon: Icons.storage_rounded,
                title: 'Local Storage',
                subtitle: 'Manage offline data',
                trailing: Text(
                  '${settings.storageUsed} MB',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
              _SettingsTile(
                icon: Icons.delete_sweep_rounded,
                title: 'Clear Cache',
                subtitle: 'Remove temporary files',
                onTap: () {
                  _showClearCacheDialog(context, ref);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // About Section
          _SettingsSection(
            title: 'About',
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'Version',
                subtitle: '1.0.0',
              ),
              _SettingsTile(
                icon: Icons.star_outline_rounded,
                title: 'Rate the App',
                onTap: () {
                  // Open app store rating
                },
              ),
              _SettingsTile(
                icon: Icons.feedback_outlined,
                title: 'Send Feedback',
                onTap: () {
                  // Open feedback form
                },
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.withOpacity(0.8),
                side: BorderSide(
                  color: Colors.red.withOpacity(0.3),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBlack,
        title: const Text('Clear Cache'),
        content: const Text(
          'This will remove all temporary files. Your journals will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).clearCache();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Cache cleared successfully'),
                  backgroundColor: AppTheme.goldAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              color: AppTheme.goldAccent,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceBlack,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.goldAccent.withOpacity(0.1),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.goldAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.goldAccent,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}