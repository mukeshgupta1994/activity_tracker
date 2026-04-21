import 'package:activity_tracker/res/app_sizes.dart';
import 'package:activity_tracker/res/app_theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final bool isRequired;
  final String? label;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.isRequired = false,
    this.label,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final customTheme = context.customTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
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
        ],
        Container(
          decoration: BoxDecoration(
            color: customTheme.cardBg,
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            border: Border.all(
              color: customTheme.borderColor ?? Colors.transparent,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: typography.bodyLarge?.copyWith(
              fontSize: AppSizes.fontM,
              color: customTheme.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: typography.bodyMedium?.copyWith(
                color: customTheme.textSecondary?.withValues(alpha: 0.5),
                fontSize: AppSizes.fontS,
              ),
              prefixIcon: Icon(
                icon,
                color: colors.primary.withValues(alpha: 0.6),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceL,
                vertical: AppSizes.spaceM,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
