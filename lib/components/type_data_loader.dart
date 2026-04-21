// import 'package:activity_tracker/components/retry_button.dart';
// import 'package:activity_tracker/utils/app_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:jyothy_jconnect/components/components.dart';
// import 'package:jyothy_jconnect/data/remote/response/status.dart';
// import 'package:jyothy_jconnect/models/type_data.dart';
// import 'package:jyothy_jconnect/utils/utils.dart';

// class TypeDataLoader<T> extends StatelessWidget {
//   const TypeDataLoader({
//     super.key,
//     required this.type,
//     required this.child,
//     this.onRefresh,
//   });
//   final TypeData<T> type;
//   final Widget child;
//   final VoidCallback? onRefresh;

//   @override
//   Widget build(BuildContext context) {
//     return Builder(
//       builder: (context) => switch (type.apiResponse?.status) {
//         Status.loading =>
//           const Center(child: CircularProgressIndicator.adaptive()),
//         Status.completed => child,
//         Status.error => Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   type.apiResponse?.message ?? '',
//                   textAlign: TextAlign.center,
//                 ),
//                 AppUtils.verticalSpacer(),
//                 RetryButton(ontap: onRefresh),
//               ],
//             ),
//           ),
//         _ => const SizedBox.shrink(),
//       },
//     );
//   }
// }
