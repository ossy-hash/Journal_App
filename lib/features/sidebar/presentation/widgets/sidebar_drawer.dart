import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../journal/providers/journal_provider.dart';

class SidebarDrawer extends ConsumerWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalState = ref.watch(journalProvider);
    final user = ref.watch(currentUserProvider);
    
    return Container(
      width: 280,
      color: AppTheme.primaryBlack,
      child: SafeArea(
        child: Column(
          children: [
            // User Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.goldAccent.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.goldAccent.withOpacity(0.3),
                          AppTheme.goldAccent.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppTheme.goldAccent.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        user?.email?[0].toUpperCase() ?? 'J',
                        style: const TextStyle(
                          color: AppTheme.goldAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.userMetadata?['name'] ?? 'Journalist',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? '',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'All Journals',
                    count: journalState.journals.length,
                    isSelected: true,
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/');
                    },
                  ),
                  _NavItem(
                    icon: Icons.star_rounded,
                    label: 'Favorites',
                    count: journalState.favorites.length,
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/favorites');
                    },
                  ),
                  const Divider(height: 32),
                  _NavItem(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/settings');
                    },
                  ),
                ],
              ),
            ),
            
            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton.icon(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _NavItem({
    required this.icon,
    required this.label,
    this.count,
    this.isSelected = false,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: isSelected
            ? AppTheme.goldAccent.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppTheme.goldAccent
                      : AppTheme.textSecondary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (count != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.goldAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: AppTheme.goldAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}