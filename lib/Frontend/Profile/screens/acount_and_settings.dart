import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Backend/model/Input/shop_owner_model.dart';
import 'package:pharmace/Frontend/Profile/screens/notification_screen.dart';
import 'package:pharmace/Frontend/theme/app_theme_extension.dart';
import 'package:pharmace/Provider/owner_provider.dart';

class AccountAndSettingsScreen extends ConsumerWidget {
  const AccountAndSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppThemeExtension>()!;
    final ownerAsync = ref.watch(ownerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Account & Settings', style: theme.textTheme.titleLarge),
      ),
      body: ownerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (owner) {
          if (owner == null) {
            return Center(
              child: Text(
                'No account data found.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: appColors.textSecondary,
                ),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Profile card ──
                _ProfileCard(
                  owner: owner,
                  colors: colors,
                  appColors: appColors,
                ),
                const SizedBox(height: 28),

                // ── Account section ──
                _SectionTitle(label: 'Account', appColors: appColors),
                const SizedBox(height: 12),
                _SettingsGroup(
                  appColors: appColors,
                  items: [
                    _SettingsTile(
                      icon: Icons.person_outline_rounded,
                      label: 'Edit profile',
                      subtitle: 'Name, email',
                      iconBgColor: colors.primaryContainer,
                      iconColor: colors.primary,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.lock_outline_rounded,
                      label: 'Change password',
                      subtitle: 'Update your password',
                      iconBgColor: appColors.warningContainer,
                      iconColor: appColors.warning,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.admin_panel_settings_outlined,
                      label: 'Role & Permissions',
                      subtitle: _roleDisplayText(owner.role),
                      iconBgColor: appColors.goldContainer,
                      iconColor: appColors.gold,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Preferences section ──
                _SectionTitle(label: 'Preferences', appColors: appColors),
                const SizedBox(height: 12),
                _SettingsGroup(
                  appColors: appColors,
                  items: [
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      subtitle: 'Push, alerts, reminders',
                      iconBgColor: colors.primaryContainer,
                      iconColor: colors.primary,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
                        );
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.dark_mode_outlined,
                      label: 'Appearance',
                      subtitle: 'Theme, dark mode',
                      iconBgColor: appColors.goldContainer,
                      iconColor: appColors.gold,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.language_rounded,
                      label: 'Language',
                      subtitle: 'English',
                      iconBgColor: colors.primaryContainer,
                      iconColor: colors.primary,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Support section ──
                _SectionTitle(label: 'Support', appColors: appColors),
                const SizedBox(height: 12),
                _SettingsGroup(
                  appColors: appColors,
                  items: [
                    _SettingsTile(
                      icon: Icons.help_outline_rounded,
                      label: 'Help & FAQ',
                      subtitle: 'Get answers quickly',
                      iconBgColor: colors.primaryContainer,
                      iconColor: colors.primary,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.headset_mic_outlined,
                      label: 'Contact support',
                      subtitle: 'Chat, email, phone',
                      iconBgColor: appColors.warningContainer,
                      iconColor: appColors.warning,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      label: 'About Pharmase',
                      subtitle: 'Version 1.0.0',
                      iconBgColor: colors.primaryContainer,
                      iconColor: colors.primary,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Danger zone ──
                _SectionTitle(label: 'Danger zone', appColors: appColors),
                const SizedBox(height: 12),
                _SettingsGroup(
                  appColors: appColors,
                  items: [
                    _SettingsTile(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete account',
                      subtitle: 'Permanently remove your data',
                      iconBgColor: appColors.dangerContainer,
                      iconColor: appColors.danger,
                      labelColor: appColors.danger,
                      onTap: () => _showDeleteAccountDialog(context, appColors),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Member since ──
                if (owner.createdAt != null)
                  Center(
                    child: Text(
                      'Member since ${_formatDate(owner.createdAt!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: appColors.textTertiary,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _roleDisplayText(Role role) {
    switch (role) {
      case Role.owner:
        return 'Owner · Full access';
      case Role.admin:
        return 'Admin · Manage shop';
      case Role.employee:
        return 'Employee · Limited access';
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return isoDate;
    }
  }

  void _showDeleteAccountDialog(
    BuildContext context,
    AppThemeExtension appColors,
  ) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: appColors.dangerContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: appColors.danger,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Delete account?')),
          ],
        ),
        content: Text(
          'This action is permanent and cannot be undone. All your shops, data, and account information will be permanently removed.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: appColors.textSecondary,
            height: 1.45,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: Implement delete account
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.danger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Card
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.owner,
    required this.colors,
    required this.appColors,
  });

  final ShopOwnerModel owner;
  final ColorScheme colors;
  final AppThemeExtension appColors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = _getInitials(owner.name);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appColors.border),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Name
          Text(
            owner.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            owner.email,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: appColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _roleIcon(owner.role),
                  size: 15,
                  color: colors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  owner.role.value,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  IconData _roleIcon(Role role) {
    switch (role) {
      case Role.owner:
        return Icons.shield_rounded;
      case Role.admin:
        return Icons.admin_panel_settings_rounded;
      case Role.employee:
        return Icons.badge_rounded;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Title
// ─────────────────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label, required this.appColors});

  final String label;
  final AppThemeExtension appColors;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: appColors.textTertiary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Settings Group (bordered card wrapping multiple tiles)
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.appColors, required this.items});

  final AppThemeExtension appColors;
  final List<_SettingsTile> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1)
              Divider(
                height: 1,
                indent: 62,
                endIndent: 16,
                color: appColors.border,
              ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Settings Tile
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.iconBgColor,
    required this.iconColor,
    required this.onTap,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color iconBgColor;
  final Color iconColor;
  final Color? labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeExtension>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: appColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: appColors.textTertiary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
