import 'dart:async';

import 'package:activity_tracker/data/remote/response/api_response.dart';
import 'package:activity_tracker/models/response_models/send_otp/send_otp.dart';
import 'package:activity_tracker/models/response_models/verify_otp/verify_otp.dart';
import 'package:activity_tracker/models/user_data/user_data.dart';
import 'package:activity_tracker/repository/api_repository.dart';
import 'package:activity_tracker/repository/db_repository.dart';
import 'package:activity_tracker/services/firebase/push_notification_service.dart';
import 'package:activity_tracker/utils/app_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final DbRepository dbRepository;
  final ApiRepository apiRepository;

  LoginViewModel({
    required this.dbRepository,
    required this.apiRepository,
  });

  bool get isLoggedIn =>
      dbRepository.userData?.userID != null &&
      dbRepository.userData?.userName != null;

  String? get userId => dbRepository.userData?.userID;

  UserData? get userData => dbRepository.userData;

  void logout() {
    PushNotificationService.deleteFcmId();
    dbRepository.clearAllData();
  }

  final sentOtpTextController = TextEditingController();
  void clearPhoneNoText() => sentOtpTextController.clear();

  ApiResponse<SendOtpResponse> sentOtpStatus = ApiResponse.none();

  void _setSendOtpStatus(ApiResponse<SendOtpResponse> response) {
    sentOtpStatus = response;
    notifyListeners();
  }

  Future<void> fetchSendOtp() async {
    _setSendOtpStatus(ApiResponse.loading());
    try {
      final result = await apiRepository.getSendOtpDetails(
        phoneNo: sentOtpTextController.text,
      );
      if (AppUtils.checkAPIStatusId(result?.result)) {
        _setSendOtpStatus(ApiResponse.completed(result));
        return;
      }
      _setSendOtpStatus(ApiResponse.error(result?.remarks));
      return;
    } catch (e) {
      _setSendOtpStatus(ApiResponse.error(e.toString()));
    }
  }

  final verifyOtpTextController = TextEditingController();
  void clearVerifyOtp() => verifyOtpTextController.clear();

  ApiResponse<VerifyOtpResponse> verifyOtpStatus = ApiResponse.none();

  void _setVerifyOtpStatus(ApiResponse<VerifyOtpResponse> response) {
    verifyOtpStatus = response;
    notifyListeners();
  }

  bool get _isVerifyTypedOtpIncorrect {
    if (verifyOtpTextController.text.isEmpty) {
      _setVerifyOtpStatus(ApiResponse.error('Please Enter OTP'));
      return true;
    }
    if (verifyOtpTextController.text.length < 4) {
      _setVerifyOtpStatus(ApiResponse.error('Invalid OTP'));
      return true;
    }
    return false;
  }

  Future<void> fetchVerifyOtp() async {
    if (_isVerifyTypedOtpIncorrect) return;
    _setVerifyOtpStatus(ApiResponse.loading());
    try {
      final fcmId = kIsWeb ? '' : await PushNotificationService.getFcmId();
      final result = await apiRepository.getVerifyOtpDetails(
        phoneNo: sentOtpTextController.text,
        fcmId: fcmId,
        otp: int.tryParse(verifyOtpTextController.text) ?? 0,
      );
      if (AppUtils.checkAPIStatusId(result?.result)) {
        final verifiedData = result?.verifyOTPActivationTrackerDetailsList?.first;
        if (verifiedData != null) {
          if (verifiedData.aTUserID != null && verifiedData.aTUserName != null) {
            final saveUserData = UserData(
              userID: verifiedData.aTUserID.toString(),
              userName: verifiedData.aTUserName,
              emailId: verifiedData.emailID,
              officeCode: verifiedData.signupReferalCode,
              mobileNo: verifiedData.mobileNo,
              designation: verifiedData.address,
            );
            dbRepository.saveUserData(userData: saveUserData);
            clearPhoneNoText();
            _setVerifyOtpStatus(ApiResponse.completed(result));
            return;
          }
        } else {
          _setVerifyOtpStatus(ApiResponse.error('No User Data'));
          return;
        }
      }
      _setVerifyOtpStatus(ApiResponse.error('Invalid OTP'));
      return;
    } catch (e) {
      _setVerifyOtpStatus(ApiResponse.error(e.toString()));
    }
  }

//*Timer for Resend OTP

  int _counter = 30;
  int get counter => _counter;
  Timer? _timer;

  void startTimer() {
    _counter = 30;
    notifyListeners();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (tick) {
        if (_counter > 0) {
          _counter--;
        } else {
          tick.cancel();
          cancelTimer();
        }
        notifyListeners();
      },
    );
  }

  Future<void> cancelTimer() async {
    _timer?.cancel();
    _timer = null;
  }
}
