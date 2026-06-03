// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:activity_tracker/components/closable_dialog_widget.dart';
import 'package:activity_tracker/components/confirmation_widget.dart';
import 'package:activity_tracker/components/confirmation_with_text_widget.dart';
import 'package:activity_tracker/components/confirmationdailog_widget.dart';
import 'package:activity_tracker/components/custom_date_picker_widget.dart';
import 'package:activity_tracker/components/custom_date_time_picker_widget.dart';
import 'package:activity_tracker/components/modal_bottom_sheet_widget.dart';
import 'package:activity_tracker/components/show_dailog_widget.dart';
import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_dimension.dart';
import 'package:activity_tracker/utils/routes/device_utils.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  AppUtils._();

  static Widget verticalSpacer({
    double height = AppDimensions.defaultMargin,
  }) =>
      SizedBox(height: height);

  static Widget horizontalSpacer({
    double width = AppDimensions.defaultMargin,
  }) =>
      SizedBox(width: width);

  static void systemOverUILayStyle(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: isIos ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: isIos ? Brightness.light : Brightness.dark,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  static bool get isIos => Platform.isIOS;

  static bool checkAPIStatusId(int? statusId) => statusId == 1;

  static bool convertToNonNullableBool(bool? value) => value ?? false;

  static void showSnackBar({
    required BuildContext context,
    required String message,
    Color? color,
    Duration duration = const Duration(
      seconds: 2,
    ),
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.mediumBorderRadius),
        ),
        content: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.colorWhite,
            ),
            horizontalSpacer(width: AppDimensions.mediumMargin),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: color ?? Colors.green,
        duration: duration,
      ),
    );
  }

  static bool isContains({
    required String? mainValue,
    required String? searchValue,
  }) {
    final String sValue = searchValue?.toLowerCase() ?? '';
    final String mValue = mainValue?.toLowerCase() ?? '';
    if (mValue.contains(sValue)) {
      return true;
    }
    return false;
  }

  static bool isAnyFieldContains({
    required List<String?> fields,
    required String? searchKey,
  }) {
    if (searchKey == null) {
      return false;
    }

    for (final field in fields) {
      if (field != null &&
          isContains(mainValue: field, searchValue: searchKey)) {
        return true;
      }
    }

    return false;
  }

  static List<BoxShadow> boxShadows({double blurRadius = 20.0}) => [
        BoxShadow(
          color: Colors.grey[400] ?? Colors.grey,
          blurRadius: blurRadius,
        ),
      ];

  static String convertDateTimeString(String dateString) =>
      DateFormat.yMMMMd().format(DateTime.parse(dateString));

  static String convertUTCtoHmma(String date) =>
      DateFormat('h:mm\na').format(DateTime.parse(date));

  static String getPartOfDay(DateTime dateTime) {
    int hour = dateTime.hour;
    if (hour >= 5 && hour < 12) {
      return 'Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Afternoon';
    } else if (hour >= 17 && hour < 20) {
      return 'Evening';
    } else {
      return 'Night';
    }
  }

  static Future<void> launchToUrl(BuildContext context, String url) async {
    if (kIsWeb) {
      launchUrl(Uri.parse(addUrlSchemeIfMissing(url.trim())),
          mode: LaunchMode.externalApplication);
      return;
    }
    if (!await launchUrl(Uri.parse(addUrlSchemeIfMissing(url.trim())),
        mode: LaunchMode.externalApplication)) {
      AppUtils.showSnackBar(
        context: context,
        message: 'Could not launch url',
        color: Colors.red,
      );
      return;
    }
  }

  static String addUrlSchemeIfMissing(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    return url;
  }

  static Future<void> launchMail(BuildContext context, String mailId) async {
    if (!await launchUrl(
        Uri(
          scheme: 'mailto',
          path: mailId,
        ),
        mode: LaunchMode.externalApplication)) {
      AppUtils.showSnackBar(
        context: context,
        message: 'Could not launch mail',
        color: Colors.red,
      );
      return;
    }
  }

  static Future<void> launchCall(BuildContext context, String mailId) async {
    if (!await launchUrl(
        Uri(
          scheme: 'tel',
          path: mailId,
        ),
        mode: LaunchMode.externalApplication)) {
      AppUtils.showSnackBar(
        context: context,
        message: 'Could not launch call',
        color: Colors.red,
      );
      return;
    }
  }

  static Future<bool> yesNoBottomSheet(
    context, {
    String? title,
    String? message,
    bool isConfirmationPrimary = true,
  }) async =>
      await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return ModalBottomSheetWidget(
            child: ConfirmationWidget(
              title: title ?? '',
              message: message ?? '',
              confirmButtonText: 'Yes',
              cancelButtonText: 'No',
              isConfirmationPrimary: isConfirmationPrimary,
            ),
          );
        },
      ) ??
      false;

  static Future<bool?> yesNoBottomSheet2(
    context, {
    String? title,
    String? message,
    bool isConfirmationPrimary = true,
  }) async =>
      await showModalBottomSheet<bool?>(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return ModalBottomSheetWidget(
            child: ConfirmationWidget(
              title: title ?? '',
              message: message ?? '',
              confirmButtonText: 'Yes',
              cancelButtonText: 'No',
              isConfirmationPrimary: isConfirmationPrimary,
            ),
          );
        },
      );

  static void restartApp(BuildContext context) {
   // context.go(AppRoutes.splashScreenRoute);
  }

  static Future<T?> customModalBottomSheet<T>(
    context, {
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) async =>
      await showModalBottomSheet<T?>(
        context: context,
        isScrollControlled: isScrollControlled,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => ModalBottomSheetWidget(child: child),
      );

  static Future<T> loaderForFuture<T>(
    BuildContext cx,
    Future<T>? future, {
    String? message,
    bool isDismissable = false,
  }) async {
    return await showDialog(
      context: cx,
      barrierDismissible: false,
      builder: (ctx) {
        future?.then(
          (value) => Navigator.of(ctx).maybePop(value),
        );
        return Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator.adaptive(),
              ),
              AppUtils.verticalSpacer(height: AppDimensions.mediumMargin),
              Text(message ?? ''),
            ],
          ),
        );
      },
    );
  }

  static Future<T> bottomSheetLoaderForFuture<T>(
    BuildContext cx,
    Future<T>? future, {
    String? message,
    bool isDismissable = false,
  }) async {
    return await showModalBottomSheet(
      context: cx,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        future?.then(
          (value) => Navigator.of(ctx).maybePop(value),
        );
        return bottomSheetLoader(
          message: message,
          onExitTap:
              isDismissable ? () => Navigator.of(ctx).maybePop(null) : null,
        );
      },
    );
  }

  static Widget bottomSheetLoader({
    String? message,
    VoidCallback? onExitTap,
  }) =>
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 8.0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 17.0,
                  horizontal: 15.0,
                ),
                child: Row(
                  children: [
                    const FittedBox(
                      child: CircularProgressIndicator(),
                    ),
                    horizontalSpacer(width: AppDimensions.defaultMargin),
                    Expanded(
                      child: Text(
                        message ?? "Please Wait...",
                        style: TextStyle(
                          color: AppColors.colorPrimaryGradientEnd,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onExitTap == null
                        ? const SizedBox.shrink()
                        : InkWell(
                            onTap: onExitTap,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.colorAccent,
                              ),
                              padding: const EdgeInsets.all(
                                  AppDimensions.smallMargin),
                              child: Icon(
                                Icons.close,
                                color: AppColors.colorPrimaryGradientEnd,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  static Future<void> showAwsomeDialog(
    BuildContext context, {
    String? title,
    String? desc,
    VoidCallback? btnOkOnPress,
    Color btnOkColor = AppColors.colorPrimary,
    DialogType dialogType = DialogType.success,
    Widget? child,
  }) =>
      AwesomeDialog(
        context: context,
        btnOkColor: btnOkColor,
        width: DeviceUtils.getDeviceType(context) == DeviceType.mobile
            ? null
            : 500,
        dialogType: dialogType,
        animType: AnimType.scale,
        autoDismiss: true,
        headerAnimationLoop: false,
        title: title,
        desc: desc,
        body: child,
        btnOkOnPress: btnOkOnPress ?? () {},
        dialogBackgroundColor: AppColors.colorWhite,
      ).show();

  static Future<void> showAwsomeDialog2(
    BuildContext context, {
    String? title,
    String? desc,
    VoidCallback? btnOkOnPress,
    String? confirmButtonText,
    String? cancelButtonText,
    Color btnOkColor = AppColors.colorPrimary,
    DialogType dialogType = DialogType.success,
  }) =>
      showGeneralDialog(
          barrierDismissible: false,
          barrierLabel: "AnimatedDialog",
          barrierColor: Colors.black54,
          context: context,
          transitionDuration: Duration(milliseconds: 100),
          pageBuilder: (context, anim1, anim2) {
            return ShowDialogWidget(
                builder: (context, controller) => ConfirmationDialogWidget(
                    assetName: _getDialogAsset(dialogType),
                    title: title ?? '',
                    message: desc ?? '',
                    color: _getDailogColor(dialogType),
                    confirmButtonText: confirmButtonText,
                    cancelButtonText: cancelButtonText,
                    animationController: controller));
          });

  static String _getDialogAsset(DialogType type) {
    return switch (type) {
      DialogType.error => "assets/images/errors.png",
      DialogType.success => "assets/images/success.png",
      DialogType.warning => "assets/images/warning.png",
      _ => "assets/images/errors.png",
    };
  }

  static Color _getDailogColor(DialogType color) {
    return switch (color) {
      DialogType.error => Colors.red,
      DialogType.success => Colors.green,
      DialogType.warning => Color.fromARGB(255, 168, 155, 43),
      _ => Colors.red,
    };
  }

  static Future<bool> confirmationWithTextModalBottomSheet(
    context, {
    String? title,
    String? message,
    bool isStrictValidate = false,
    TextEditingController? textEditingController,
    String hintText = 'Remarks',
  }) async =>
      await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return ModalBottomSheetWidget(
            child: ConfirmationWithTextWidget(
              title: title ?? '',
              message: message ?? '',
              confirmButtonText: 'Yes',
              cancelButtonText: 'No',
              isStrictValidate: isStrictValidate,
              textEditingController: textEditingController,
              hintText: hintText,
            ),
          );
        },
      ) ??
      false;

  // static Future<PickFileModel?> pickFile({
  //   List<String>? allowedExtensions,
  //   FileType type = FileType.any,
  // }) async {
  //   try {
  //     final picked = await FilePicker.platform.pickFiles(
  //       type: type,
  //       allowMultiple: false,
  //       allowedExtensions: allowedExtensions,
  //     );
  //     if (picked != null) {
  //       if (kIsWeb) {
  //         final Uint8List? fileBytes = picked.files.first.bytes;
  //         return PickFileModel(
  //           base64Text: base64Encode(fileBytes ?? []),
  //           fileName: picked.files.first.name,
  //           ext: picked.files.first.extension,
  //         );
  //       }
  //       final filePath = picked.files.single.path;
  //       if (filePath == null) return null;
  //       final file = File(filePath);
  //       final base64String = base64Encode(await file.readAsBytes());
  //       return PickFileModel(
  //         base64Text: base64String,
  //         fileName: filePath.fileName,
  //         ext: filePath.fileExtension,
  //       );
  //     }
  //     return null;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  static String? getFilenameFromUrl(String? url) {
    if (url == null || url.isEmpty) {
      return null;
    }
    Uri uri = Uri.parse(url);
    List<String> segments = uri.pathSegments;
    return segments.isNotEmpty ? segments.last : null;
  }

  static Color assignIndicatorColor(String type) =>
      switch (type.toLowerCase()) {
        'pending' => AppColors.colorOrange,
        'approved' => AppColors.colorGreen,
        'created' => AppColors.colorGreen,
        _ => AppColors.colorRed
      };

  static bool checkIfFutureDate(String? dateTimeString) {
    if (dateTimeString == null) {
      return false; // Or handle null as per your requirements
    }

    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(dateTimeString);
    } catch (e) {
      return false; // Handle invalid date format
    }

    return parsedDate.isAfter(DateTime.now());
  }

  static bool checkIfFutureDateAndToday(String? dateTimeString) {
    if (dateTimeString == null) {
      return false; // Or handle null as per your requirements
    }

    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(dateTimeString);
    } catch (e) {
      return false; // Handle invalid date format
    }

    // if (checkIsToday(parsedDate)) return true;

    return parsedDate.isAfter(DateTime.now());
  }

  static bool checkIfToday(String? dateTimeString) {
    if (dateTimeString == null) {
      return false;
    }
    try {
      DateTime.parse(dateTimeString); // validate format only
    } catch (e) {
      return false;
    }
    // if (checkIsToday(parsedDate)) return true;
    return false;
  }

  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static String getTimeFromDateTimeString(String? dateTimeString) {
    if (dateTimeString == null) {
      return 'Invalid date';
    }

    DateTime dateTime;
    try {
      dateTime = DateTime.parse(dateTimeString);
    } catch (e) {
      return 'Invalid date';
    }

    return DateFormat('hh:mm a').format(dateTime);
  }

  static String formatDateTimeToTimeString(DateTime? dateTime) {
    if (dateTime == null) {
      return 'NA';
    }

    return DateFormat('hh:mm a').format(dateTime);
  }

  static Future<void> runVoidFuturesSequentially(
      List<Future Function()> functions) async {
    for (var function in functions) {
      await function();
    }
  }

  static TimeOfDay? dateTimeToTimeOfDay(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  static DateTime? timeOfDayToDateTime(
      TimeOfDay? timeOfDay, DateTime? referenceDate) {
    if (timeOfDay == null || referenceDate == null) {
      return null;
    }
    return DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  static DateTime? parseDate(String? date) => DateTime.tryParse(date!);

  static String musterMask(int? hex) => switch (hex) {
        0xffaaf0c1 => 'Present',
        0xffffe5e5 => 'First Half',
        0xffeee7c8 => 'Second Half',
        0xff82c6d5 => 'Week Off',
        0xffd68484 => 'Absent',
        0xffb4bcc2 => 'Holiday',
        0xffffa48c => 'Leave',
        0xffD397F8 => 'Outdoor Duty',
        _ => 'N/A',
      };

  static Color hexToColor(String? hexString) {
    try {
      return Color(
          int.parse(hexString?.replaceFirst('#', '0xff') ?? '0xffFFFFFF'));
    } catch (e) {
      return AppColors.colorWhite;
    }
  }

  static int? hexToInt(String? hexString) =>
      int.tryParse(hexString?.replaceFirst('#', '0xff') ?? '0xffFFFFFF') ?? 0;

  static bool isDarkMusterMaskColor(int? hex) => switch (hex) {
        0xff2e2e2e => true,
        _ => false,
      };

  static Future<DateTime?> customTimePicker(
    BuildContext context, {
    required DateTime time,
    DateTime? firstDate,
    DateTime? lastDate,
    CupertinoDatePickerMode datePickerMode = CupertinoDatePickerMode.date,
  }) =>
      kIsWeb
          ? materialTimePicker(
              context,
              time: time,
              firstDate: firstDate,
              lastDate: lastDate,
            )
          : customModalBottomSheet<DateTime?>(
              context,
              child: CustomDateOrTimePickerWidget(
                dateTime: time,
                datePickerMode: datePickerMode,
                firstDate: firstDate,
                lastDate: lastDate,
              ),
            );

  static Future<DateTime?> materialTimePicker(
    BuildContext context, {
    required DateTime time,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    try {
      final timeOfDay = await defultSystemTimePicker(
        context: context,
        initialTime: dateTimeToTimeOfDay(time) ?? TimeOfDay.now(),
        startTime: dateTimeToTimeOfDay(firstDate),
        endTime: dateTimeToTimeOfDay(time),
      );

      return timeOfDayToDateTime(timeOfDay, time);
    } catch (e) {
      return null;
    }
  }

  static Future<TimeOfDay?> defultSystemTimePicker({
    required BuildContext context,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    required TimeOfDay initialTime,
  }) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      return pickedTime;
    } else {
      return null;
    }
  }

  static Future<DateTime?> customDatePicker(
    BuildContext context, {
    required DateTime time,
    DateTime? firstDate,
    DateTime? lastDate,
     bool Function(DateTime)? selectableDayPredicate, 
  }) =>
      customModalBottomSheet<DateTime?>(
        context,
        child: CustomDatePickerWidget(
          dateTime: time,
          firstDate: firstDate,
          lastDate: lastDate,
           selectableDayPredicate: selectableDayPredicate, 
        ),
      );

      

  static String insertNewlines(String input) {
    return input.replaceAll(' ', '\n');
  }

  // static void launchWebView(BuildContext context, String url, String title) =>
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => WebViewScreen(url: url, title: title),
  //       ),
  //     );

  static bool hasText(String? text) =>
      text != null && convertToNonNullableBool(text.trim().isNotEmpty);

  static String commaSeperatedList(List<String?> list) {
    try {
      return list.join(',');
    } catch (e) {
      return '';
    }
  }

  static Future<String?> appVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      return null;
    }
  }

  static String getApproverTitle(String? status) => switch (status) {
        'Pending' => '$status with',
        _ => '$status by',
      };

  static double convertPercentage0to1(dynamic percent) {
    try {
      if (percent == null) return 0.0;
      if (percent is int) return percent.toDouble() / 100;
      if (percent is double) return percent / 100;
      if (percent is String) return double.parse(percent) / 100;
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  static Future<T?> showClosableDialog<T>(
    BuildContext context, {
    required Widget child,
    void Function()? onCloseTap,
    bool showClosed = true,
  }) =>
      showDialog(
          context: context,
          builder: (ctx) {
            return ClosableDialogWidget(
              onCloseTap: onCloseTap,
              showClosed: showClosed,
              child: child,
            );
          });

  static Type identifyStringType(String input) {
    if (input.isEmpty) {
      return String;
    }
    if (int.tryParse(input) != null) {
      return int;
    } else if (double.tryParse(input) != null) {
      return double;
    } else {
      return String;
    }
  }

  static String formatDouble(double value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toString();
}
