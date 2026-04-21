class ViewAuthorisationDocumentsResponse {
  int? result;
  String? remarks;
  String? fetchdate;
  List<ViewAuthorisationDocumentsDetailsList>?
      viewAuthorisationDocumentsDetailsList;

  ViewAuthorisationDocumentsResponse(
      {this.result,
      this.remarks,
      this.fetchdate,
      this.viewAuthorisationDocumentsDetailsList});

  ViewAuthorisationDocumentsResponse.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    remarks = json['Remarks'];
    fetchdate = json['Fetchdate'];
    if (json['ViewAuthorisationDocumentsDetailsList'] != null) {
      viewAuthorisationDocumentsDetailsList =
          <ViewAuthorisationDocumentsDetailsList>[];
      json['ViewAuthorisationDocumentsDetailsList'].forEach((v) {
        viewAuthorisationDocumentsDetailsList!
            .add(new ViewAuthorisationDocumentsDetailsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Remarks'] = this.remarks;
    data['Fetchdate'] = this.fetchdate;
    if (this.viewAuthorisationDocumentsDetailsList != null) {
      data['ViewAuthorisationDocumentsDetailsList'] = this
          .viewAuthorisationDocumentsDetailsList!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class ViewAuthorisationDocumentsDetailsList {
  int? documentID;
  int? result;
  int? activityID;
  String? authDescription;
  String? fileInputAuth;
  int? active;
  String? createdBy;
  String? createdDate;

  ViewAuthorisationDocumentsDetailsList(
      {this.documentID,
      this.result,
      this.activityID,
      this.authDescription,
      this.fileInputAuth,
      this.active,
      this.createdBy,
      this.createdDate});

  ViewAuthorisationDocumentsDetailsList.fromJson(Map<String, dynamic> json) {
    documentID = json['DocumentID'];
    result = json['Result'];
    activityID = json['ActivityID'];
    authDescription = json['AuthDescription'];
    fileInputAuth = json['FileInputAuth'];
    active = json['Active'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocumentID'] = this.documentID;
    data['Result'] = this.result;
    data['ActivityID'] = this.activityID;
    data['AuthDescription'] = this.authDescription;
    data['FileInputAuth'] = this.fileInputAuth;
    data['Active'] = this.active;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
