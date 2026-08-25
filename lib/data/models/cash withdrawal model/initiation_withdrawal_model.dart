
class InitiationWithdrawalModel {
    final String? transactionId;
    final String? amount;
    final String? processingFee;
    final String? gst;
    final String? totalCardDebit;
    final String? netAmount;
    final String? cardMasked;
    final String? cardBankName;
    final String? cardNetwork;
    final String? customerName;
    final String? dateTime;
    final String? status;

    InitiationWithdrawalModel({
        this.transactionId,
        this.amount,
        this.processingFee,
        this.gst,
        this.totalCardDebit,
        this.netAmount,
        this.cardMasked,
        this.cardBankName,
        this.cardNetwork,
        this.customerName,
        this.dateTime,
        this.status,
    });

    factory InitiationWithdrawalModel.fromJson(Map<String, dynamic> json) => InitiationWithdrawalModel(
        transactionId: json["transaction_id"],
        amount: json["amount"],
        processingFee: json["processing_fee"],
        gst: json["gst"],
        totalCardDebit: json["total_card_debit"],
        netAmount: json["net_amount"],
        cardMasked: json["card_masked"],
        cardBankName: json["card_bank_name"],
        cardNetwork: json["card_network"],
        customerName: json["customer_name"],
        dateTime: json["date_time"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "amount": amount,
        "processing_fee": processingFee,
        "gst": gst,
        "total_card_debit": totalCardDebit,
        "net_amount": netAmount,
        "card_masked": cardMasked,
        "card_bank_name": cardBankName,
        "card_network": cardNetwork,
        "customer_name": customerName,
        "date_time": dateTime,
        "status": status,
    };
}
