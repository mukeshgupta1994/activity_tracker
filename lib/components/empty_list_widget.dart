// import 'package:flutter/material.dart';
// import 'package:activity_tracker/res/app_colors.dart';
// import 'package:activity_tracker/res/app_dimension.dart';
// import 'package:activity_tracker/utils/app_utils.dart';

// class EmptyListWidget extends StatelessWidget {
//   final VoidCallback? ontap;
//   final String? message;
//   final String assetImage;
//   const EmptyListWidget({
//     super.key,
//     this.ontap,
//     this.message,
//     this.assetImage = AppImagesAsset.emptyBoxPng,
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
//           Image.asset(
//             assetImage,
//             height: 100,
//           ),
//           AppUtils.verticalSpacer(),
//           Text(
//             message ?? "Data not Available!!",
//             textAlign: TextAlign.center,
//           ),
//           ontap == null
//               ? const SizedBox.shrink()
//               : IconButton(
//                   onPressed: ontap!,
//                   icon: const Icon(
//                     Icons.refresh,
//                     color: AppColors.colorGrey,
//                   ),
//                 )
//         ],
//       ),
//     );
//   }
// }
