class ItemVisitEoE {
  ItemVisitEoE({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory ItemVisitEoE.fromJson(Map<String, dynamic> json) => ItemVisitEoE(
        success: json["success"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );
}

class Result {
  Result(
      {this.pm_id,
      this.pm_name,
      this.pm_type,
      this.pm_size,
      this.bm_id,
      this.bm_name,
      this.bm_own,
      this.selected,
      this.agenda_id,
      this.eoe_seq,
      this.eoe_text,
      this.eoe_image,
      this.eoe_pmid,
      this.eoe_focus});

  int pm_id;
  String pm_name;
  String pm_type;
  String pm_size;
  int bm_id;
  String bm_name;
  String bm_own;
  int selected;
  int agenda_id;
  int eoe_seq;
  String eoe_text;
  String eoe_image;
  int eoe_pmid;
  String eoe_focus;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        pm_id: json["PM_ID"],
        pm_name: json["PM_NAME"],
        pm_type: json["PM_TYPE"],
        pm_size: json["PM_SIZE"],
        bm_id: json["BM_ID"],
        bm_name: json["BM_NAME"],
        bm_own: json["BM_OWN"],
        selected: json["Selected"],
        agenda_id: json["AGENDA_ID"],
        eoe_seq: json["EOE_SEQ"],
        eoe_text: json["EOE_TEXT"],
        eoe_image: json["EOE_IMAGE"],
        eoe_pmid: json["EOE_PMID"],
        eoe_focus: json["EOE_FOCUS"],
        // visitDate: DateTime.parse(json["VISIT_DATE"]),
      );

  Map<String, dynamic> toJson() => {
        "PM_ID": pm_id == null? 0 : pm_id,
        "PM_NAME": pm_name,
        "PM_TYPE": pm_type,
        "PM_SIZE": pm_size,
        "BM_ID": bm_id == null? 0 : bm_id, 
        "BM_NAME": bm_name,
        "BM_OWN": bm_own,
        "Selected": selected == null? 0 : selected,
        "AGENDA_ID": agenda_id == null? 0 :agenda_id ,
        "EOE_SEQ": eoe_seq == null? 0 :eoe_seq,
        "EOE_TEXT": eoe_text == null? '' :eoe_text,
        "EOE_IMAGE": eoe_image == null? '' :eoe_image,
        "EOE_PMID": eoe_pmid == null? 0 : eoe_pmid,
        "EOE_FOCUS": eoe_focus == null? '' :eoe_focus,
      };
}
