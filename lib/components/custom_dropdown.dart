import 'package:activity_tracker/res/app_sizes.dart';
import 'package:activity_tracker/res/app_theme.dart';
import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isRequired;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final customTheme = context.customTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: typography.bodyMedium?.copyWith(
              fontSize: AppSizes.fontXS,
              color: customTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            children: [
              if (isRequired)
                TextSpan(
                  text: " *",
                  style: TextStyle(
                    color: colors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        AppSizes.spaceS.vSpace,
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceM,
            ),
            decoration: BoxDecoration(
              color: customTheme.cardBg,
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              border: Border.all(
                color: customTheme.borderColor ?? Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: colors.primary.withValues(alpha: 0.8),
                ),
                AppSizes.radiusM.hSpace,
                Expanded(
                  child: Text(
                    value,
                    style: typography.bodyLarge?.copyWith(
                      fontSize: AppSizes.fontS,
                      color: customTheme.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: customTheme.textSecondary?.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
