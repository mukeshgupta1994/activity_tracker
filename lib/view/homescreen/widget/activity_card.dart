import 'package:activity_tracker/res/app_sizes.dart';
import 'package:activity_tracker/res/app_theme.dart';
import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final Map<String, String> details;

  const DetailCard({super.key, required this.title, required this.details});

  @override
  Widget build(BuildContext context) {
    final customTheme = context.customTheme;
    final typography = context.typography;

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: customTheme.cardBg,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: customTheme.borderColor ?? Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: typography.bodyLarge?.copyWith(
              fontSize: AppSizes.fontS,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(height: AppSizes.spaceL, color: customTheme.borderColor),
          ...details.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
              child: Row(
                children: [
                  Text(
                    "${e.key}: ",
                    style: typography.bodyMedium?.copyWith(
                      fontSize: AppSizes.fontXS,
                      color: customTheme.textSecondary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value,
                      style: typography.bodyLarge?.copyWith(
                        fontSize: AppSizes.fontS,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditableDetailCard extends StatelessWidget {
  final TextEditingController titleController;
  final List<MapEntry<String, TextEditingController>> detailControllers;
  final VoidCallback? onDelete;

  const EditableDetailCard({
    super.key,
    required this.titleController,
    required this.detailControllers,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = context.customTheme;
    final typography = context.typography;
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: customTheme.cardBg,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: titleController,
                  style: typography.bodyLarge?.copyWith(
                    fontSize: AppSizes.fontS,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Agency Name",
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline, color: colors.error, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          Divider(
            height: AppSizes.spaceL,
            color: colors.primary.withValues(alpha: 0.1),
          ),
          ...detailControllers.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      "${e.key}: ",
                      style: typography.bodyMedium?.copyWith(
                        fontSize: AppSizes.fontXS,
                        color: customTheme.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: e.value,
                      style: typography.bodyLarge?.copyWith(
                        fontSize: AppSizes.fontS,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FileCard extends StatelessWidget {
  final String label;
  final bool isUploaded;
  final VoidCallback? onUpload;
  final VoidCallback? onDownload;

  const FileCard({
    super.key,
    required this.label,
    this.isUploaded = false,
    this.onUpload,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = context.customTheme;
    final typography = context.typography;
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceS),
      decoration: BoxDecoration(
        color: customTheme.cardBg,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(
          color: customTheme.borderColor ?? Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description_outlined,
            size: 20,
            color: customTheme.textSecondary?.withValues(alpha: 0.4),
          ),
          AppSizes.radiusM.hSpace,
          Expanded(
            child: Text(
              label,
              style: typography.bodyLarge?.copyWith(fontSize: AppSizes.fontS),
            ),
          ),
          if (isUploaded)
            Icon(Icons.check_circle, size: 18, color: Colors.green)
          else
            TextButton(
              onPressed: onUpload,
              child: const Text("Upload", style: TextStyle(fontSize: 12)),
            ),
          AppSizes.spaceS.hSpace,
          IconButton(
            onPressed: onDownload,
            icon: Icon(Icons.download_rounded, size: 20, color: colors.primary),
          ),
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const ActionCard({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = context.customTheme;
    final typography = context.typography;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM,
          vertical: AppSizes.spaceS,
        ),
        decoration: BoxDecoration(
          color: customTheme.cardBg,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: customTheme.borderColor ?? Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor),
            AppSizes.spaceM.hSpace,
            Expanded(
              child: Text(
                label,
                style: typography.bodyLarge?.copyWith(fontSize: AppSizes.fontS),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: customTheme.textSecondary?.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionNavigationButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onSkip;
  final String saveLabel;
  final String skipLabel;

  const SectionNavigationButtons({
    super.key,
    required this.onSave,
    required this.onSkip,
    this.saveLabel = "Save & Next",
    this.skipLabel = "Skip to Next",
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onSkip,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
                side: BorderSide(color: colors.outline.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                ),
              ),
              child: Text(
                skipLabel,
                style: TextStyle(color: colors.onSurface, fontSize: 13),
              ),
            ),
          ),
          AppSizes.spaceM.hSpace,
          Expanded(
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                ),
              ),
              child: Text(
                saveLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
