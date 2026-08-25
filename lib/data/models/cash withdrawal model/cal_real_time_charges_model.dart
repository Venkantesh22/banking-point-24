class CalRealTimeCharges {
  final int? withdrawalAmount;
  final int? processingFee;
  final double? gst;
  final int? gstPercentage;
  final double? totalCardDebit;
  final int? netAmount;
  final String? chargeType;
  final int? chargeValue;
  final int? chargeRuleId;
  final bool? isCustomUserCharge;

  CalRealTimeCharges({
    this.withdrawalAmount,
    this.processingFee,
    this.gst,
    this.gstPercentage,
    this.totalCardDebit,
    this.netAmount,
    this.chargeType,
    this.chargeValue,
    this.chargeRuleId,
    this.isCustomUserCharge,
  });

  factory CalRealTimeCharges.fromJson(Map<String, dynamic> json) =>
      CalRealTimeCharges(
        withdrawalAmount: json["withdrawal_amount"],
        processingFee: json["processing_fee"],
        gst: json["gst"]?.toDouble(),
        gstPercentage: json["gst_percentage"],
        totalCardDebit: json["total_card_debit"]?.toDouble(),
        netAmount: json["net_amount"],
        chargeType: json["charge_type"],
        chargeValue: json["charge_value"],
        chargeRuleId: json["charge_rule_id"],
        isCustomUserCharge: json["is_custom_user_charge"],
      );

  Map<String, dynamic> toJson() => {
        "withdrawal_amount": withdrawalAmount,
        "processing_fee": processingFee,
        "gst": gst,
        "gst_percentage": gstPercentage,
        "total_card_debit": totalCardDebit,
        "net_amount": netAmount,
        "charge_type": chargeType,
        "charge_value": chargeValue,
        "charge_rule_id": chargeRuleId,
        "is_custom_user_charge": isCustomUserCharge,
      };
}
