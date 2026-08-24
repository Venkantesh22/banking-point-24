class BankInfoModel {
    final String? accountNumber;
    final String? maskedAccount;
    final String? ifsc;
    final String? accountHolderName;
    final String? bankName;
    final String? status;

    BankInfoModel({
        this.accountNumber,
        this.maskedAccount,
        this.ifsc,
        this.accountHolderName,
        this.bankName,
        this.status,
    });

    factory BankInfoModel.fromJson(Map<String, dynamic> json) => BankInfoModel(
        accountNumber: json["account_number"],
        maskedAccount: json["masked_account"],
        ifsc: json["ifsc"],
        accountHolderName: json["account_holder_name"],
        bankName: json["bank_name"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "account_number": accountNumber,
        "masked_account": maskedAccount,
        "ifsc": ifsc,
        "account_holder_name": accountHolderName,
        "bank_name": bankName,
        "status": status,
    };
}
