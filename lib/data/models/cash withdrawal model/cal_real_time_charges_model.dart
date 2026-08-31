import 'package:lekra/services/constants.dart';

class CalRealTimeCharges {
  final double? withdrawalAmount;
  final double? processingFee;
  final double? gst;
  final double? gstPercentage;
  final double? totalCardDebit;
  final double? netAmount;
  final String? chargeType;
  final double? chargeValue;
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

  factory CalRealTimeCharges.fromJson(
    Map<String, dynamic> json,
  ) {
    return CalRealTimeCharges(
      withdrawalAmount: (json['withdrawal_amount'] as num?)?.toDouble(),
      processingFee: (json['processing_fee'] as num?)?.toDouble(),
      gst: (json['gst'] as num?)?.toDouble(),
      gstPercentage: (json['gst_percentage'] as num?)?.toDouble(),
      totalCardDebit: (json['total_card_debit'] as num?)?.toDouble(),
      netAmount: (json['net_amount'] as num?)?.toDouble(),
      chargeType: json['charge_type']?.toString(),
      chargeValue: (json['charge_value'] as num?)?.toDouble(),
      chargeRuleId: (json['charge_rule_id'] as num?)?.toInt(),
      isCustomUserCharge: json['is_custom_user_charge'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'withdrawal_amount': withdrawalAmount,
      'processing_fee': processingFee,
      'gst': gst,
      'gst_percentage': gstPercentage,
      'total_card_debit': totalCardDebit,
      'net_amount': netAmount,
      'charge_type': chargeType,
      'charge_value': chargeValue,
      'charge_rule_id': chargeRuleId,
      'is_custom_user_charge': isCustomUserCharge,
    };
  }

  bool get isPercent => chargeType?.toLowerCase() == 'percent';

  bool get isFlat => chargeType?.toLowerCase() == 'flat';

  String get gstFormat => PriceConverter.convertToNumberFormat(gst ?? 0.0);
  String get processingFeeFormat =>
      PriceConverter.convertToNumberFormat(processingFee ?? 0.0);
  String get totalCardDebitFormat =>
      PriceConverter.convertToNumberFormat(totalCardDebit ?? 0.0);
}
