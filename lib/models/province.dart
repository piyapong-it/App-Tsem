class Province {
  Province({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<ProvinceResult> result;

  factory Province.fromJson(Map<String, dynamic> json) => Province(
    success: json["success"],
    message: json["message"],
    result: List<ProvinceResult>.from(json["result"].map((x) => ProvinceResult.fromJson(x))),
  );

    Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class ProvinceResult {
  ProvinceResult({
    this.provinceId,
    this.provinceName,
    this.provinceEng,
    this.strategic
  });

  String provinceId;
  String provinceName;
  String provinceEng;
  String strategic;
 

  factory ProvinceResult.fromJson(Map<String, dynamic> json) => ProvinceResult(
    provinceId: json["CM#PROVINCE_ID"].toString(),
    provinceName: json["CM#PROVINCE_NAME"],
    provinceEng: json["CM#PROVINCE_EN"],
    strategic: json["CM#STRATEGIC"].toString()
  );

    Map<String, dynamic> toJson() => {
    "CM#PROVINCE_ID": provinceId,
    "CM#PROVINCE_NAME": provinceName,
    "CM#PROVINCE_EN": provinceEng,
    "CM#STRATEGIC": strategic,
  };
}
