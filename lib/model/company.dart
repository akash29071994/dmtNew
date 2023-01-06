import 'package:dmt/model/organization.dart';

class Company {

  int id;
  String companyname;
  String displayname;
  int stateid;
  int cityid;
  int regionid;
  int areaid;
  int organizationid;
  String phone;
  String alternatecontactnumber;
  String fax;
  String address1;
  String address2;
  String zipcode;
  String email;
  String officemanageremail;
  String referralcoordinatoremail;
  String billingmanageremail;
  String maincontactemail;
  String status;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;
  Organization? organization;

  Company({
    this.id = 0,
    this.companyname = "",
    this.displayname="",
    this.stateid=0,
    this.cityid=0,
    this.regionid=0,
    this.areaid=0,
    this.organizationid=0,
    this.phone="",
    this.alternatecontactnumber="",
    this.fax="",
    this.address1="",
    this.address2="",
    this.zipcode="",
    this.email="",
    this.officemanageremail="",
    this.referralcoordinatoremail="",
    this.billingmanageremail="",
    this.maincontactemail="",
    this.status="",
    this.createdAt="",
    this.createdBy="",
    this.updatedAt="",
    this.updatedBy="",
    this.organization = null,
  });



  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id:json["id"],
    companyname: json["companyname"],
    displayname: json["displayname"],
    stateid: json["stateid"],
    cityid: json["cityid"],
    regionid: json["regionid"],
    areaid: json["areaid"],
    organizationid: json["organizationid"],
    phone: json["phone"],
    alternatecontactnumber: json["alternatecontactnumber"]== null? "":json["alternatecontactnumber"],
    fax: json["fax"],
    address1: json["address1"],
    address2: json["address2"],
    zipcode: json["zipcode"],
    email: json["email"],
    officemanageremail: json["officemanageremail"],
    referralcoordinatoremail: json["referralcoordinatoremail"],
    billingmanageremail: json["billingmanageremail"],
    maincontactemail: json["maincontactemail"],
    status: json["status"],
    createdAt: json["createdAt"],
    createdBy: json["createdBy"],
    updatedAt: json["updatedAt"],
    updatedBy: json["updatedBy"],
    organization: Organization.fromJson(json["organization"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "companyname": companyname,
    "displayname": displayname,
    "stateid": stateid,
    "cityid": cityid,
    "regionid": regionid,
    "areaid": areaid,
    "organizationid": organizationid,
    "phone": phone,
    "alternatecontactnumber": alternatecontactnumber,
    "fax": fax,
    "address1": address1,
    "address2": address2,
    "zipcode": zipcode,
    "email": email,
    "officemanageremail": officemanageremail,
    "referralcoordinatoremail": referralcoordinatoremail,
    "billingmanageremail": billingmanageremail,
    "maincontactemail": maincontactemail,
    "status": status,
    "createdAt": createdAt,
    "createdBy": createdBy,
    "updatedAt": updatedAt,
    "updatedBy": updatedBy,
    "organization": organization?.toJson(),
  };
}