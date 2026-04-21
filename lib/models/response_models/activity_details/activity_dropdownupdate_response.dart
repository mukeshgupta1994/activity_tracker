class ActivityUpdateDetailsResponse {
  int? result;
  String? remarks;
  String? fetchdate;
  List<ActivityTrackerUpdateActivityDetailsList>?
  activityTrackerUpdateActivityDetailsList;

  ActivityUpdateDetailsResponse({
    this.result,
    this.remarks,
    this.fetchdate,
    this.activityTrackerUpdateActivityDetailsList,
  });

  ActivityUpdateDetailsResponse.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    remarks = json['Remarks'];
    fetchdate = json['Fetchdate'];
    if (json['ActivityTrackerUpdateActivityDetailsList'] != null) {
      activityTrackerUpdateActivityDetailsList =
          <ActivityTrackerUpdateActivityDetailsList>[];
      json['ActivityTrackerUpdateActivityDetailsList'].forEach((v) {
        activityTrackerUpdateActivityDetailsList!.add(
          new ActivityTrackerUpdateActivityDetailsList.fromJson(v),
        );
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Remarks'] = this.remarks;
    data['Fetchdate'] = this.fetchdate;
    if (this.activityTrackerUpdateActivityDetailsList != null) {
      data['ActivityTrackerUpdateActivityDetailsList'] = this
          .activityTrackerUpdateActivityDetailsList!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class ActivityTrackerUpdateActivityDetailsList {
  int? pKAMID;
  int? result;
  int? brandID;
  int? productID;
  String? campaignName;
  String? activityID;
  String? documentDate;
  String? activityPeriodFrom;
  String? activityPeriodTo;
  int? medium;
  dynamic vehicle;
  int? activityStatus;
  int? isActive;
  String? attribute1;
  String? attribute2;
  String? attribute3;
  String? attribute4;

  ActivityTrackerUpdateActivityDetailsList({
    this.pKAMID,
    this.result,
    this.brandID,
    this.productID,
    this.campaignName,
    this.activityID,
    this.documentDate,
    this.activityPeriodFrom,
    this.activityPeriodTo,
    this.medium,
    this.vehicle,
    this.activityStatus,
    this.isActive,
    this.attribute1,
    this.attribute2,
    this.attribute3,
    this.attribute4,
  });

  ActivityTrackerUpdateActivityDetailsList.fromJson(Map<String, dynamic> json) {
    pKAMID = json['PK_AMID'];
    result = json['Result'];
    brandID = json['BrandID'];
    productID = json['ProductID'];
    campaignName = json['CampaignName'];
    activityID = json['ActivityID'];
    documentDate = json['DocumentDate'];
    activityPeriodFrom = json['ActivityPeriodFrom'];
    activityPeriodTo = json['ActivityPeriodTo'];
    medium = json['Medium'];
    vehicle = json['Vehicle'];
    activityStatus = json['ActivityStatus'];
    isActive = json['IsActive'];
    attribute1 = json['Attribute1'];
    attribute2 = json['Attribute2'];
    attribute3 = json['Attribute3'];
    attribute4 = json['Attribute4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PK_AMID'] = this.pKAMID;
    data['Result'] = this.result;
    data['BrandID'] = this.brandID;
    data['ProductID'] = this.productID;
    data['CampaignName'] = this.campaignName;
    data['ActivityID'] = this.activityID;
    data['DocumentDate'] = this.documentDate;
    data['ActivityPeriodFrom'] = this.activityPeriodFrom;
    data['ActivityPeriodTo'] = this.activityPeriodTo;
    data['Medium'] = this.medium;
    data['Vehicle'] = this.vehicle;
    data['ActivityStatus'] = this.activityStatus;
    data['IsActive'] = this.isActive;
    data['Attribute1'] = this.attribute1;
    data['Attribute2'] = this.attribute2;
    data['Attribute3'] = this.attribute3;
    data['Attribute4'] = this.attribute4;
    return data;
  }
}
