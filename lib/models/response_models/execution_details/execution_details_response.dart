class ExecutionUpdateResponse {
  int? result;
  String? remarks;
  String? fetchdate;
  List<ExecutionElementDetailsList>? executionElementDetailsList;

  ExecutionUpdateResponse(
      {this.result,
      this.remarks,
      this.fetchdate,
      this.executionElementDetailsList});

  ExecutionUpdateResponse.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    remarks = json['Remarks'];
    fetchdate = json['Fetchdate'];
    if (json['ExecutionElementDetailsList'] != null) {
      executionElementDetailsList = <ExecutionElementDetailsList>[];
      json['ExecutionElementDetailsList'].forEach((v) {
        executionElementDetailsList!
            .add(new ExecutionElementDetailsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Remarks'] = this.remarks;
    data['Fetchdate'] = this.fetchdate;
    if (this.executionElementDetailsList != null) {
      data['ExecutionElementDetailsList'] =
          this.executionElementDetailsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExecutionElementDetailsList {
  int? executionElementID;
  int? result;
  int? activityID;
  String? executionElements;
  String? elementName;
  String? executionDescription;
  String? executionDateFrom;
  String? executionDateTo;
  int? active;
  String? createdBy;
  String? createdDate;
  String? modifiedBy;
  String? modifiedDate;

  ExecutionElementDetailsList(
      {this.executionElementID,
      this.result,
      this.activityID,
      this.executionElements,
      this.elementName,
      this.executionDescription,
      this.executionDateFrom,
      this.executionDateTo,
      this.active,
      this.createdBy,
      this.createdDate,
      this.modifiedBy,
      this.modifiedDate});

  ExecutionElementDetailsList.fromJson(Map<String, dynamic> json) {
    executionElementID = json['ExecutionElementID'];
    result = json['Result'];
    activityID = json['ActivityID'];
    executionElements = json['ExecutionElements'];
    elementName = json['ElementName'];
    executionDescription = json['ExecutionDescription'];
    executionDateFrom = json['ExecutionDateFrom'];
    executionDateTo = json['ExecutionDateTo'];
    active = json['Active'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    modifiedBy = json['ModifiedBy'];
    modifiedDate = json['ModifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ExecutionElementID'] = this.executionElementID;
    data['Result'] = this.result;
    data['ActivityID'] = this.activityID;
    data['ExecutionElements'] = this.executionElements;
    data['ElementName'] = this.elementName;
    data['ExecutionDescription'] = this.executionDescription;
    data['ExecutionDateFrom'] = this.executionDateFrom;
    data['ExecutionDateTo'] = this.executionDateTo;
    data['Active'] = this.active;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['ModifiedBy'] = this.modifiedBy;
    data['ModifiedDate'] = this.modifiedDate;
    return data;
  }
}
