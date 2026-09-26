import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/screens/other_screen/add_employees_screen.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';

/// Shows the modernized Employee Status Dialog.
Future<void> showEmployeeStatusDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => const EmployeeStatusDialog(),
  );
}

class EmployeeStatusDialog extends StatelessWidget {
  final VoidCallback? onRegisterPressed;

  const EmployeeStatusDialog({super.key, this.onRegisterPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final warningColor = isDark ? AppColors.warningDark : AppColors.warning;
    final warningBg = isDark
        ? AppColors.warningDarkContainer.withValues(alpha: 0.35)
        : AppColors.warningLight;
    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return AlertDialog(
      backgroundColor: surfaceColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: borderColor, width: 1),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: warningBg,
              shape: BoxShape.circle,
              border: Border.all(
                color: warningColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Icon(Icons.badge_outlined, color: warningColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Employee Status',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Action required',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: warningColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You haven’t marked yourself as an employee yet. Please register or update your status to access billing and medicine actions.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: textSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'As a shop owner, you can register yourself as Manager in Employee settings.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textSecondary,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                if (onRegisterPressed != null) {
                  onRegisterPressed!();
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const AddEmployeesScreen(
                        isRequestForSelfEmployee: true,
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: const Text(
                'Register as Employee',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: textSecondary,
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Got it, maybe later',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
