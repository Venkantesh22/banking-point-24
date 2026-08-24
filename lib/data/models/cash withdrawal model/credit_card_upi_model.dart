class CreditCardUpiModel {
  final String? upiId;
  final String? recipientName;
  final String? status;

  CreditCardUpiModel({
    this.upiId,
    this.recipientName,
    this.status,
  });

  factory CreditCardUpiModel.fromJson(Map<String, dynamic> json) => CreditCardUpiModel(
        upiId: json["upi_id"],
        recipientName: json["recipient_name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "upi_id": upiId,
        "recipient_name": recipientName,
        "status": status,
      };
}
