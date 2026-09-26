import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  final Color border;
  final Color disabled;

  final Color success;
  final Color successContainer;

  final Color warning;
  final Color warningContainer;

  final Color danger;
  final Color dangerContainer;

  final Color gold;
  final Color goldContainer;

  const AppThemeExtension({
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.disabled,
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.danger,
    required this.dangerContainer,
    required this.gold,
    required this.goldContainer,
  });

  @override
  AppThemeExtension copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
    Color? disabled,
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? danger,
    Color? dangerContainer,
    Color? gold,
    Color? goldContainer,
  }) {
    return AppThemeExtension(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      border: border ?? this.border,
      disabled: disabled ?? this.disabled,
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      danger: danger ?? this.danger,
      dangerContainer: dangerContainer ?? this.dangerContainer,
      gold: gold ?? this.gold,
      goldContainer: goldContainer ?? this.goldContainer,
    );
  }

  @override
  AppThemeExtension lerp(
      covariant ThemeExtension<AppThemeExtension>? other,
      double t,
      ) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      border: Color.lerp(border, other.border, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContainer:
      Color.lerp(successContainer, other.successContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer:
      Color.lerp(warningContainer, other.warningContainer, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerContainer:
      Color.lerp(dangerContainer, other.dangerContainer, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      goldContainer:
      Color.lerp(goldContainer, other.goldContainer, t)!,
    );
  }
}