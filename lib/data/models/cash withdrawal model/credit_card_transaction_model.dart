enum PaymentStatus {
  successful,
  pending,
  cancelled,
  cash,
}

class CreditCardTransactionModel {
    final String? transactionId;
    final String? settlementType;
    final String? settlementStatus;
    final String? recipientName;
    final String? customerName;
    final String? bankName;
    final String? amount;
    final String? processingFee;
    final String? gst;
    final String? totalDebit;
    final String? totalDebitAmount;
    final String? utr;
    final String? dateTime;
    final String? destination;

    CreditCardTransactionModel({
        this.transactionId,
        this.settlementType,
        this.settlementStatus,
        this.recipientName,
        this.customerName,
        this.bankName,
        this.amount,
        this.processingFee,
        this.gst,
        this.totalDebit,
        this.totalDebitAmount,
        this.utr,
        this.dateTime,
        this.destination,
    });

    factory CreditCardTransactionModel.fromJson(Map<String, dynamic> json) => CreditCardTransactionModel(
        transactionId: json["transaction_id"],
        settlementType: json["settlement_type"],
        settlementStatus: json["settlement_status"],
        recipientName: json["recipient_name"],
        customerName: json["customer_name"],
        bankName: json["bank_name"],
        amount: json["amount"],
        processingFee: json["processing_fee"],
        gst: json["gst"],
        totalDebit: json["total_debit"],
        totalDebitAmount: json["total_debit_amount"],
        utr: json["utr"],
        dateTime: json["date_time"],
        destination: json["destination"],
    );

    Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "settlement_type": settlementType,
        "settlement_status": settlementStatus,
        "recipient_name": recipientName,
        "customer_name": customerName,
        "bank_name": bankName,
        "amount": amount,
        "processing_fee": processingFee,
        "gst": gst,
        "total_debit": totalDebit,
        "total_debit_amount": totalDebitAmount,
        "utr": utr,
        "date_time": dateTime,
        "destination": destination,
    };

  bool get settlementStatusSuccess => settlementStatus == "SUCCESS";
  bool get settlementStatusPending => settlementStatus == "PENDING";
  bool get settlementStatusCashDisbursed =>
      settlementStatus == "CASH_DISBURSED";
}
