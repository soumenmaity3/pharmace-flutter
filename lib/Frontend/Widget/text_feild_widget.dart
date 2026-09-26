import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/theme/app_theme_extension.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.hintText,
    this.labelText,
    this.controller,
    this.isRequired = false,
    this.keyboardType,
    this.prefixIcon,
    this.onChanged,
    this.maxLines = 1,
  });

  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool isRequired;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppThemeExtension>()!;

    final field = TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      maxLines: maxLines,

      style: theme.textTheme.bodyMedium?.copyWith(
        color: colors.textPrimary,
      ),
      textInputAction: TextInputAction.next,

      validator: (value) {
        if (isRequired && (value == null || value.trim().isEmpty)) {
          return '$hintText is required';
        }

        return null;
      },

      decoration: InputDecoration(
        hint: RichText(
          text: TextSpan(
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colors.textTertiary,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(text: hintText),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),

        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: colors.textTertiary,
                size: 22,
              )
            : null,

        filled: true,
        fillColor: theme.colorScheme.surface,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colors.border,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colors.border,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );

    if (labelText != null && labelText!.trim().isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                labelText!,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              if (isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          field,
        ],
      );
    }

    return field;
  }
}