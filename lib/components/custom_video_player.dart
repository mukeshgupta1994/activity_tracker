
// import 'package:activity_tracker/utils/routes/device_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:activity_tracker/res/app_colors.dart';
// import 'package:activity_tracker/res/app_dimension.dart';
// import 'package:activity_tracker/utils/app_utils.dart';

// class CustomVideoPlayer extends StatefulWidget {
//   const CustomVideoPlayer({
//     super.key,
//     required this.controller,
//   });
//   final VideoPlayerController controller;

//   @override
//   State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
// }

// class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
//   late ChewieController chewieController;
//   @override
//   void initState() {
//     super.initState();
//     widget.controller.initialize().whenComplete(() {
//       chewieController = ChewieController(
//         videoPlayerController: widget.controller,
//         allowFullScreen: true,
//         draggableProgressBar: true,
//         showOptions: true,
//         autoInitialize: true,
//         deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//         hideControlsTimer: const Duration(seconds: 2),
//       );
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.controller.value.isInitialized
//         ? SizedBox(
//             height: DeviceUtils.getScaledHeight(context, 0.4),
//             child: Chewie(controller: chewieController),
//           )
//         : _loader();
//   }

//   Column _loader() {
//     return Column(
//       children: [
//         const SizedBox(
//           height: 50,
//           width: 50,
//           child: Center(
//             child: CircularProgressIndicator.adaptive(),
//           ),
//         ),
//         AppUtils.verticalSpacer(height: AppDimensions.smallMargin),
//         const Text(
//           'Loading Video...',
//           style: TextStyle(
//             color: AppColors.colorGrey,
//           ),
//         )
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     chewieController.dispose();
//     widget.controller.dispose();
//     super.dispose();
//   }
// }
