class CreditCardCashWithdrawalTransactionDetailsModel {
  final int? id;

  final String? transId;
  final String? transactionId;

  final String? paymentReference;
  final String? bankReference;
  final String? utr;
  final String? settlementUtr;
  final String? idempotencyKey;

  final String? title;
  final String? type;
  final String? settlementType;
  final String? destinationType;

  final String? no;
  final String? number;

  final String? status;
  final String? settlementStatus;
  final String? failureReason;

  final String? amount;
  final String? withdrawalAmount;
  final String? formattedAmount;

  final String? processingFee;
  final String? formattedProcessingFee;

  final String? gst;
  final String? formattedGst;

  final String? totalCharges;
  final String? formattedTotalCharges;

  final String? totalCardDebit;
  final String? formattedTotalCardDebit;

  final String? netAmount;
  final String? formattedNetAmount;

  final int? cardholderCardId;
  final String? cardMasked;
  final String? cardNetwork;
  final String? cardBankName;
  final String? cardHolderName;

  final int? cardholderKycId;

  final String? customerName;
  final String? customerMobile;

  final String? cardholderPan;
  final String? cardholderAadhaar;

  final int? beneficiaryId;

  final String? destinationBankName;
  final String? bankName;

  final String? destinationAccountNumber;
  final String? accountNumber;

  final String? destinationIfsc;
  final String? ifsc;

  final String? destinationHolderName;
  final String? recipientName;

  final String? destinationUpiId;
  final String? upiId;

  final String? time;
  final String? createdAt;
  final String? formattedCreatedAt;

  final String? settlementTime;
  final String? formattedSettlementTime;

  final String? updatedAt;

  final int? agentId;
  final String? agentName;
  final String? agentMobile;

  CreditCardCashWithdrawalTransactionDetailsModel({
    this.id,
    this.transId,
    this.transactionId,
    this.paymentReference,
    this.bankReference,
    this.utr,
    this.settlementUtr,
    this.idempotencyKey,
    this.title,
    this.type,
    this.settlementType,
    this.destinationType,
    this.no,
    this.number,
    this.status,
    this.settlementStatus,
    this.failureReason,
    this.amount,
    this.withdrawalAmount,
    this.formattedAmount,
    this.processingFee,
    this.formattedProcessingFee,
    this.gst,
    this.formattedGst,
    this.totalCharges,
    this.formattedTotalCharges,
    this.totalCardDebit,
    this.formattedTotalCardDebit,
    this.netAmount,
    this.formattedNetAmount,
    this.cardholderCardId,
    this.cardMasked,
    this.cardNetwork,
    this.cardBankName,
    this.cardHolderName,
    this.cardholderKycId,
    this.customerName,
    this.customerMobile,
    this.cardholderPan,
    this.cardholderAadhaar,
    this.beneficiaryId,
    this.destinationBankName,
    this.bankName,
    this.destinationAccountNumber,
    this.accountNumber,
    this.destinationIfsc,
    this.ifsc,
    this.destinationHolderName,
    this.recipientName,
    this.destinationUpiId,
    this.upiId,
    this.time,
    this.createdAt,
    this.formattedCreatedAt,
    this.settlementTime,
    this.formattedSettlementTime,
    this.updatedAt,
    this.agentId,
    this.agentName,
    this.agentMobile,
  });

  factory CreditCardCashWithdrawalTransactionDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreditCardCashWithdrawalTransactionDetailsModel(
      id: _toInt(json['id']),

      transId: json['trans_id']?.toString(),
      transactionId: json['transaction_id']?.toString(),

      paymentReference: json['payment_reference']?.toString(),
      bankReference: json['bank_reference']?.toString(),
      utr: json['utr']?.toString(),
      settlementUtr: json['settlement_utr']?.toString(),
      idempotencyKey: json['idempotency_key']?.toString(),

      title: json['title']?.toString(),
      type: json['type']?.toString(),
      settlementType: json['settlement_type']?.toString(),
      destinationType: json['destination_type']?.toString(),

      no: json['no']?.toString(),
      number: json['number']?.toString(),

      status: json['status']?.toString(),
      settlementStatus: json['settlement_status']?.toString(),
      failureReason: json['failure_reason']?.toString(),

      amount: json['amount']?.toString(),
      withdrawalAmount: json['withdrawal_amount']?.toString(),
      formattedAmount: json['formatted_amount']?.toString(),

      processingFee: json['processing_fee']?.toString(),
      formattedProcessingFee:
          json['formatted_processing_fee']?.toString(),

      gst: json['gst']?.toString(),
      formattedGst: json['formatted_gst']?.toString(),

      totalCharges: json['total_charges']?.toString(),
      formattedTotalCharges:
          json['formatted_total_charges']?.toString(),

      totalCardDebit: json['total_card_debit']?.toString(),
      formattedTotalCardDebit:
          json['formatted_total_card_debit']?.toString(),

      netAmount: json['net_amount']?.toString(),
      formattedNetAmount:
          json['formatted_net_amount']?.toString(),

      cardholderCardId: _toInt(json['cardholder_card_id']),
      cardMasked: json['card_masked']?.toString(),
      cardNetwork: json['card_network']?.toString(),
      cardBankName: json['card_bank_name']?.toString(),
      cardHolderName: json['card_holder_name']?.toString(),

      cardholderKycId: _toInt(json['cardholder_kyc_id']),

      customerName: json['customer_name']?.toString(),
      customerMobile: json['customer_mobile']?.toString(),

      cardholderPan: json['cardholder_pan']?.toString(),
      cardholderAadhaar:
          json['cardholder_aadhaar']?.toString(),

      beneficiaryId: _toInt(json['beneficiary_id']),

      destinationBankName:
          json['destination_bank_name']?.toString(),
      bankName: json['bank_name']?.toString(),

      destinationAccountNumber:
          json['destination_account_number']?.toString(),
      accountNumber: json['account_number']?.toString(),

      destinationIfsc: json['destination_ifsc']?.toString(),
      ifsc: json['ifsc']?.toString(),

      destinationHolderName:
          json['destination_holder_name']?.toString(),
      recipientName: json['recipient_name']?.toString(),

      destinationUpiId:
          json['destination_upi_id']?.toString(),
      upiId: json['upi_id']?.toString(),

      time: json['time']?.toString(),
      createdAt: json['created_at']?.toString(),
      formattedCreatedAt:
          json['formatted_created_at']?.toString(),

      settlementTime:
          json['settlement_time']?.toString(),
      formattedSettlementTime:
          json['formatted_settlement_time']?.toString(),

      updatedAt: json['updated_at']?.toString(),

      agentId: _toInt(json['agent_id']),
      agentName: json['agent_name']?.toString(),
      agentMobile: json['agent_mobile']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'trans_id': transId,
      'transaction_id': transactionId,

      'payment_reference': paymentReference,
      'bank_reference': bankReference,
      'utr': utr,
      'settlement_utr': settlementUtr,
      'idempotency_key': idempotencyKey,

      'title': title,
      'type': type,
      'settlement_type': settlementType,
      'destination_type': destinationType,

      'no': no,
      'number': number,

      'status': status,
      'settlement_status': settlementStatus,
      'failure_reason': failureReason,

      'amount': amount,
      'withdrawal_amount': withdrawalAmount,
      'formatted_amount': formattedAmount,

      'processing_fee': processingFee,
      'formatted_processing_fee': formattedProcessingFee,

      'gst': gst,
      'formatted_gst': formattedGst,

      'total_charges': totalCharges,
      'formatted_total_charges': formattedTotalCharges,

      'total_card_debit': totalCardDebit,
      'formatted_total_card_debit': formattedTotalCardDebit,

      'net_amount': netAmount,
      'formatted_net_amount': formattedNetAmount,

      'cardholder_card_id': cardholderCardId,
      'card_masked': cardMasked,
      'card_network': cardNetwork,
      'card_bank_name': cardBankName,
      'card_holder_name': cardHolderName,

      'cardholder_kyc_id': cardholderKycId,

      'customer_name': customerName,
      'customer_mobile': customerMobile,

      'cardholder_pan': cardholderPan,
      'cardholder_aadhaar': cardholderAadhaar,

      'beneficiary_id': beneficiaryId,

      'destination_bank_name': destinationBankName,
      'bank_name': bankName,

      'destination_account_number':
          destinationAccountNumber,
      'account_number': accountNumber,

      'destination_ifsc': destinationIfsc,
      'ifsc': ifsc,

      'destination_holder_name':
          destinationHolderName,
      'recipient_name': recipientName,

      'destination_upi_id': destinationUpiId,
      'upi_id': upiId,

      'time': time,
      'created_at': createdAt,
      'formatted_created_at': formattedCreatedAt,

      'settlement_time': settlementTime,
      'formatted_settlement_time':
          formattedSettlementTime,

      'updated_at': updatedAt,

      'agent_id': agentId,
      'agent_name': agentName,
      'agent_mobile': agentMobile,
    };
  }

  // ==========================================================
  // TYPE HELPERS
  // ==========================================================

  bool get isCash =>
      type?.toUpperCase() == 'CASH';

  bool get isUpi =>
      type?.toUpperCase() == 'UPI';

  bool get isBank =>
      type?.toUpperCase() == 'BANK' ||
      type?.toUpperCase() == 'PENDING_CHOICE';

  // ==========================================================
  // STATUS HELPERS
  // ==========================================================

  bool get isTransactionSuccess =>
      status?.toUpperCase() == 'SUCCESS';

  bool get isTransactionPending =>
      status?.toUpperCase() == 'PENDING';

  bool get isTransactionFailed =>
      status?.toUpperCase() == 'FAILED' ||
      status?.toUpperCase() == 'FAILURE' ||
      status?.toUpperCase() == 'CANCELLED';

  bool get isSettlementSuccess =>
      settlementStatus?.toUpperCase() == 'SUCCESS';

  bool get isSettlementPending =>
      settlementStatus?.toUpperCase() == 'PENDING';

  bool get isCashDisbursed =>
      settlementStatus?.toUpperCase() == 'CASH_DISBURSED';

  // ==========================================================
  // DISPLAY HELPERS
  // ==========================================================

  String get displayAmount =>
      formattedAmount ?? amount ?? '-';

  String get displayProcessingFee =>
      formattedProcessingFee ??
      processingFee ??
      '-';

  String get displayGst =>
      formattedGst ?? gst ?? '-';

  String get displayTotalCardDebit =>
      formattedTotalCardDebit ??
      totalCardDebit ??
      '-';

  String get displayNetAmount =>
      formattedNetAmount ??
      netAmount ??
      '-';

  String get displayDateTime =>
      formattedCreatedAt ??
      time ??
      '-';

  String get displayRecipient {
    if (isUpi) {
      return recipientName ??
          destinationHolderName ??
          upiId ??
          '-';
    }

    if (isCash) {
      return recipientName ??
          destinationHolderName ??
          customerName ??
          '-';
    }

    return recipientName ??
        destinationHolderName ??
        customerName ??
        '-';
  }

  String get displayDestination {
    if (isUpi) {
      return destinationUpiId ??
          upiId ??
          number ??
          '-';
    }

    if (isCash) {
      return number ??
          no ??
          customerMobile ??
          '-';
    }

    return destinationAccountNumber ??
        accountNumber ??
        number ??
        no ??
        '-';
  }

  String get displayBankName =>
      destinationBankName != null &&
              destinationBankName!.trim().isNotEmpty &&
              destinationBankName != '-'
          ? destinationBankName!
          : bankName ?? '-';

  String get displayStatus =>
      settlementStatus ??
      status ??
      '-';

  static int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString());
  }
}