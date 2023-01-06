class Organization {

  int id;
  String orgname;
  String acronym;
  String url;
  int stateid;
  int cityid;
  dynamic regionid;
  dynamic areaid;
  String phone;
  String fax;
  String address;
  String zipcode;
  String reportheader;
  String dataentrymethod;
  bool archive;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;
  Organization({
    this.id = 0,
    this.orgname = "",
    this.acronym = "",
    this.url = "",
    this.stateid = 0,
    this.cityid = 0,
    this.regionid = 0,
    this.areaid = 0,
    this.phone = "",
    this.fax="",
    this.address="",
    this.zipcode="",
    this.reportheader="",
    this.dataentrymethod="",
    this.archive=false,
    this.createdAt="",
    this.createdBy = "",
    this.updatedAt ="",
    this.updatedBy="",
  });



  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
    id: json["id"],
    orgname: json["orgname"],
    acronym: json["acronym"],
    url: json["url"],
    stateid: json["stateid"],
    cityid: json["cityid"],
    regionid: json["regionid"],
    areaid: json["areaid"],
    phone: json["phone"],
    fax: json["fax"],
    address: json["address"],
    zipcode: json["zipcode"],
    reportheader: json["reportheader"],
    dataentrymethod: json["dataentrymethod"],
    archive: json["archive"],
    createdAt: json["createdAt"],
    createdBy: json["createdBy"],
    updatedAt: json["updatedAt"],
    updatedBy: json["updatedBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orgname": orgname,
    "acronym": acronym,
    "url": url,
    "stateid": stateid,
    "cityid": cityid,
    "regionid": regionid,
    "areaid": areaid,
    "phone": phone,
    "fax": fax,
    "address": address,
    "zipcode": zipcode,
    "reportheader": reportheader,
    "dataentrymethod": dataentrymethod,
    "archive": archive,
    "createdAt": createdAt,
    "createdBy": createdBy,
    "updatedAt": updatedAt,
    "updatedBy": updatedBy,
  };
}