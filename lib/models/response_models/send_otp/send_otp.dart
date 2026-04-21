class SendOtpResponse {
  int? result;
  String? remarks;
  String? fetchdate;
  List<CustomerDetails>? customerDetails;

  SendOtpResponse(
      {this.result, this.remarks, this.fetchdate, this.customerDetails});

  SendOtpResponse.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    remarks = json['Remarks'];
    fetchdate = json['Fetchdate'];
    if (json['CustomerDetails'] != null) {
      customerDetails = <CustomerDetails>[];
      json['CustomerDetails'].forEach((v) {
        customerDetails!.add(new CustomerDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Remarks'] = this.remarks;
    data['Fetchdate'] = this.fetchdate;
    if (this.customerDetails != null) {
      data['CustomerDetails'] =
          this.customerDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerDetails {
  int? aTUserID;
  int? result;
  String? aTUserName;
  String? mobileNo;

  CustomerDetails({this.aTUserID, this.result, this.aTUserName, this.mobileNo});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    aTUserID = json['ATUserID'];
    result = json['Result'];
    aTUserName = json['ATUserName'];
    mobileNo = json['MobileNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ATUserID'] = this.aTUserID;
    data['Result'] = this.result;
    data['ATUserName'] = this.aTUserName;
    data['MobileNo'] = this.mobileNo;
    return data;
  }
}
