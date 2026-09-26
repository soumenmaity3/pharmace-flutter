import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';

class RoleWidget extends StatelessWidget {
  const RoleWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.isEnabled = true,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: isEnabled ? 1.0 : (isSelected ? 0.9 : 0.35),
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: isSelected ? theme.highlightColor : theme.cardColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.darkBorder,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: isEnabled
                    ? null
                    : (isSelected ? null : Colors.grey.shade600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}