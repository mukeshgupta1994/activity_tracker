import 'package:flutter/material.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';


//import 'package:jyothy_jconnect/main_app/res/res.dart';

class ModalBottomSheetWidget extends StatelessWidget {
  const ModalBottomSheetWidget({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.defaultMargin),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(AppDimensions.mediumBorderRadius),
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppDimensions.mediumBorderRadius),
                color: AppColors.colorWhite,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 5.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.mediumBorderRadius,
                        ),
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
