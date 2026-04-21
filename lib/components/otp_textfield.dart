// import 'package:flutter/material.dart';
// import 'package:activity_tracker/res/app_colors.dart';
// import 'package:activity_tracker/res/app_dimension.dart';
// import 'package:activity_tracker/utils/app_utils.dart';

// class OtpTextField extends StatelessWidget {
//   const OtpTextField({
//     super.key,
//     this.validator,
//     this.controller,
//   });
//   final String? Function(String?)? validator;
//   final TextEditingController? controller;

//   @override
//   Widget build(BuildContext context) {
//     return PinCodeTextField(
//       autoFocus: true,
//       autoDisposeControllers: false,
//       controller: controller,
//       enableActiveFill: true,
//       onChanged: (value) {},
//       length: 4,
//       appContext: context,
//       keyboardType: TextInputType.number,
//       showCursor: false,
//       validator: validator,
//       textStyle: Theme.of(context).textTheme.bodyLarge,
//       pinTheme: PinTheme(
//         fieldHeight: AppDimensions.largeSize,
//         fieldWidth: AppDimensions.largeSize,
//         shape: PinCodeFieldShape.circle,
//         borderWidth: 1.0,
//         inactiveColor: AppColors.colorPrimary,
//         selectedColor: AppColors.colorPrimary,
//         activeColor: AppColors.colorPrimary,
//         activeFillColor: AppColors.colorWhite,
//         inactiveFillColor: AppColors.colorWhite,
//         selectedFillColor: AppColors.colorWhite,
//       ),
//     );
//   }
// }
