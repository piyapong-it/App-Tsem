class SubDistrict {
  SubDistrict({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<SubDistrictResult> result;

  factory SubDistrict.fromJson(Map<String, dynamic> json) => SubDistrict(
    success: json["success"],
    message: json["message"],
    result: List<SubDistrictResult>.from(json["result"].map((x) => SubDistrictResult.fromJson(x))),
  );
}

class SubDistrictResult {
  SubDistrictResult({
    this.subdistrictId,
    this.subdistrictName,
    this.subdistrictEng,
    this.zipCode,
  });

  String subdistrictId;
  String subdistrictName;
  String subdistrictEng;
  String zipCode;
 

  factory SubDistrictResult.fromJson(Map<String, dynamic> json) => SubDistrictResult(
    subdistrictId: json["CM#SUBDISTRICT_ID"].toString(),
    subdistrictName: json["CM#SUBDISTRICT_NAME"],
    subdistrictEng: json["CM#SUBDISTRICT_EN"],
    zipCode: json["CM#ZIP_CODE"].toString()
  );

    Map<String, dynamic> toJson() => {
    "CM#SUBDISTRICT_ID": subdistrictId,
    "CM#SUBDISTRICT_NAME": subdistrictName,
    "CM#SUBDISTRICT_EN": subdistrictEng,
    "CM#ZIP_CODE": zipCode
  };
}
