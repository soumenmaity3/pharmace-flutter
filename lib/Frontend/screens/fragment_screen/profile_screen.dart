import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Backend/auth/secure_storage_service.dart';
import 'package:pharmace/Backend/model/Input/shop_model.dart';
import 'package:pharmace/Frontend/Profile/screens/acount_and_settings.dart';
import 'package:pharmace/Frontend/Profile/widget/edit_shop_details_bottom_sheet_widget.dart';
import 'package:pharmace/Frontend/screens/auth_screens/add_shop_screen.dart';
import 'package:pharmace/Frontend/theme/app_theme_extension.dart';
import 'package:pharmace/Provider/shop_provider.dart';

import 'package:pharmace/Frontend/Profile/screens/notification_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, required this.onLogout});
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppThemeExtension>()!;

    final selectedShop = ref.watch(selectedShopProvider);
    final shopName = selectedShop?.shopName ?? 'No shop selected';
    final shopCode = selectedShop?.shopCode ?? 'Shop Code is not mentaion';
    final city = selectedShop?.city ?? 'Shop city is not mentaion';
    final state = selectedShop?.state ?? 'Shop city is not mentaion';
    final verifyStatus = selectedShop?.verifyStatus;
    final phone = selectedShop?.phone ?? '--';
    final email = selectedShop?.shopEmail ?? '--';
    final gstNumber = selectedShop?.gstNumber ?? '--';
    final licenseNumber = selectedShop?.licenseNumber ?? '--';

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Profile', style: theme.textTheme.titleLarge),
        actions: [_threeDotActionButton(context)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ShopHeader(
                colors: colors,
                appColors: appColors,
                shopName: shopName,
                shopCode: shopCode,
                city: city,
                state: state,
              ),
              const SizedBox(height: 28),
              VerificationBanner(appColors: appColors, status: verifyStatus),
              const SizedBox(height: 26),
              Text('Business details', style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              _BusinessDetailsCard(
                appColors: appColors,
                phone: phone,
                email: email,
                gstNumber: gstNumber,
                licenseNumber: licenseNumber,
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => showEditShopDetailsBottomSheet(
                  context: context,
                  shop: selectedShop,
                ),
                icon: const Icon(Icons.settings_outlined, size: 22),
                label: const Text('Edit shop details'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuButton<String> _threeDotActionButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
        if (value == 'addShop') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddShopScreen()));
        } else if (value == 'logout') {
          await SecureStorageService.deleteToken();
          onLogout();
        } else if (value == 'account&settings') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => AccountAndSettingsScreen()));
        } else if (value == 'notifications') {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const NotificationScreen()));
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'account&settings',
          child: Row(
            children: [
              Icon(Icons.settings_outlined),
              SizedBox(width: 12),
              Text('Account & Settings'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'notifications',
          child: Row(
            children: [
              Icon(Icons.notifications_active),
              SizedBox(width: 12),
              Text('Notifications'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'addShop',
          child: Row(
            children: [Icon(Icons.add), SizedBox(width: 12), Text('Add Shop')],
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [Icon(Icons.logout), SizedBox(width: 12), Text('Logout')],
          ),
        ),
      ],
    );
  }
}

class _ShopHeader extends StatelessWidget {
  const _ShopHeader({
    required this.colors,
    required this.appColors,
    required this.shopName,
    required this.shopCode,
    required this.city,
    required this.state,
  });

  final ColorScheme colors;
  final AppThemeExtension appColors;
  final String shopName;
  final String shopCode;
  final String city, state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.medical_services_outlined,
            color: colors.primary,
            size: 36,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          shopName,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 5),
        Text(
          '$shopCode · $city, $state',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class VerificationBanner extends StatelessWidget {
  const VerificationBanner({
    super.key,
    required this.appColors,
    this.status,
    this.rejectionReason,
    this.onAction,
    this.actionLabel,
  });

  final AppThemeExtension appColors;

  /// Supports [Verify] enum, [String] ('Pending', 'Verified', 'Rejected', etc.), or `null`.
  final dynamic status;

  /// Optional specific rejection message shown when status is rejected.
  final String? rejectionReason;

  /// Optional action callback (e.g., to review documents or fix shop details).
  final VoidCallback? onAction;

  /// Custom label for the action button.
  final String? actionLabel;

  _VerificationConfig _getConfig() {
    String normalized = '';
    if (status is Verify) {
      normalized = (status as Verify).name.toLowerCase();
    } else if (status != null) {
      normalized = status.toString().trim().toLowerCase();
    }

    switch (normalized) {
      case 'verified':
      case 'approved':
        return _VerificationConfig(
          title: 'Verified',
          description:
              'Your pharmacy is verified and fully active on Pharmase.',
          badgeLabel: 'Active',
          icon: Icons.verified_rounded,
          accentColor: appColors.success,
          backgroundColor: appColors.successContainer,
          actionLabel: null,
        );

      case 'rejected':
      case 'declined':
        return _VerificationConfig(
          title: 'Verification Rejected',
          description:
              rejectionReason ??
              'Your pharmacy verification could not be approved. Please review your details and resubmit.',
          badgeLabel: 'Action Required',
          icon: Icons.gpp_bad_outlined,
          accentColor: appColors.danger,
          backgroundColor: appColors.dangerContainer,
          actionLabel: actionLabel ?? 'Review & Resubmit',
        );

      case 'unverified':
      case 'not_submitted':
      case 'unsubmitted':
        return _VerificationConfig(
          title: 'Verification Required',
          description:
              'Submit your pharmacy license and GST details to get verified and start selling.',
          badgeLabel: 'Not Verified',
          icon: Icons.shield_outlined,
          accentColor: appColors.gold,
          backgroundColor: appColors.goldContainer,
          actionLabel: actionLabel ?? 'Verify Now',
        );

      case 'pending':
      case 'in_review':
      case 'under_review':
      default:
        return _VerificationConfig(
          title: 'Verification Pending',
          description:
              'Your shop documents are under review. Verification usually takes 24–48 hours.',
          badgeLabel: 'In Review',
          icon: Icons.hourglass_top_rounded,
          accentColor: appColors.warning,
          backgroundColor: appColors.warningContainer,
          actionLabel: actionLabel,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = _getConfig();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: config.accentColor.withValues(alpha: 0.25),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: config.accentColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(config.icon, color: config.accentColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            config.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: config.accentColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: config.accentColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: config.accentColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: config.accentColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                config.badgeLabel,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: config.accentColor,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      config.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: appColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (config.actionLabel != null && onAction != null) ...[
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.only(left: 46),
              child: InkWell(
                onTap: onAction,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        config.actionLabel!,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: config.accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: config.accentColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VerificationConfig {
  const _VerificationConfig({
    required this.title,
    required this.description,
    required this.badgeLabel,
    required this.icon,
    required this.accentColor,
    required this.backgroundColor,
    this.actionLabel,
  });

  final String title;
  final String description;
  final String badgeLabel;
  final IconData icon;
  final Color accentColor;
  final Color backgroundColor;
  final String? actionLabel;
}

class _BusinessDetailsCard extends StatelessWidget {
  const _BusinessDetailsCard({
    required this.appColors,
    required this.phone,
    required this.email,
    required this.gstNumber,
    required this.licenseNumber,
  });

  final AppThemeExtension appColors;
  final String phone;
  final String email;
  final String gstNumber;
  final String licenseNumber;

  @override
  Widget build(BuildContext context) {
    final details = [
      ('Phone', phone),
      ('Email', email),
      ('GST number', gstNumber),
      ('License number', licenseNumber),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appColors.border),
      ),
      child: Column(
        children: [
          for (var index = 0; index < details.length; index++) ...[
            _DetailRow(label: details[index].$1, value: details[index].$2),
            if (index < details.length - 1)
              Divider(
                height: 1,
                indent: 20,
                endIndent: 20,
                color: appColors.border,
              ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeExtension>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: appColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
