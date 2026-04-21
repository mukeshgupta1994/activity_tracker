// import 'package:flutter/material.dart';
// import 'package:activity_tracker/res/app_colors.dart';
// import 'package:activity_tracker/res/app_dimension.dart';
// import 'package:activity_tracker/utils/app_utils.dart';

// class KErrorWidget extends StatelessWidget {
//   final VoidCallback? ontap;
//   final String? message;
//   const KErrorWidget({
//     super.key,
//     this.ontap,
//     this.message,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: AppDimensions.bigMargin),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           AppUtils.verticalSpacer(),
//           Assets.images.ohnobro.image(height: 200),
//           AppUtils.verticalSpacer(),
//           Text(
//             message ?? "Something Went Wrong.\nPlease try again",
//             style: context.textTheme.bodyMedium,
//             textAlign: TextAlign.center,
//           ),
//           AppUtils.verticalSpacer(),
//           ontap == null ? const SizedBox.shrink() : RetryButton(ontap: ontap),
//         ],
//       ),
//     );
//   }
// }
