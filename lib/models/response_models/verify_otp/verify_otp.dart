class VerifyOtpResponse {
  int? result;
  String? remarks;
  String? fetchdate;
  List<VerifyOTPActivationTrackerDetailsList>?
      verifyOTPActivationTrackerDetailsList;

  VerifyOtpResponse(
      {this.result,
      this.remarks,
      this.fetchdate,
      this.verifyOTPActivationTrackerDetailsList});

  VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    remarks = json['Remarks'];
    fetchdate = json['Fetchdate'];
    if (json['VerifyOTPActivationTrackerDetailsList'] != null) {
      verifyOTPActivationTrackerDetailsList =
          <VerifyOTPActivationTrackerDetailsList>[];
      json['VerifyOTPActivationTrackerDetailsList'].forEach((v) {
        verifyOTPActivationTrackerDetailsList!
            .add(new VerifyOTPActivationTrackerDetailsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Remarks'] = this.remarks;
    data['Fetchdate'] = this.fetchdate;
    if (this.verifyOTPActivationTrackerDetailsList != null) {
      data['VerifyOTPActivationTrackerDetailsList'] = this
          .verifyOTPActivationTrackerDetailsList!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class VerifyOTPActivationTrackerDetailsList {
  int? aTUserID;
  int? result;
  String? aTUserName;
  String? address;
  String? signupReferalCode;
  String? mobileNo;
  String? emailID;

  VerifyOTPActivationTrackerDetailsList(
      {this.aTUserID,
      this.result,
      this.aTUserName,
      this.address,
      this.signupReferalCode,
      this.mobileNo,
      this.emailID});

  VerifyOTPActivationTrackerDetailsList.fromJson(Map<String, dynamic> json) {
    aTUserID = json['ATUserID'];
    result = json['Result'];
    aTUserName = json['ATUserName'];
    address = json['Address'];
    signupReferalCode = json['SignupReferalCode'];
    mobileNo = json['MobileNo'];
    emailID = json['EmailID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ATUserID'] = this.aTUserID;
    data['Result'] = this.result;
    data['ATUserName'] = this.aTUserName;
    data['Address'] = this.address;
    data['SignupReferalCode'] = this.signupReferalCode;
    data['MobileNo'] = this.mobileNo;
    data['EmailID'] = this.emailID;
    return data;
  }
}
