class ViewSupportingDocumentsResponse {
  int? result;
  String? remarks;
  String? fetchdate;
  List<ViewSupportingDocumentsDetailsList>? viewSupportingDocumentsDetailsList;

  ViewSupportingDocumentsResponse(
      {this.result,
      this.remarks,
      this.fetchdate,
      this.viewSupportingDocumentsDetailsList});

  ViewSupportingDocumentsResponse.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    remarks = json['Remarks'];
    fetchdate = json['Fetchdate'];
    if (json['ViewSupportingDocumentsDetailsList'] != null) {
      viewSupportingDocumentsDetailsList =
          <ViewSupportingDocumentsDetailsList>[];
      json['ViewSupportingDocumentsDetailsList'].forEach((v) {
        viewSupportingDocumentsDetailsList!
            .add(new ViewSupportingDocumentsDetailsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Remarks'] = this.remarks;
    data['Fetchdate'] = this.fetchdate;
    if (this.viewSupportingDocumentsDetailsList != null) {
      data['ViewSupportingDocumentsDetailsList'] = this
          .viewSupportingDocumentsDetailsList!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class ViewSupportingDocumentsDetailsList {
  int? supportID;
  int? result;
  int? activityID;
  String? supDescription;
  String? fileInputSup;
  int? active;
  String? createdBy;
  String? createdDate;

  ViewSupportingDocumentsDetailsList(
      {this.supportID,
      this.result,
      this.activityID,
      this.supDescription,
      this.fileInputSup,
      this.active,
      this.createdBy,
      this.createdDate});

  ViewSupportingDocumentsDetailsList.fromJson(Map<String, dynamic> json) {
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
