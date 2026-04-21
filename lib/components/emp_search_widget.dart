// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:activity_tracker/res/app_colors.dart';
// import 'package:activity_tracker/res/app_dimension.dart';
// import 'package:activity_tracker/utils/app_utils.dart';
// import 'package:provider/provider.dart';

// class EmpSearchWidget extends StatefulWidget {
//   const EmpSearchWidget({super.key});

//   @override
//   State<EmpSearchWidget> createState() => _EmpSearchWidgetState();
// }

// class _EmpSearchWidgetState extends State<EmpSearchWidget> {
//   final TextEditingController _textEditingController = TextEditingController();
//   late CommonViewModel _commonViewModel;
//   @override
//   void initState() {
//     super.initState();
//     _commonViewModel = context.read<CommonViewModel>();
//     WidgetsBinding.instance.addPostFrameCallback(
//       (timeStamp) => _commonViewModel.employeeSearchList = [],
//     );
//   }

//   Timer? _timer;
//   bool _isTyping = false;

//   void resetTimer() {
//     if (_isTyping) {
//       _timer?.cancel();
//     }
//     _isTyping = true;
//     _timer = Timer(const Duration(milliseconds: 600), () {
//       _isTyping = false;
//       if (_textEditingController.text.length < 2) {
//         _commonViewModel.employeeSearchList = [];
//         return;
//       }
//       _commonViewModel.getEmployeeSearchResults(_textEditingController.text);
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: DeviceUtils.getScaledHeight(context, 0.7),
//       child: Padding(
//         padding:
//             const EdgeInsets.symmetric(horizontal: AppDimensions.bigMargin),
//         child: Consumer<CommonViewModel>(
//           builder: (_, cvm, __) {
//             return Column(
//               children: [
//                 AppUtils.verticalSpacer(height: AppDimensions.mediumMargin),
//                 CustomizableTextField(
//                   textEditingController: _textEditingController,
//                   hintText: 'Enter User Name',
//                   prefixIconData: Icons.search,
//                   suffixIcon: cvm.employeeSearchStatus.status == Status.loading
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: Center(
//                               child: CircularProgressIndicator.adaptive()),
//                         )
//                       : cvm.employeeSearchList.isNotEmpty
//                           ? InkWell(
//                               onTap: () {
//                                 _textEditingController.clear();
//                                 _commonViewModel.employeeSearchList = [];
//                               },
//                               child: const Icon(Icons.close),
//                             )
//                           : null,
//                   isHintOnly: true,
//                   isDense: true,
//                   onChanged: (value) => resetTimer(),
//                 ),
//                 Expanded(
//                   child: Builder(
//                     builder: (ctx) {
//                       if (cvm.employeeSearchStatus.status != Status.completed) {
//                         return const SizedBox.shrink();
//                       }
//                       return ListView.separated(
//                         itemCount: cvm.employeeSearchList.length,
//                         itemBuilder: (context, index) {
//                           final item = cvm.employeeSearchList[index];
//                           return ListTile(
//                             title: Text(
//                               item.name ?? '',
//                               style: const TextStyle(
//                                 fontSize: 12.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             leading: CircleAvatar(
//                               backgroundColor: AppColors.colorPrimaryLight,
//                               child: Text(
//                                 (item.name ?? '')[0],
//                                 style: const TextStyle(
//                                   fontSize: 12.0,
//                                   color: AppColors.colorBlack,
//                                 ),
//                               ),
//                             ),
//                             trailing: const Icon(Icons.chevron_right),
//                             onTap: () => Navigator.pop(context, item),
//                           );
//                         },
//                         separatorBuilder: (context, index) =>
//                             AppUtils.verticalSpacer(),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
