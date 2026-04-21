class AddUpdateSupportingDocumentsResponse {
  int? result;
  String? remarks;
  String? fetchdate;
  List<SupportingDocumentsDetailsList>? supportingDocumentsDetailsList;

  AddUpdateSupportingDocumentsResponse(
      {this.result,
      this.remarks,
      this.fetchdate,
      this.supportingDocumentsDetailsList});

  AddUpdateSupportingDocumentsResponse.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    remarks = json['Remarks'];
    fetchdate = json['Fetchdate'];
    if (json['SupportingDocumentsDetailsList'] != null) {
      supportingDocumentsDetailsList = <SupportingDocumentsDetailsList>[];
      json['SupportingDocumentsDetailsList'].forEach((v) {
        supportingDocumentsDetailsList!
            .add(new SupportingDocumentsDetailsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Remarks'] = this.remarks;
    data['Fetchdate'] = this.fetchdate;
    if (this.supportingDocumentsDetailsList != null) {
      data['SupportingDocumentsDetailsList'] =
          this.supportingDocumentsDetailsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SupportingDocumentsDetailsList {
  int? supportID;
  int? result;
  int? activityID;
  String? supDescription;
  String? fileInputSup;
  int? active;
  String? createdBy;
  String? createdDate;

  SupportingDocumentsDetailsList(
      {this.supportID,
      this.result,
      this.activityID,
      this.supDescription,
      this.fileInputSup,
      this.active,
      this.createdBy,
      this.createdDate});

  SupportingDocumentsDetailsList.fromJson(Map<String, dynamic> json) {
    supportID = json['SupportID'];
    result = json['Result'];
    activityID = json['ActivityID'];
    supDescription = json['SupDescription'];
    fileInputSup = json['FileInputSup'];
    active = json['Active'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SupportID'] = this.supportID;
    data['Result'] = this.result;
    data['ActivityID'] = this.activityID;
    data['SupDescription'] = this.supDescription;
    data['FileInputSup'] = this.fileInputSup;
    data['Active'] = this.active;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
