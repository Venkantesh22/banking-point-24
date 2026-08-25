import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/cal_real_time_charges_model.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_charges_model.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_transaction_model.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/initiation_withdrawal_model.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/withdrawal_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/card_withdrawal_repo/credit_card_repo.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreditCardController extends GetxController implements GetxService {
  final CreditCardRepo creditCardRepo;
  final SharedPreferences sharedPreferences;

  CreditCardController({
    required this.creditCardRepo,
    required this.sharedPreferences,
  });

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController amountController = TextEditingController();

  final TextEditingController cardNumberController =
      TextEditingController(text: "4532758912345678");

  final TextEditingController expiryDateController = TextEditingController();

  final TextEditingController cvvController =
      TextEditingController(text: "999");

  final TextEditingController cardHolderNameController =
      TextEditingController(text: "Rahul Sharma");
  final TextEditingController bankNameController =
      TextEditingController(text: "HDFC Bank");

  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final TextEditingController otpPinputController = TextEditingController();

  final FocusNode otpFocusNode = FocusNode();

  void updatePinputOtp() {
    otp = otpPinputController.text;
    isOtpVerified = otp.length == 6;
    update();
  }

  void clearOtpForPinput() {
    otpPinputController.clear();

    for (final controller in otpControllers) {
      controller.clear();
    }

    otp = '';
    isOtpVerified = false;

    update();
  }

  // ============================================================
  // WITHDRAWAL DATA
  // ============================================================

  bool isLoading = false;

  // ============================================================

  bool isOtpVerified = false;

  // ============================================================
  // OTP
  // ============================================================

  String otp = '';

  void updateOtp() {
    otp = otpControllers.map((controller) => controller.text).join();

    isOtpVerified = otp.length == 6;

    update();
  }

  void verifyOtp() {
    if (otp.length != 6) {
      return;
    }

    isOtpVerified = true;
    update();
  }

  // ============================================================
  // CARD VALIDATION
  // ============================================================

  bool validateCard() {
    final String cardNumber =
        cardNumberController.text.replaceAll(' ', '').trim();

    final String expiry = expiryDateController.text.trim();

    final String cvv = cvvController.text.trim();

    final String holder = cardHolderNameController.text.trim();

    if (cardNumber.length != 16) {
      return false;
    }

    if (expiry.length != 5) {
      return false;
    }

    if (cvv.length != 3) {
      return false;
    }

    if (holder.isEmpty) {
      return false;
    }

    return true;
  }

  // ============================================================
  // SUBMIT WITHDRAWAL
  // ============================================================

  WithdrawalModel? withdrawalModel;
  //* Call Submit credit card withdrawal amount cardWithdrawalInitiate()
  Future<ResponseModel> cardWithdrawalInitiate(
      {required String? number}) async {
    log('----------- cardWithdrawalInitiate Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();
    log('-----------  number = $number ----------');

    try {
      final sessionId =
          sharedPreferences.getString(AppConstants.apiToken) ?? '';

      Map<String, dynamic> data = {
        "session_id": sessionId,
        "mobile_number": number,
        "withdrawal_amount": amountController.text.trim(),
        "card_number": cardNumberController.text.trim(),
        "expiry_date": "08\/29",
        "cvv": cvvController.text.trim(),
        "card_holder_name": cardHolderNameController.text.trim(),
        "bank_name": bankNameController.text.trim(),
      };
      Response response =
          await creditCardRepo.cardWithdrawalInitiate(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        withdrawalModel = WithdrawalModel.fromJson(response.body['data']);
        responseModel = ResponseModel(true,
            response.body['message'] ?? " cardWithdrawalInitiate success");
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while cardWithdrawalInitiate");
      }
    } catch (e) {
      log('ERROR AT cardWithdrawalInitiate(): $e');
      responseModel =
          ResponseModel(false, "Error while cardWithdrawalInitiate user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  //* Call request and resend opt credit card resendCreditCardOTP()
  Future<ResponseModel> resendCreditCardOTP() async {
    log('----------- resendCreditCardOTP Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      final sessionId =
          sharedPreferences.getString(AppConstants.apiToken) ?? '';
      Map<String, dynamic> data = {
        "session_id": sessionId,
        "transaction_id": withdrawalModel?.transactionId ?? "",
      };
      Response response =
          await creditCardRepo.resendCreditCardOTP(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        responseModel = ResponseModel(
            true, response.body['message'] ?? " resendCreditCardOTP success");
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while resendCreditCardOTP");
      }
    } catch (e) {
      log('ERROR AT resendCreditCardOTP(): $e');
      responseModel =
          ResponseModel(false, "Error while resendCreditCardOTP user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  InitiationWithdrawalModel? initiationWithdrawalModel;
  //* Call verify opt credit card creditCardOTPVerify()
  Future<ResponseModel> creditCardOTPVerify() async {
    log('----------- creditCardOTPVerify Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      final sessionId =
          sharedPreferences.getString(AppConstants.apiToken) ?? '';
      Map<String, dynamic> data = {
        "session_id": sessionId,
        "transaction_id": withdrawalModel?.transactionId ?? "",
        "otp": otp
      };
      Response response =
          await creditCardRepo.creditCardOTPVerify(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        initiationWithdrawalModel =
            InitiationWithdrawalModel.fromJson(response.body['data']);
        responseModel = ResponseModel(
            true, response.body['message'] ?? " creditCardOTPVerify success");
      } else {
        responseModel = ResponseModel(
            false,
            response.body?['message'] ??
                response.statusText ??
                "Error while creditCardOTPVerify");
      }
    } catch (e) {
      log('ERROR AT creditCardOTPVerify(): $e');
      responseModel =
          ResponseModel(false, "Error while creditCardOTPVerify user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  CreditCardTransactionModel? creditCardTransactionModel;
  Future<ResponseModel> sendMoneyToUPIOrBank({
    required bool isUpi,
    String? upiId,
    String? recipientName,
    String? accountNo,
    String? ifscCode,
    String? bankName,
  }) async {
    log('----------- sendMoneyToUPIOrBank Called ----------');

    ResponseModel responseModel;

    isLoading = true;
    update();

    try {
      final sessionId =
          sharedPreferences.getString(AppConstants.apiToken) ?? '';

      Map<String, dynamic> data = isUpi
          ? {
              "session_id": sessionId,
              "transaction_id": withdrawalModel?.transactionId ?? "",
              "type": "upi",
              "upi_id": upiId,
              "recipient_name": recipientName
            }
          : {
              "session_id": sessionId,
              "transaction_id": withdrawalModel?.transactionId ?? "",
              "type": "bank",
              "account_number": accountNo,
              "ifsc": ifscCode,
              "account_holder_name": recipientName,
              "bank_name": bankName,
            };

      Response response =
          await creditCardRepo.sendMoneyToUPIOrBank(data: FormData(data));

      if (response.statusCode == 200 && response.body['success'] == true) {
        creditCardTransactionModel =
            CreditCardTransactionModel.fromJson(response.body['data']);
        responseModel = ResponseModel(
            true, response.body['message'] ?? " sendMoneyToUPIOrBank success");
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while sendMoneyToUPIOrBank");
      }
    } catch (e) {
      log('ERROR AT sendMoneyToUPIOrBank(): $e');
      responseModel =
          ResponseModel(false, "Error while sendMoneyToUPIOrBank user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> moneyWantCash() async {
    log('----------- moneyWantCash Called ----------');

    ResponseModel responseModel;

    isLoading = true;
    update();

    try {
      final sessionId =
          sharedPreferences.getString(AppConstants.apiToken) ?? '';

      Map<String, dynamic> data = {
        "session_id": sessionId,
        "transaction_id": withdrawalModel?.transactionId ?? ""
      };

      Response response =
          await creditCardRepo.moneyWantCash(data: FormData(data));

      if (response.statusCode == 200 && response.body['success'] == true) {
        creditCardTransactionModel =
            CreditCardTransactionModel.fromJson(response.body['data']);
        responseModel = ResponseModel(
            true, response.body['message'] ?? " moneyWantCash success");
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Error while moneyWantCash");
      }
    } catch (e) {
      log('ERROR AT moneyWantCash(): $e');
      responseModel = ResponseModel(false, "Error while moneyWantCash user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  List<CreditCardChargesModel> creditCardChargesModelList = [];
  Future<ResponseModel> fetchCreditCardCharges() async {
    log('----------- fetchCreditCardCharges Called ----------');

    isLoading = true;
    update();

    try {
      final Response response = await creditCardRepo.fetchCreditCardCharges();

      if (response.statusCode == 200 &&
          response.body is Map &&
          response.body['success'] == true) {
        final data = response.body['data'];

        if (data is List) {
          creditCardChargesModelList = data
              .map(
                (e) => CreditCardChargesModel.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList();
        } else {
          creditCardChargesModelList = [];
        }

        return ResponseModel(
          true,
          response.body['message'] ?? 'fetchCreditCardCharges success',
        );
      }

      return ResponseModel(
        false,
        response.body is Map
            ? response.body['message'] ?? 'Error while fetchCreditCardCharges'
            : response.statusText ?? 'Error while fetchCreditCardCharges',
      );
    } catch (e, stackTrace) {
      log(
        'ERROR AT fetchCreditCardCharges(): $e',
        stackTrace: stackTrace,
      );

      return ResponseModel(
        false,
        'Error while fetchCreditCardCharges: $e',
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  bool isCalculatingCharge = false;
  CalRealTimeCharges? calRealTimeCharges;
  Future<ResponseModel> calRealTimeCharge() async {
    log('----------- calRealTimeCharge Called ----------');

    isCalculatingCharge = true;
    update();

    try {
      final String amount = amountController.text.trim();

      if (amount.isEmpty) {
        calRealTimeCharges = null;

        return ResponseModel(
          false,
          'Amount is required',
        );
      }

      final Map<String, dynamic> data = {
        "amount": amount,
      };

      final Response response = await creditCardRepo.calRealTimeCharge(
        data: FormData(data),
      );

      log('STATUS CODE: ${response.statusCode}');
      log('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200 &&
          response.body is Map &&
          response.body['status'] == 'success') {
        calRealTimeCharges = CalRealTimeCharges.fromJson(
          Map<String, dynamic>.from(
            response.body['data'],
          ),
        );

        return ResponseModel(
          true,
          response.body['message']?.toString() ??
              'Charge calculated successfully',
        );
      }

      calRealTimeCharges = null;

      return ResponseModel(
        false,
        response.body is Map
            ? response.body['message']?.toString() ??
                'Charge calculation failed'
            : 'Charge calculation failed',
      );
    } catch (e, stackTrace) {
      log(
        'ERROR AT calRealTimeCharge(): $e',
        stackTrace: stackTrace,
      );

      calRealTimeCharges = null;

      return ResponseModel(
        false,
        'Error while calculating charge: $e',
      );
    } finally {
      isCalculatingCharge = false;
      update();
    }
  }

  // ============================================================
  // CLEAR
  // ============================================================

  void clearForm() {
    amountController.clear();
    cardNumberController.clear();
    expiryDateController.clear();
    cvvController.clear();
    cardHolderNameController.clear();

    for (final controller in otpControllers) {
      controller.clear();
    }

    isOtpVerified = false;

    otp = '';

    update();
  }

  // ============================================================
  // OTP TIMER
  // ============================================================

  Timer? _otpTimer;

  int otpSecondsRemaining = 30;

  bool get canResendOtp => otpSecondsRemaining <= 0;

  String get otpTimerText {
    final seconds = otpSecondsRemaining.toString().padLeft(2, '0');
    return '00:$seconds';
  }

  void startOtpTimer() {
    _otpTimer?.cancel();

    otpSecondsRemaining = 30;
    update();

    _otpTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (otpSecondsRemaining > 0) {
          otpSecondsRemaining--;
          update();
        } else {
          timer.cancel();
          _otpTimer = null;
          update();
        }
      },
    );
  }

  void resendOtp() {
    if (!canResendOtp) {
      return;
    }

    // Call your resend OTP API here.

    startOtpTimer();
    update();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    amountController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    cardHolderNameController.dispose();
    bankNameController.dispose();

    otpPinputController.dispose();
    otpFocusNode.dispose();

    _otpTimer?.cancel();
    for (final controller in otpControllers) {
      controller.dispose();
    }

    super.onClose();
  }
}
