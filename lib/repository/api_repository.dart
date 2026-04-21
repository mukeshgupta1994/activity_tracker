import 'package:activity_tracker/data/api_end_points.dart';
import 'package:activity_tracker/data/remote/network/base_api_service.dart';
import 'package:activity_tracker/models/response_models/activity_details/activity_dropdown_response.dart';
import 'package:activity_tracker/models/response_models/activity_details/activity_dropdownupdate_response.dart';
import 'package:activity_tracker/models/response_models/agency_details/agency_update_response.dart';
import 'package:activity_tracker/models/response_models/execution_details/execution_details_response.dart';
import 'package:activity_tracker/models/response_models/send_otp/send_otp.dart';
import 'package:activity_tracker/models/response_models/authorisation_details/authorisation_document_update_response.dart';
import 'package:activity_tracker/models/response_models/authorisation_details/authorisation_document_view_response.dart';
import 'package:activity_tracker/models/response_models/supporting_documents_details/supporting_update_response.dart';
import 'package:activity_tracker/models/response_models/supporting_documents_details/supporting_view_response.dart';
import 'package:activity_tracker/models/response_models/verify_otp/verify_otp.dart';
import 'package:activity_tracker/view/login%20screen/login_screen.dart';
import 'package:flutter/material.dart';

class ApiRepository {
  final BaseApiService apiService;

  ApiRepository(this.apiService);

  // Future<LoginResponse?> login({
  //   required String? userName,
  //   required String? password,
  //   required double? lat,
  //   required double? long,
  // }) async {
  //   try {
  //     final response = await apiService.post(
  //       ApiEndPoints.groupMeetingUserDetails1,
  //       data: {
  //         "Username": userName,
  //         "Password": password,
  //         "Latitude": lat,
  //         "Longitude": long,
  //       },
  //     );
  //     return LoginResponse.fromJson(response);
  //   } catch (e) {
  //     debugPrint("Exception: $e");
  //     rethrow;
  //   }
  // }

  Future<SendOtpResponse?> getSendOtpDetails({required String? phoneNo}) async {
    try {
      final response = await apiService.post(
        ApiEndPoints.activitytrackerSendOTP,
        data: {"MobileNo": phoneNo},
      );
      return SendOtpResponse.fromJson(response);
    } catch (e) {
      debugPrint("Exception: $e");
      rethrow;
    }
  }

  Future<VerifyOtpResponse?> getVerifyOtpDetails({
    required String? phoneNo,
    required int? otp,
    required String? fcmId,
  }) async {
    try {
      final response = await apiService.post(
        ApiEndPoints.activitytrackerVerifyOtp,
        data: {"MobileNo": phoneNo, "OTP": otp, "FireBaseTokenID": fcmId},
      );
      return VerifyOtpResponse.fromJson(response);
    } catch (e) {
      debugPrint("Exception: $e");
      rethrow;
    }
  }

  Future<ActivityUpdateDetailsResponse?> getActivityDropDownUpdateDetails({
    required int? pKAMID,
    required String? sectionType,
    required String? activityID,
    required int? brandtypeID,
    required String? campaignName,
    required int? productTypeID,
    required int? activityStatusTypeID,
    required String? documentDate,
    required String? activityPeriodFrom,
    required String? activityPeriodTo,
    required String? userID,
    required String? type,
    required String? attribute1,
    required String? attribute2,
    required String? attribute3,
    required String? attribute4,
  }) async {
    try {
      final response = await apiService.post(
        ApiEndPoints.activityUpdateDetails,
        data: {
          "PKAMID": pKAMID,
          "SectionType": sectionType,
          "ActivityID": activityID,
          "BrandTypeID": brandtypeID,
          "CampaignName": campaignName,
          "ProductTypeID": productTypeID,
          "ActivityStatusTypeID": activityStatusTypeID,
          "DocumentDate": documentDate,
          "ActivityPeriodFrom": activityPeriodFrom,
          "ActivityPeriodTo": activityPeriodTo,
          "UserID": userID,
          "Type": type,
          "Attribute1": attribute1,
          "Attribute2": attribute2,
          "Attribute3": attribute3,
          "Attribute4": attribute4,
        },
      );
      return ActivityUpdateDetailsResponse.fromJson(response);
    } catch (e) {
      debugPrint("Exception: $e");
      rethrow;
    }
  }

  Future<ActivityDropDownDetailsResponse?> getActivityDropDownDetails({
    required String? userID,
    required String? type,
    required String? attribute1,
    required String? attribute2,
    required String? attribute3,
    required String? attribute4,
  }) async {
    try {
      final response = await apiService.post(
        ApiEndPoints.activityDropDownDetails,
        data: {
          "UserID": userID,
          "Type": type,
          "Attribute1": attribute1,
          "Attribute2": attribute2,
          "Attribute3": attribute3,
          "Attribute4": attribute4,
        },
      );
      return ActivityDropDownDetailsResponse.fromJson(response);
    } catch (e) {
      debugPrint("Exception: $e");
      rethrow;
    }
  }

  Future<AgencyPartnerUpdateResponse> getAgencyUpdateDetails({
    required int? agencyID,
    required int? activityID,
    required String? agencyPartnerName,
    required int? agencyType,
    required String? aPRole,
    required int? planSpends,
    required int? finalSpends,
    required String? userID,
    required String? mediumType,
    required String? vehicle,
    required String? type,
  }) async {
    try {
      final response = await apiService.post(
        ApiEndPoints.agencyupdateDetails,
        data: {
          "AgencyID": agencyID,
          "ActivityID": activityID,
          "AgencyPartnerName": agencyPartnerName,
          "AgencyType": agencyType,
          "AP_Role": aPRole,
          "PlanSpends": planSpends,
          "FinalSpends": finalSpends,
          "UserID": userID,
          "MediumType": mediumType,
          "Vehicle": vehicle,
          "Type": type,
        },
      );
      return AgencyPartnerUpdateResponse.fromJson(response);
    } catch (e) {
      debugPrint("Exception: $e");
      rethrow;
    }
  }

  Future<ExecutionUpdateResponse?> getExecutionUpdateDetails({
    required int? executionElementID,
    required int? activityID,
    required String? userID,
    required String? executionElements,
    required String? elementName,
    required String? executionDescription,
    required String? executionDateFrom,
    required String? executionDateTo,
    required String? type,
  }) async {
    try {
      final response = await apiService.post(
        ApiEndPoints.executionupdateDetails,
        data: {
          "ExecutionElementID": executionElementID,
          "ActivityID": activityID,
          "UserID": userID,
          "ExecutionElements": executionElements,
          "ElementName": elementName,
          "ExecutionDescription": executionDescription,
          "ExecutionDateFrom": executionDateFrom,
          "ExecutionDateTo": executionDateTo,
          "Type": type,
        },
      );
      return ExecutionUpdateResponse.fromJson(response);
    } catch (e) {
      debugPrint("Exception: $e");
      rethrow;
    }
  }

  Future<AddUpdateAuthorisationDocuments?> getAuthorisationUpdateDetails({
    required int? documentID,
    required int? activityID,
    required String? userID,
    required String? authDescription,
    required String? fileInputAuthExt,
    required String? fileInputAuth,
  }) async {
    try {
      final response = await apiService.post(
        ApiEndPoints.authorisationupdateDetails,
        data: {
          "DocumentID": documentID,
          "ActivityID": activityID,
          "UserID": userID,
          "AuthDescription": authDescription,
          "FileInputAuthExt": fileInputAuthExt,
          "FileInputAuth": fileInputAuth,
        },
      );
      return AddUpdateAuthorisationDocuments.fromJson(response);
    } catch (e) {
      debugPrint("Exception: $e");
      rethrow;
    }
  }

  Future<ViewAuthorisationDocumentsResponse?> getAuthorisationViewDetails({
    required int? documentID,
    required int? activityID,
    required String? userID,
    required String? type,
  }) async {
    try {
      final response = await apiService.post(
        ApiEndPoints.authorisationviewDetails,
        data: {
          "DocumentID": documentID,
          "ActivityID": activityID,
          "UserID": userID,
          "Type": type,
        },
      );
      return ViewAuthorisationDocumentsResponse.fromJson(response);
    } catch (e) {
      debugPrint("Exception: $e");
      rethrow;
    }
  }

  Future<AddUpdateSupportingDocumentsResponse?> getSupportingUpdateDetails({
    required int? supportID,
    required int? activityID,
    required String? userID,
    required String? supDescription,
    required String? fileInputSupExt,
    required String? fileInputSup,
  }) async {
    try {
      final response = await apiService.post(
        ApiEndPoints.supportingupdateDetails,
        data: {
          "SupportID": supportID,
          "ActivityID": activityID,
          "UserID": userID,
          "SupDescription": supDescription,
          "FileInputSupExt": fileInputSupExt,
          "FileInputSup": fileInputSup,
        },
      );
      return AddUpdateSupportingDocumentsResponse.fromJson(response);
    } catch (e) {
      debugPrint("Exception: $e");
      rethrow;
    }
  }

  Future<ViewSupportingDocumentsResponse?> getSupportingViewDetails({
    required int? supportID,
    required int? activityID,
    required String? userID,
    required String? type,
  }) async {
    try {
      final response = await apiService.post(
        ApiEndPoints.supportingviewDetails,
        data: {
          "SupportID": supportID,
          "ActivityID": activityID,
          "UserID": userID,
          "Type": type,
        },
      );
      return ViewSupportingDocumentsResponse.fromJson(response);
    } catch (e) {
      debugPrint("Exception: $e");
      rethrow;
    }
  }
}
