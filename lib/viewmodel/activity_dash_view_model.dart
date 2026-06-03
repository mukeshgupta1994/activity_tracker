import 'package:activity_tracker/data/remote/response/api_response.dart';
import 'package:activity_tracker/models/response_models/activity_dashboard/Activation_DashBoard_Response.dart';
import 'package:activity_tracker/models/response_models/activity_details/activity_dropdown_response.dart';
import 'package:activity_tracker/models/response_models/activity_details/activity_dropdownupdate_response.dart';
import 'package:activity_tracker/models/response_models/agency_details/agency_update_response.dart';
import 'package:activity_tracker/models/response_models/execution_details/execution_details_response.dart';
import 'package:activity_tracker/models/response_models/authorisation_details/authorisation_document_view_response.dart';
import 'package:activity_tracker/models/response_models/supporting_documents_details/supporting_view_response.dart';
import 'package:activity_tracker/repository/api_repository.dart';
import 'package:activity_tracker/repository/db_repository.dart';
import 'package:activity_tracker/utils/app_utils.dart';
import 'package:flutter/foundation.dart';

class ActivityDashViewModel extends ChangeNotifier {
  final DbRepository dbRepository;
  final ApiRepository apiRepository;

  ActivityDashViewModel({
    required this.dbRepository,
    required this.apiRepository,
  });

  // ================== UPDATE API DATA ==================
  List<ActivityTrackerUpdateActivityDetailsList> _activityList = [];
  List<ActivityTrackerUpdateActivityDetailsList> get activityList =>
      _activityList;

  ApiResponse<ActivityUpdateDetailsResponse> _updateStatus = ApiResponse.none();
  ApiResponse<ActivityUpdateDetailsResponse> get updateStatus => _updateStatus;

  void _updateApiStatus(ApiResponse<ActivityUpdateDetailsResponse> status) {
    _updateStatus = status;
    notifyListeners();
  }

  String _campaignName = '';
  String _documentDate = '';
  String _periodFrom = '';
  String _periodTo = '';

  String get campaignName => _campaignName;
  String get documentDate => _documentDate;
  String get periodFrom => _periodFrom;
  String get periodTo => _periodTo;

  void setCampaignName(String value) {
    _campaignName = value;
    notifyListeners();
  }

  void setDocumentDate(String value) {
    _documentDate = value;
    notifyListeners();
  }

  void setPeriodFrom(String value) {
    _periodFrom = value;
    notifyListeners();
  }

  void setPeriodTo(String value) {
    _periodTo = value;
    notifyListeners();
  }

  // Also add these resets inside clearAll():
  //   _campaignName = '';
  //   _documentDate = '';
  //   _periodFrom = '';
  //   _periodTo = '';
  //   _vehicle = '';

  String _vehicle = '';
  String get vehicle => _vehicle;

  void setVehicle(String value) {
    _vehicle = value;
    notifyListeners();
  }

  // ================== DROPDOWN API ==================
  ApiResponse<ActivityDropDownDetailsResponse> _dropDownStatus =
      ApiResponse.none();
  ApiResponse<ActivityDropDownDetailsResponse> get dropDownStatus =>
      _dropDownStatus;

  void _setDropDownStatus(ApiResponse<ActivityDropDownDetailsResponse> status) {
    _dropDownStatus = status;
    notifyListeners();
  }

  // ================== DROPDOWN LISTS ==================
  List<BrandTypeDetailsList> _brandList = [];
  List<ProductTypeDetailsList> _productList = [];
  List<ActivityStatusTypeDetailsList> _statusList = [];
  List<StateTypeDetailsList> _stateList = [];

  List<BrandTypeDetailsList> get brandList => _brandList;
  List<ProductTypeDetailsList> get productList => _productList;
  List<ActivityStatusTypeDetailsList> get statusList => _statusList;
  List<StateTypeDetailsList> get stateList => _stateList;

  // ================== SELECTED VALUES ==================
  BrandTypeDetailsList? _selectedBrand;
  ProductTypeDetailsList? _selectedProduct;
  ActivityStatusTypeDetailsList? _selectedStatus;
  StateTypeDetailsList? _selectedState;

  BrandTypeDetailsList? get selectedBrand => _selectedBrand;
  ProductTypeDetailsList? get selectedProduct => _selectedProduct;
  ActivityStatusTypeDetailsList? get selectedStatus => _selectedStatus;
  StateTypeDetailsList? get selectedState => _selectedState;

  List<MediumTypeDetailsList> _mediumList = [];
  List<MediumTypeDetailsList> get mediumList => _mediumList;

  List<MediumTypeDetailsList> _selectedMediums = [];
  List<MediumTypeDetailsList> get selectedMediums => _selectedMediums;

  List<AgencyTypeDetailsList> _agencyList = [];
  List<AgencyTypeDetailsList> get agencyList => _agencyList;

  List<AgencyTypeDetailsList> _selectedAgencies = [];
  List<AgencyTypeDetailsList> get selectedAgencies => _selectedAgencies;

  void setSelectedAgencies(List<AgencyTypeDetailsList> values) {
    _selectedAgencies = values;
    notifyListeners();
  }

  void setSelectedMediums(List<MediumTypeDetailsList> values) {
    _selectedMediums = values;
    notifyListeners();
  }

  void setSelectedBrand(BrandTypeDetailsList value) {
    _selectedBrand = value;
    notifyListeners();
  }

  void setSelectedProduct(ProductTypeDetailsList value) {
    _selectedProduct = value;
    notifyListeners();
  }

  void setSelectedStatus(ActivityStatusTypeDetailsList value) {
    _selectedStatus = value;
    notifyListeners();
  }

  void setSelectedState(StateTypeDetailsList value) {
    _selectedState = value;
    notifyListeners();
  }

  // ================== FETCH DROPDOWN ==================
  Future<void> getActivityDropDownDetails() async {
    _setDropDownStatus(ApiResponse.loading());

    try {
      final result = await apiRepository.getActivityDropDownDetails(
        userID: dbRepository.userData?.userID,
        type: "Insert_Activity",
        attribute1: "",
        attribute2: "",
        attribute3: "",
        attribute4: "",
      );

      if (result == null) {
        _setDropDownStatus(ApiResponse.error("Null response"));
        return;
      }

      if (AppUtils.checkAPIStatusId(result.result)) {
        _brandList = result.brandTypeDetailsList ?? [];
        _productList = result.productTypeDetailsList ?? [];
        _statusList = result.activityStatusTypeDetailsList ?? [];
        _stateList = result.stateTypeDetailsList ?? [];
        _mediumList = result.mediumTypeDetailsList ?? [];
        _agencyList = result.agencyTypeDetailsList ?? [];

        _setDropDownStatus(ApiResponse.completed(result));
      } else {
        _setDropDownStatus(ApiResponse.error(result.remarks ?? "Error"));
      }
    } catch (e) {
      _setDropDownStatus(ApiResponse.error(e.toString()));
    }
  }

  void clearAll() {
    _activityList.clear();
    _brandList.clear();
    _productList.clear();
    _statusList.clear();
    _stateList.clear();

    _selectedBrand = null;
    _selectedProduct = null;
    _selectedStatus = null;
    _selectedState = null;
    clearFormFields();
    _updateStatus = ApiResponse.none();
    _dropDownStatus = ApiResponse.none();
    _agencyList.clear();
    _selectedAgencies.clear();
    _mediumList.clear();
    _selectedMediums.clear();
    _vehicle = '';
    _agencyUpdateStatus = ApiResponse.none();
    // _dashboardList.clear();
    // _dashboardStatus = ApiResponse.none();
    notifyListeners();
  }

  // ===== FORM SUBMISSION =====
  Future<void> submitActivity() async {
    // Validate first
    if (!isFormValid) {
      _updateApiStatus(ApiResponse.error("Please fill all required fields"));
      return;
    }

    _updateApiStatus(ApiResponse.loading());

    try {
      final result = await apiRepository.getActivityDropDownUpdateDetails(
        pKAMID: 0,
        sectionType: "Marketing",
        activityID: "0",
        brandtypeID: selectedBrand!.brandID,
        campaignName: campaignName.trim(),
        productTypeID: selectedProduct!.productID,
        activityStatusTypeID: selectedStatus!.activityStatusID,
        documentDate: documentDate,
        activityPeriodFrom: periodFrom,
        activityPeriodTo: periodTo,
        userID: "1000830",
        //dbRepository.userData?.userID ?? "",
        type: "Insert_Activity",
        attribute1: "jsdbj",
        attribute2: "sjdhjh",
        attribute3: "jdhdjhf",
        attribute4: "dhfuhsf",
      );

      if (result == null) {
        _updateApiStatus(ApiResponse.error("Null response from server"));
        return;
      }

      if (AppUtils.checkAPIStatusId(result.result)) {
        // Success: Add to local list
        _activityList = result.activityTrackerUpdateActivityDetailsList ?? [];
        _updateApiStatus(ApiResponse.completed(result));
      } else {
        _updateApiStatus(ApiResponse.error(result.remarks ?? "Save failed"));
      }
    } catch (e) {
      _updateApiStatus(ApiResponse.error("Network error: ${e.toString()}"));
    }
  }

  // ===== VALIDATION GETTER ===== (same place pe add)
  bool get isFormValid =>
      selectedBrand != null &&
      selectedProduct != null &&
      selectedStatus != null &&
      campaignName.trim().isNotEmpty &&
      documentDate.isNotEmpty &&
      periodFrom.isNotEmpty &&
      periodTo.isNotEmpty;

  // ===== CLEAR FORM AFTER SUCCESS =====
  void clearFormFields() {
    _campaignName = '';
    _documentDate = '';
    _periodFrom = '';
    _periodTo = '';
    notifyListeners();
  }

  ApiResponse<AgencyPartnerUpdateResponse> _agencyUpdateStatus =
      ApiResponse.none();
  ApiResponse<AgencyPartnerUpdateResponse> get agencyUpdateStatus =>
      _agencyUpdateStatus;

  void _setAgencyUpdateStatus(ApiResponse<AgencyPartnerUpdateResponse> status) {
    _agencyUpdateStatus = status;
    notifyListeners();
  }

  Future<void> submitAgencyPartners(List<Map<String, String>> partners) async {
    _setAgencyUpdateStatus(ApiResponse.loading());

    try {
      for (var p in partners) {
        final agencyID = int.tryParse(p['agencyID'] ?? '');
        final mediumID = int.tryParse(p['mediumID'] ?? '');

        if (agencyID == null || mediumID == null) {
          throw Exception("Please select Agency & Medium properly");
        }

        await apiRepository.getAgencyUpdateDetails(
          agencyID: 0,

          activityID: activityList.isNotEmpty
              ? int.tryParse(activityList.first.activityID ?? '0')
              : 0,

          agencyPartnerName: p['Agency'],

          agencyType: agencyID,

          aPRole: p['Description'],

          planSpends:
              int.tryParse(
                p['Spends']?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0',
              ) ??
              0,

          finalSpends: 0,

          userID: dbRepository.userData?.userID,

          mediumType: mediumID.toString(),

          vehicle: p['Vehicle'],

          type: "Insert",
        );
      }

      _setAgencyUpdateStatus(ApiResponse.completed(null));
    } catch (e) {
      _setAgencyUpdateStatus(ApiResponse.error(e.toString()));
    }
  }

  // ================= EXECUTION UPDATE ==================
  ApiResponse<ExecutionUpdateResponse> _executionUpdateStatus =
      ApiResponse.none();

  ApiResponse<ExecutionUpdateResponse> get executionUpdateStatus =>
      _executionUpdateStatus;

  void _setExecutionUpdateStatus(ApiResponse<ExecutionUpdateResponse> status) {
    _executionUpdateStatus = status;
    notifyListeners();
  }

  Future<void> submitExecutionElements(
    List<Map<String, String>> elements,
  ) async {
    _setExecutionUpdateStatus(ApiResponse.loading());

    try {
      for (var e in elements) {
        await apiRepository.getExecutionUpdateDetails(
          executionElementID: 0,
          activityID: activityList.isNotEmpty
              ? int.tryParse(activityList.first.activityID ?? '0')
              : 0,
          userID: dbRepository.userData?.userID,
          executionElements: e['title'],
          elementName: e['title'],
          executionDescription: e['Description'],
          executionDateFrom: "",
          executionDateTo: "",
          type: "Insert",
        );
      }

      _setExecutionUpdateStatus(ApiResponse.completed(null));
    } catch (e) {
      _setExecutionUpdateStatus(ApiResponse.error(e.toString()));
    }
  }

  Future<bool> uploadDocument({
    required int activityId,
    required String userId,
    required String description,
    required String fileBytes,
    required String fileExt,
  }) async {
    try {
      final response = await apiRepository.getAuthorisationUpdateDetails(
        documentID: 0,
        activityID: activityId,
        userID: userId,
        authDescription: description,
        fileInputAuth: fileBytes,
        fileInputAuthExt: fileExt,
      );

      return response?.result == 1;
    } catch (e) {
      debugPrint("VM Error: $e");
      return false;
    }
  }

  List<ViewAuthorisationDocumentsDetailsList> authDocsList = [];
  bool isLoadingAuthDocs = false;

  /// ✅ FETCH AUTHORISATION DOCS
  Future<void> fetchAuthorisationDocs() async {
    isLoadingAuthDocs = true;
    notifyListeners();

    try {
      final response = await apiRepository.getAuthorisationViewDetails(
        documentID: 0,
        activityID: 40,
        userID: "5",
        type: "VIEW",
      );

      if (response != null && response.result == 1) {
        authDocsList = response.viewAuthorisationDocumentsDetailsList ?? [];
      } else {
        authDocsList = [];
        debugPrint("API Error: ${response?.remarks}");
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    }

    isLoadingAuthDocs = false;
    notifyListeners();
  }

  // ================= SUPPORTING DOCS =================

  List<ViewSupportingDocumentsDetailsList> supportingDocsList = [];
  bool isLoadingSupportingDocs = false;

  /// FETCH SUPPORTING DOCS
  Future<void> fetchSupportingDocs() async {
    isLoadingSupportingDocs = true;
    notifyListeners();

    try {
      final response = await apiRepository.getSupportingViewDetails(
        supportID: 0,
        activityID: 40,
        userID: "5",
        type: "VIEW",
      );

      if (response != null && response.result == 1) {
        supportingDocsList = response.viewSupportingDocumentsDetailsList ?? [];
      } else {
        supportingDocsList = [];
        debugPrint("Supporting API Error: ${response?.remarks}");
      }
    } catch (e) {
      debugPrint("Supporting Fetch Error: $e");
    }

    isLoadingSupportingDocs = false;
    notifyListeners();
  }

  /// UPLOAD SUPPORTING DOC
  Future<bool> uploadSupportingDocument({
    required int activityId,
    required String userId,
    required String description,
    required String fileBytes,
    required String fileExt,
  }) async {
    try {
      final response = await apiRepository.getSupportingUpdateDetails(
        supportID: 0,
        activityID: activityId,
        userID: userId,
        supDescription: description,
        fileInputSup: fileBytes,
        fileInputSupExt: fileExt,
      );

      return response?.result == 1;
    } catch (e) {
      debugPrint("Supporting Upload Error: $e");
      return false;
    }
  }

  // ================= DASHBOARD ==================
  ApiResponse<ActivationDashBoardMasterResponse> _dashboardStatus =
      ApiResponse.none();

  ApiResponse<ActivationDashBoardMasterResponse> get dashboardStatus =>
      _dashboardStatus;

  void _setDashboardStatus(
    ApiResponse<ActivationDashBoardMasterResponse> status,
  ) {
    _dashboardStatus = status;
    notifyListeners();
  }

  List<DashBoardActivationDetailsList> _dashboardList = [];
  List<DashBoardActivationDetailsList> get dashboardList => _dashboardList;

  Future<void> fetchDashboardDetails({
    required String? type,
    required int? activityID,
    required String? userID,
  }) async {
    _setDashboardStatus(ApiResponse.loading());

    try {
      final response = await apiRepository.getDashboardViewDetails(
        type: type,
        activityID: activityID,
        userID: userID,
      );

      if (response == null) {
        _setDashboardStatus(ApiResponse.error("Null response"));
        return;
      }

      if (AppUtils.checkAPIStatusId(response.result)) {
        _dashboardList = response.dashBoardActivationDetailsList ?? [];

        _setDashboardStatus(ApiResponse.completed(response));
      } else {
        _setDashboardStatus(ApiResponse.error(response.remarks ?? "Error"));
      }
    } catch (e) {
      _setDashboardStatus(ApiResponse.error(e.toString()));
    }
  }
}
