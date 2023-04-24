class District {
  District({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<DistrictResult> result;

  factory District.fromJson(Map<String, dynamic> json) => District(
    success: json["success"],
    message: json["message"],
    result: List<DistrictResult>.from(json["result"].map((x) => DistrictResult.fromJson(x))),
  );
}

class DistrictResult {
  DistrictResult({
    this.districtId,
    this.districtName,
    this.districtEng,
  });

  String districtId;
  String districtName;
  String districtEng;
 

  factory DistrictResult.fromJson(Map<String, dynamic> json) => DistrictResult(
    districtId: json["CM#DISTRICT_ID"].toString(),
    districtName: json["CM#DISTRICT_NAME"],
    districtEng: json["CM#DISTRICT_EN"]
  );

  get isNotEmpty => null;

  Map<String, dynamic> toJson() => {
    "CM#DISTRICT_ID": districtId,
    "CM#DISTRICT_NAME": districtName,
    "CM#DISTRICT_EN": districtEng
  };
}
