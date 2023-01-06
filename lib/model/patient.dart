import 'package:dmt/model/company.dart';

class Patient {
  int id;
  String firstname;
  String lastname;
  String dob;
  String gender;
  String primaryinsurance;
  dynamic otherprimaryinsurance;
  String primaryinsuranceno;
  dynamic secondaryinsurance;
  dynamic othersecondaryinsurance;
  dynamic secondaryinsuranceno;
  int organizationid;
  int companyid;
  dynamic csr;
  String status;
  DateTime createdAt;
  String createdBy;
  DateTime updatedAt;
  String updatedBy;
  Company? company;

  Patient({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.dob,
    required this.gender,
    required this.primaryinsurance,
    required this.otherprimaryinsurance,
    required this.primaryinsuranceno,
    required this.secondaryinsurance,
    required this.othersecondaryinsurance,
    required this.secondaryinsuranceno,
    required this.organizationid,
    required this.companyid,
    required this.csr,
    required this.status,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.company,
  });



  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    id: json["id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    dob: json["dob"],
    gender: json["gender"],
    primaryinsurance: json["primaryinsurance"],
    otherprimaryinsurance: json["otherprimaryinsurance"],
    primaryinsuranceno: json["primaryinsuranceno"],
    secondaryinsurance: json["secondaryinsurance"],
    othersecondaryinsurance: json["othersecondaryinsurance"],
    secondaryinsuranceno: json["secondaryinsuranceno"],
    organizationid: json["organizationid"],
    companyid: json["companyid"],
    csr: json["csr"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    createdBy: json["createdBy"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    updatedBy: json["updatedBy"],
    company: json.containsKey("company") ? Company.fromJson(json["company"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "dob": dob,
    "gender": gender,
    "primaryinsurance": primaryinsurance,
    "otherprimaryinsurance": otherprimaryinsurance,
    "primaryinsuranceno": primaryinsuranceno,
    "secondaryinsurance": secondaryinsurance,
    "othersecondaryinsurance": othersecondaryinsurance,
    "secondaryinsuranceno": secondaryinsuranceno,
    "organizationid": organizationid,
    "companyid": companyid,
    "csr": csr,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "createdBy": createdBy,
    "updatedAt": updatedAt.toIso8601String(),
    "updatedBy": updatedBy,
  };
}
