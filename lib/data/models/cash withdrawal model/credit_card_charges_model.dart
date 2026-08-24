class CreditCardChargesModel {
  final int? id;
  final int? minAmount;
  final int? maxAmount;
  final String? chargeType;
  final int? chargeValue;
  final String? status;

  CreditCardChargesModel({
    this.id,
    this.minAmount,
    this.maxAmount,
    this.chargeType,
    this.chargeValue,
    this.status,
  });

  factory CreditCardChargesModel.fromJson(Map<String, dynamic> json) =>
      CreditCardChargesModel(
        id: json["id"],
        minAmount: json["min_amount"],
        maxAmount: json["max_amount"],
        chargeType: json["charge_type"],
        chargeValue: json["charge_value"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "min_amount": minAmount,
        "max_amount": maxAmount,
        "charge_type": chargeType,
        "charge_value": chargeValue,
        "status": status,
      };

  bool get isPercent => chargeType == "percent";
  bool get isFlat => chargeType == "flat";
}
