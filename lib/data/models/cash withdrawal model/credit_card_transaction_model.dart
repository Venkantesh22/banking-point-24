enum PaymentStatus {
  successful,
  pending,
  cancelled,
  cash,
}

class CreditCardTransactionModel {
  // Existing fields
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

  // New fields from transaction report API
  final int? id;
  final String? title;
  final String? type;
  final String? no;
  final String? number;
  final String? formattedAmount;
  final String? status;
  final String? time;
  final String? createdAt;

  CreditCardTransactionModel({
    // Existing
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

    // New
    this.id,
    this.title,
    this.type,
    this.no,
    this.number,
    this.formattedAmount,
    this.status,
    this.time,
    this.createdAt,
  });

  factory CreditCardTransactionModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      CreditCardTransactionModel(
        // Existing API fields
        transactionId:
            json["transaction_id"] ?? json["trans_id"],
        settlementType: json["settlement_type"],
        settlementStatus:
            json["settlement_status"] ?? json["status"],
        recipientName:
            json["recipient_name"] ?? json["customer_name"],
        customerName: json["customer_name"],
        bankName: json["bank_name"],
        amount: json["amount"],
        processingFee: json["processing_fee"],
        gst: json["gst"],
        totalDebit: json["total_debit"],
        totalDebitAmount: json["total_debit_amount"],
        utr: json["utr"],
        dateTime:
            json["date_time"] ?? json["time"],
        destination: json["destination"] ?? json["number"],

        // New transaction report fields
        id: json["id"],
        title: json["title"],
        type: json["type"],
        no: json["no"],
        number: json["number"],
        formattedAmount: json["formatted_amount"],
        status: json["status"],
        time: json["time"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        // Existing
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

        // New
        "id": id,
        "title": title,
        "type": type,
        "no": no,
        "number": number,
        "formatted_amount": formattedAmount,
        "status": status,
        "time": time,
        "created_at": createdAt,
      };

  bool get settlementStatusSuccess =>
      settlementStatus?.toUpperCase() == "SUCCESS";

  bool get settlementStatusPending =>
      settlementStatus?.toUpperCase() == "PENDING";

  bool get settlementStatusCashDisbursed =>
      settlementStatus?.toUpperCase() == "CASH_DISBURSED";

  // New status helpers
  bool get statusSuccess =>
      status?.toUpperCase() == "SUCCESS";

  bool get statusPending =>
      status?.toUpperCase() == "PENDING";

  bool get statusCancelled =>
      status?.toUpperCase() == "CANCELLED" ||
      status?.toUpperCase() == "FAILED";

  bool get isCash =>
      type?.toUpperCase() == "CASH";

  bool get isUpi =>
      type?.toUpperCase() == "UPI";

  bool get isBank =>
      type?.toUpperCase() == "BANK" ||
      type?.toUpperCase() == "PENDING_CHOICE";
}