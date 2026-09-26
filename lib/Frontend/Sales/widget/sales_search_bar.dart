import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/theme/app_theme_extension.dart';

class SalesSearchBar extends StatelessWidget {
  const SalesSearchBar({super.key, this.onFilterTap, this.onChanged});

  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppThemeExtension>()!;

    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onChanged,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Search invoice or customer',

              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: colors.textTertiary,
                fontWeight: FontWeight.w400,
              ),

              prefixIcon: Icon(
                Icons.search,
                color: colors.textTertiary,
                size: 22,
              ),

              filled: true,
              fillColor: theme.colorScheme.surface,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: colors.border),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: colors.border),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        SizedBox(
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: onFilterTap,
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: colors.textPrimary,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colors.border),
              ),
            ),
            icon: const Icon(Icons.tune, size: 22),
          ),
        ),
      ],
    );
  }
}
