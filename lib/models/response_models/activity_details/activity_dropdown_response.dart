class ActivityDropDownDetailsResponse {
  int? result;
  String? remarks;
  String? fetchdate;
  List<BrandTypeDetailsList>? brandTypeDetailsList;
  List<ProductTypeDetailsList>? productTypeDetailsList;
  List<ActivityStatusTypeDetailsList>? activityStatusTypeDetailsList;
  List<MediumTypeDetailsList>? mediumTypeDetailsList;
  List<CommunicationTypeDetailsList>? communicationTypeDetailsList;
  List<AgencyTypeDetailsList>? agencyTypeDetailsList;
  List<MediaTypeDetailsList>? mediaTypeDetailsList;
  List<StateTypeDetailsList>? stateTypeDetailsList;
  List<DocumentTypeDetailsList>? documentTypeDetailsList;

  ActivityDropDownDetailsResponse(
      {this.result,
      this.remarks,
      this.fetchdate,
      this.brandTypeDetailsList,
      this.productTypeDetailsList,
      this.activityStatusTypeDetailsList,
      this.mediumTypeDetailsList,
      this.communicationTypeDetailsList,
      this.agencyTypeDetailsList,
      this.mediaTypeDetailsList,
      this.stateTypeDetailsList,
      this.documentTypeDetailsList});

  ActivityDropDownDetailsResponse.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    remarks = json['Remarks'];
    fetchdate = json['Fetchdate'];
    if (json['BrandTypeDetailsList'] != null) {
      brandTypeDetailsList = <BrandTypeDetailsList>[];
      json['BrandTypeDetailsList'].forEach((v) {
        brandTypeDetailsList!.add(new BrandTypeDetailsList.fromJson(v));
      });
    }
    if (json['ProductTypeDetailsList'] != null) {
      productTypeDetailsList = <ProductTypeDetailsList>[];
      json['ProductTypeDetailsList'].forEach((v) {
        productTypeDetailsList!.add(new ProductTypeDetailsList.fromJson(v));
      });
    }
    if (json['ActivityStatusTypeDetailsList'] != null) {
      activityStatusTypeDetailsList = <ActivityStatusTypeDetailsList>[];
      json['ActivityStatusTypeDetailsList'].forEach((v) {
        activityStatusTypeDetailsList!
            .add(new ActivityStatusTypeDetailsList.fromJson(v));
      });
    }
    if (json['MediumTypeDetailsList'] != null) {
      mediumTypeDetailsList = <MediumTypeDetailsList>[];
      json['MediumTypeDetailsList'].forEach((v) {
        mediumTypeDetailsList!.add(new MediumTypeDetailsList.fromJson(v));
      });
    }
    if (json['CommunicationTypeDetailsList'] != null) {
      communicationTypeDetailsList = <CommunicationTypeDetailsList>[];
      json['CommunicationTypeDetailsList'].forEach((v) {
        communicationTypeDetailsList!
            .add(new CommunicationTypeDetailsList.fromJson(v));
      });
    }
    if (json['AgencyTypeDetailsList'] != null) {
      agencyTypeDetailsList = <AgencyTypeDetailsList>[];
      json['AgencyTypeDetailsList'].forEach((v) {
        agencyTypeDetailsList!.add(new AgencyTypeDetailsList.fromJson(v));
      });
    }
    if (json['MediaTypeDetailsList'] != null) {
      mediaTypeDetailsList = <MediaTypeDetailsList>[];
      json['MediaTypeDetailsList'].forEach((v) {
        mediaTypeDetailsList!.add(new MediaTypeDetailsList.fromJson(v));
      });
    }
    if (json['StateTypeDetailsList'] != null) {
      stateTypeDetailsList = <StateTypeDetailsList>[];
      json['StateTypeDetailsList'].forEach((v) {
        stateTypeDetailsList!.add(new StateTypeDetailsList.fromJson(v));
      });
    }
    if (json['DocumentTypeDetailsList'] != null) {
      documentTypeDetailsList = <DocumentTypeDetailsList>[];
      json['DocumentTypeDetailsList'].forEach((v) {
        documentTypeDetailsList!.add(new DocumentTypeDetailsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Remarks'] = this.remarks;
    data['Fetchdate'] = this.fetchdate;
    if (this.brandTypeDetailsList != null) {
      data['BrandTypeDetailsList'] =
          this.brandTypeDetailsList!.map((v) => v.toJson()).toList();
    }
    if (this.productTypeDetailsList != null) {
      data['ProductTypeDetailsList'] =
          this.productTypeDetailsList!.map((v) => v.toJson()).toList();
    }
    if (this.activityStatusTypeDetailsList != null) {
      data['ActivityStatusTypeDetailsList'] =
          this.activityStatusTypeDetailsList!.map((v) => v.toJson()).toList();
    }
    if (this.mediumTypeDetailsList != null) {
      data['MediumTypeDetailsList'] =
          this.mediumTypeDetailsList!.map((v) => v.toJson()).toList();
    }
    if (this.communicationTypeDetailsList != null) {
      data['CommunicationTypeDetailsList'] =
          this.communicationTypeDetailsList!.map((v) => v.toJson()).toList();
    }
    if (this.agencyTypeDetailsList != null) {
      data['AgencyTypeDetailsList'] =
          this.agencyTypeDetailsList!.map((v) => v.toJson()).toList();
    }
    if (this.mediaTypeDetailsList != null) {
      data['MediaTypeDetailsList'] =
          this.mediaTypeDetailsList!.map((v) => v.toJson()).toList();
    }
    if (this.stateTypeDetailsList != null) {
      data['StateTypeDetailsList'] =
          this.stateTypeDetailsList!.map((v) => v.toJson()).toList();
    }
    if (this.documentTypeDetailsList != null) {
      data['DocumentTypeDetailsList'] =
          this.documentTypeDetailsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BrandTypeDetailsList {
  int? brandID;
  int? result;
  String? brandName;

  BrandTypeDetailsList({this.brandID, this.result, this.brandName});

  BrandTypeDetailsList.fromJson(Map<String, dynamic> json) {
    brandID = json['BrandID'];
    result = json['Result'];
    brandName = json['BrandName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandID'] = this.brandID;
    data['Result'] = this.result;
    data['BrandName'] = this.brandName;
    return data;
  }
}

class ProductTypeDetailsList {
  int? productID;
  int? result;
  String? productName;

  ProductTypeDetailsList({this.productID, this.result, this.productName});

  ProductTypeDetailsList.fromJson(Map<String, dynamic> json) {
    productID = json['ProductID'];
    result = json['Result'];
    productName = json['ProductName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductID'] = this.productID;
    data['Result'] = this.result;
    data['ProductName'] = this.productName;
    return data;
  }
}

class ActivityStatusTypeDetailsList {
  int? activityStatusID;
  int? result;
  String? activityStatusName;

  ActivityStatusTypeDetailsList(
      {this.activityStatusID, this.result, this.activityStatusName});

  ActivityStatusTypeDetailsList.fromJson(Map<String, dynamic> json) {
    activityStatusID = json['ActivityStatusID'];
    result = json['Result'];
    activityStatusName = json['ActivityStatusName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ActivityStatusID'] = this.activityStatusID;
    data['Result'] = this.result;
    data['ActivityStatusName'] = this.activityStatusName;
    return data;
  }
}

class MediumTypeDetailsList {
  int? mediumID;
  int? result;
  String? mediumName;

  MediumTypeDetailsList({this.mediumID, this.result, this.mediumName});

  MediumTypeDetailsList.fromJson(Map<String, dynamic> json) {
    mediumID = json['MediumID'];
    result = json['Result'];
    mediumName = json['MediumName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MediumID'] = this.mediumID;
    data['Result'] = this.result;
    data['MediumName'] = this.mediumName;
    return data;
  }
}

class CommunicationTypeDetailsList {
  int? comunicationID;
  int? result;
  String? communicationName;

  CommunicationTypeDetailsList(
      {this.comunicationID, this.result, this.communicationName});

  CommunicationTypeDetailsList.fromJson(Map<String, dynamic> json) {
    comunicationID = json['ComunicationID'];
    result = json['Result'];
    communicationName = json['CommunicationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ComunicationID'] = this.comunicationID;
    data['Result'] = this.result;
    data['CommunicationName'] = this.communicationName;
    return data;
  }
}

class AgencyTypeDetailsList {
  int? agencyID;
  int? result;
  String? agencyName;

  AgencyTypeDetailsList({this.agencyID, this.result, this.agencyName});

  AgencyTypeDetailsList.fromJson(Map<String, dynamic> json) {
    agencyID = json['AgencyID'];
    result = json['Result'];
    agencyName = json['AgencyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AgencyID'] = this.agencyID;
    data['Result'] = this.result;
    data['AgencyName'] = this.agencyName;
    return data;
  }
}

class MediaTypeDetailsList {
  int? mediaID;
  int? result;
  String? mediaName;

  MediaTypeDetailsList({this.mediaID, this.result, this.mediaName});

  MediaTypeDetailsList.fromJson(Map<String, dynamic> json) {
    mediaID = json['MediaID'];
    result = json['Result'];
    mediaName = json['MediaName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MediaID'] = this.mediaID;
    data['Result'] = this.result;
    data['MediaName'] = this.mediaName;
    return data;
  }
}

class StateTypeDetailsList {
  String? stateID;
  int? result;
  String? stateName;

  StateTypeDetailsList({this.stateID, this.result, this.stateName});

  StateTypeDetailsList.fromJson(Map<String, dynamic> json) {
    stateID = json['StateID'];
    result = json['Result'];
    stateName = json['StateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StateID'] = this.stateID;
    data['Result'] = this.result;
    data['StateName'] = this.stateName;
    return data;
  }
}

class DocumentTypeDetailsList {
  int? documentID;
  int? result;
  String? documentName;

  DocumentTypeDetailsList({this.documentID, this.result, this.documentName});

  DocumentTypeDetailsList.fromJson(Map<String, dynamic> json) {
    documentID = json['DocumentID'];
    result = json['Result'];
    documentName = json['DocumentName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocumentID'] = this.documentID;
    data['Result'] = this.result;
    data['DocumentName'] = this.documentName;
    return data;
  }
}
