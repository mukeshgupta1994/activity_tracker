class ActivationDashBoardMasterResponse {
  int? result;
  String? remarks;
  String? fetchdate;
  List<DashBoardActivationDetailsList>? dashBoardActivationDetailsList;

  ActivationDashBoardMasterResponse(
      {this.result,
      this.remarks,
      this.fetchdate,
      this.dashBoardActivationDetailsList});

  ActivationDashBoardMasterResponse.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    remarks = json['Remarks'];
    fetchdate = json['Fetchdate'];
    if (json['DashBoardActivationDetailsList'] != null) {
      dashBoardActivationDetailsList = <DashBoardActivationDetailsList>[];
      json['DashBoardActivationDetailsList'].forEach((v) {
        dashBoardActivationDetailsList!
            .add(new DashBoardActivationDetailsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Remarks'] = this.remarks;
    data['Fetchdate'] = this.fetchdate;
    if (this.dashBoardActivationDetailsList != null) {
      data['DashBoardActivationDetailsList'] =
          this.dashBoardActivationDetailsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DashBoardActivationDetailsList {
  int? activityID;
  int? result;
  String? brandName;
  String? productName;
  String? campaignName;
  String? documentDate;
  String? activityPeriodFrom;
  String? activityPeriodTo;
  Null? mediumName;
  Null? vehicle;
  String? activityStatusName;
  Null? rewardsRedemptionDocument;
  String? createdBy;
  String? createdDate;
  int? isActive;

  DashBoardActivationDetailsList(
      {this.activityID,
      this.result,
      this.brandName,
      this.productName,
      this.campaignName,
      this.documentDate,
      this.activityPeriodFrom,
      this.activityPeriodTo,
      this.mediumName,
      this.vehicle,
      this.activityStatusName,
      this.rewardsRedemptionDocument,
      this.createdBy,
      this.createdDate,
      this.isActive});

  DashBoardActivationDetailsList.fromJson(Map<String, dynamic> json) {
    activityID = json['ActivityID'];
    result = json['Result'];
    brandName = json['BrandName'];
    productName = json['ProductName'];
    campaignName = json['CampaignName'];
    documentDate = json['DocumentDate'];
    activityPeriodFrom = json['ActivityPeriodFrom'];
    activityPeriodTo = json['ActivityPeriodTo'];
    mediumName = json['MediumName'];
    vehicle = json['Vehicle'];
    activityStatusName = json['ActivityStatusName'];
    rewardsRedemptionDocument = json['RewardsRedemptionDocument'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    isActive = json['IsActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ActivityID'] = this.activityID;
    data['Result'] = this.result;
    data['BrandName'] = this.brandName;
    data['ProductName'] = this.productName;
    data['CampaignName'] = this.campaignName;
    data['DocumentDate'] = this.documentDate;
    data['ActivityPeriodFrom'] = this.activityPeriodFrom;
    data['ActivityPeriodTo'] = this.activityPeriodTo;
    data['MediumName'] = this.mediumName;
    data['Vehicle'] = this.vehicle;
    data['ActivityStatusName'] = this.activityStatusName;
    data['RewardsRedemptionDocument'] = this.rewardsRedemptionDocument;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['IsActive'] = this.isActive;
    return data;
  }
}
