class AgencyPartnerUpdateResponse {
  int? result;
  String? remarks;
  String? fetchdate;
  List<AgencyPartnerDetailsList>? agencyPartnerDetailsList;

  AgencyPartnerUpdateResponse({
    this.result,
    this.remarks,
    this.fetchdate,
    this.agencyPartnerDetailsList,
  });

  AgencyPartnerUpdateResponse.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    remarks = json['Remarks'];
    fetchdate = json['Fetchdate'];
    if (json['AgencyPartnerDetailsList'] != null) {
      agencyPartnerDetailsList = <AgencyPartnerDetailsList>[];
      json['AgencyPartnerDetailsList'].forEach((v) {
        agencyPartnerDetailsList!.add(new AgencyPartnerDetailsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Remarks'] = this.remarks;
    data['Fetchdate'] = this.fetchdate;
    if (this.agencyPartnerDetailsList != null) {
      data['AgencyPartnerDetailsList'] = this.agencyPartnerDetailsList!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class AgencyPartnerDetailsList {
  int? agencyID;
  int? result;
  int? activityID;
  String? agencyPartnerName;
  int? agencyType;
  String? aPRole;
  int? planSpends;
  int? finalSpends;
  int? active;
  String? createdBy;
  String? createdDate;
  String? modifiedBy;
  String? modifiedDate;
  String? mediumType;
  String? vehicle;

  AgencyPartnerDetailsList({
    this.agencyID,
    this.result,
    this.activityID,
    this.agencyPartnerName,
    this.agencyType,
    this.aPRole,
    this.planSpends,
    this.finalSpends,
    this.active,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.mediumType,
    this.vehicle,
  });

  AgencyPartnerDetailsList.fromJson(Map<String, dynamic> json) {
    agencyID = json['AgencyID'];
    result = json['Result'];
    activityID = json['ActivityID'];
    agencyPartnerName = json['AgencyPartnerName'];
    agencyType = json['AgencyType'];
    aPRole = json['AP_Role'];
    planSpends = json['PlanSpends'];
    finalSpends = json['FinalSpends'];
    active = json['Active'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    modifiedBy = json['ModifiedBy'];
    modifiedDate = json['ModifiedDate'];
    mediumType = json['MediumType'];
    vehicle = json['Vehicle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AgencyID'] = this.agencyID;
    data['Result'] = this.result;
    data['ActivityID'] = this.activityID;
    data['AgencyPartnerName'] = this.agencyPartnerName;
    data['AgencyType'] = this.agencyType;
    data['AP_Role'] = this.aPRole;
    data['PlanSpends'] = this.planSpends;
    data['FinalSpends'] = this.finalSpends;
    data['Active'] = this.active;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['ModifiedBy'] = this.modifiedBy;
    data['ModifiedDate'] = this.modifiedDate;
    data['MediumType'] = this.mediumType;
    data['Vehicle'] = this.vehicle;
    return data;
  }
}
