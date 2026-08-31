import 'package:lekra/services/constants.dart';

class CreditCardChargesModel {
  final String? status;
  final bool? success;
  final String? message;
  final String? chargeScope;
  final double? defaultGstPercent;
  final double? minAmount;
  final double? maxAmount;
  final List<ChargeModel> data;

  CreditCardChargesModel({
    this.status,
    this.success,
    this.message,
    this.chargeScope,
    this.defaultGstPercent,
    this.minAmount,
    this.maxAmount,
    this.data = const [],
  });

  factory CreditCardChargesModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreditCardChargesModel(
      status: json['status']?.toString(),
      success: json['success'] as bool?,
      message: json['message']?.toString(),
      chargeScope: json['charge_scope']?.toString(),
      defaultGstPercent: (json['default_gst_percent'] as num?)?.toDouble(),
      minAmount: (json['min_amount'] as num?)?.toDouble(),
      maxAmount: (json['max_amount'] as num?)?.toDouble(),
      data: json['data'] is List
          ? (json['data'] as List)
              .whereType<Map>()
              .map(
                (item) => ChargeModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'message': message,
      'charge_scope': chargeScope,
      'default_gst_percent': defaultGstPercent,
      'min_amount': minAmount,
      'max_amount': maxAmount,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  String get minAmountFormat =>
      PriceConverter.convertToNumberFormat(minAmount ?? 0.0);
  String get maxAmountFormat =>
      PriceConverter.convertToNumberFormat(maxAmount ?? 0.0);
}

class ChargeModel {
  final int? id;
  final double? minAmount;
  final double? maxAmount;
  final String? chargeType;
  final double? chargeValue;
  final String? status;

  ChargeModel({
    this.id,
    this.minAmount,
    this.maxAmount,
    this.chargeType,
    this.chargeValue,
    this.status,
  });

  factory ChargeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ChargeModel(
      id: (json['id'] as num?)?.toInt(),
      minAmount: (json['min_amount'] as num?)?.toDouble(),
      maxAmount: (json['max_amount'] as num?)?.toDouble(),
      chargeType: json['charge_type']?.toString(),
      chargeValue: (json['charge_value'] as num?)?.toDouble(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'min_amount': minAmount,
      'max_amount': maxAmount,
      'charge_type': chargeType,
      'charge_value': chargeValue,
      'status': status,
    };
  }

  bool get isPercent => chargeType?.toLowerCase() == 'percent';

  bool get isFlat => chargeType?.toLowerCase() == 'flat';
}
