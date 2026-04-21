// import 'package:clipboard/clipboard.dart';
// import 'package:flutter/material.dart';
// import 'package:jyothy_jconnect/res/res.dart';
// import 'package:jyothy_jconnect/utils/utils.dart';

// class CopyTextWidget extends StatelessWidget {
//   const CopyTextWidget({
//     super.key,
//     required this.text,
//     this.title = 'Copy Link',
//   });
//   final String? text;
//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         if (text == null) return;
//         FlutterClipboard.copy(text ?? '').then((value) =>
//             ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Copied to Clipboard!'))));
//       },
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.copy_outlined, size: 15.0),
//           AppUtils.horizontalSpacer(width: AppDimensions.smallMargin),
//           Text(title, style: const TextStyle(fontSize: 10.0))
//         ],
//       ),
//     );
//   }
// }
