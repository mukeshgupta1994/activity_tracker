import 'package:activity_tracker/res/app_colors.dart';
import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  const RetryButton({
    super.key,
    required this.ontap,
  });

  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: ontap!,
      icon: const Icon(
        Icons.refresh,
        size: 15.0,
      ),
      label: const Text(
        'Retry',
        style: TextStyle(
          color: AppColors.colorBlack,
          fontSize: 12.0,
        ),
      ),
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.colorAccent),
      ),
    );
  }
}
