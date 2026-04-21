// import 'package:activity_tracker/components/icon_action_button.dart';
// import 'package:activity_tracker/models/pick_file_model.dart';
// import 'package:activity_tracker/res/app_colors.dart';
// import 'package:activity_tracker/res/app_dimension.dart';
// import 'package:activity_tracker/utils/app_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:jyothy_jconnect/components/components.dart';
// import 'package:jyothy_jconnect/models/pick_file_model.dart';
// import 'package:jyothy_jconnect/res/res.dart';
// import 'package:jyothy_jconnect/utils/utils.dart';

// class CommonAttachmentAddWidget extends StatelessWidget {
//   const CommonAttachmentAddWidget({
//     super.key,
//     required this.attachemnt,
//     this.onFileSelected,
//     this.onDeleteSelected,
//   });
//   final PickFileModel? attachemnt;

//   final void Function(PickFileModel?)? onFileSelected;
//   final void Function(bool)? onDeleteSelected;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         vertical: AppDimensions.mediumMargin,
//         horizontal: AppDimensions.bigMargin,
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.colorYellow,
//         border: Border.all(color: AppColors.colorGrey),
//         borderRadius: BorderRadius.circular(
//           AppDimensions.smallBorderRadius,
//         ),
//       ),
//       child: attachemnt == null
//           ? Row(
//               children: [
//                 const Text(
//                   'Attachment (Optional)',
//                   style: TextStyle(
//                     color: AppColors.colorGrey,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Spacer(),
//                 ActionButton(
//                   text: 'Add',
//                   padding: const EdgeInsets.symmetric(
//                     vertical: AppDimensions.smallMargin,
//                     horizontal: AppDimensions.bigMargin,
//                   ),
//                   borderRadius: AppDimensions.verySmallBorderRadius,
//                   onTap: () async {
//                     if (onFileSelected == null) return;
//                     final file = await AppUtils.pickFile();
//                     onFileSelected!.call(file);
//                   },
//                 ),
//               ],
//             )
//           : Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     attachemnt?.fileName ?? 'Invalid Attachment',
//                     maxLines: 1,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 AppUtils.horizontalSpacer(),
//                 // IconActionButton(
//                 //   onTap: () async {
//                 //     if (onFileSelected == null) return;
//                 //     final file = await AppUtils.pickFile();
//                 //     onFileSelected!.call(file);
//                 //   },
//                 //   icon: const Icon(
//                 //     Icons.edit_outlined,
//                 //     size: 15.0,
//                 //   ),
//                 //   backgroundColor: AppColors.colorAccent,
//                 // ),
//                 AppUtils.horizontalSpacer(width: AppDimensions.bigMargin),
//                 IconActionButton(
//                   onTap: () async {
//                     if (onDeleteSelected == null) return;
//                     final isConfirm = await AppUtils.yesNoBottomSheet(
//                       context,
//                       title: 'Remove File',
//                       message: 'Do you want to remove selected file?',
//                     );
//                     onDeleteSelected!.call(isConfirm);
//                   },
//                   icon: const Icon(
//                     Icons.delete_outline,
//                     size: 15.0,
//                     color: AppColors.colorWhite,
//                   ),
//                   backgroundColor: AppColors.colorPrimary,
//                 ),
//               ],
//             ),
//     );
//   }
// }
