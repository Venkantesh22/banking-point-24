import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/cal_real_time_charges_model.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_charges_model.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_transaction_details_model.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_transaction_model.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/initiation_withdrawal_model.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/withdrawal_model.dart';
import 'package:lekra/data/models/pagination/pagination_state.dart';
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

  final TextEditingController cardNumberController = TextEditingController();

  final TextEditingController expiryDateController = TextEditingController();

  final TextEditingController cvvController = TextEditingController();

  final TextEditingController cardHolderNameController =
      TextEditingController();
  final TextEditingController bankNameController = TextEditingController();

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

  // //* Call request and resend opt credit card fetchCreditCardTransactionList()

  String creditCardTransactionFromDate = DateFormat('yyyy-MM-dd').format(
    DateTime.now().subtract(
      const Duration(days: 30),
    ),
  );

  String creditCardTransactionToDate = DateFormat('yyyy-MM-dd').format(
    DateTime.now(),
  );

  final PaginationState<CreditCardTransactionModel> creditCardTransactionState =
      PaginationState<CreditCardTransactionModel>();

  List<CreditCardTransactionModel> get creditCardTransactionList =>
      creditCardTransactionState.items;
  Future<ResponseModel> fetchCreditCardTransactionList({
    required String fromdate,
    required String todate,
    bool loadMore = false,
    bool refresh = false,
    int limit = 10,
  }) async {
    log(
      '----------- fetchCreditCardTransactionList Called '
      'page=${creditCardTransactionState.page} '
      'loadMore=$loadMore refresh=$refresh ----------',
    );

    ResponseModel responseModel = ResponseModel(false, 'Unknown error');

    // ==========================================================
    // RESET
    // ==========================================================

    if (refresh) {
      creditCardTransactionState.reset();
    }

    // ==========================================================
    // LOAD MORE
    // ==========================================================

    if (loadMore) {
      if (!creditCardTransactionState.canLoadMore) {
        return ResponseModel(
          false,
          'No more transactions',
        );
      }

      creditCardTransactionState.page++;
      creditCardTransactionState.isMoreLoading = true;
    } else {
      creditCardTransactionState.page = 1;
      creditCardTransactionState.isInitialLoading = true;
    }

    update();

    try {
      final Response response =
          await creditCardRepo.fetchCreditCardTransactionList(
        page: creditCardTransactionState.page,
        limit: limit,
        fromdate: fromdate,
        todate: todate,
      );

      log(
        'STATUS CODE: ${response.statusCode}',
        name: 'fetchCreditCardTransactionList',
      );

      log(
        'RESPONSE BODY: ${response.body}',
        name: 'fetchCreditCardTransactionList',
      );

      // ==========================================================
      // VALIDATE RESPONSE
      // ==========================================================

      if (response.statusCode != 200 || response.body is! Map) {
        responseModel = ResponseModel(
          false,
          response.statusText ?? 'Failed to fetch credit card transactions',
        );
        return responseModel;
      }

      final Map<String, dynamic> body =
          Map<String, dynamic>.from(response.body);

      final bool success = body['success'] == true ||
          body['status']?.toString().toLowerCase() == 'success';

      if (!success) {
        responseModel = ResponseModel(
          false,
          body['message']?.toString() ??
              'Failed to fetch credit card transactions',
        );
        return responseModel;
      }

      // ==========================================================
      // PAGINATION DATA FROM API
      // ==========================================================

      final int currentPage = (body['current_page'] ??
          body['pagination']?['current_page'] ??
          creditCardTransactionState.page) as int;

      final int lastPage =
          (body['last_page'] ?? body['pagination']?['last_page'] ?? 1) as int;

      final int total =
          (body['total'] ?? body['pagination']?['total'] ?? 0) as int;

      final int perPage =
          (body['per_page'] ?? body['pagination']?['per_page'] ?? limit) as int;

      final bool hasMore =
          body['pagination']?['has_more'] ?? currentPage < lastPage;

      // We only store page/lastPage because that is what
      // PaginationState supports.
      creditCardTransactionState.page = currentPage;
      creditCardTransactionState.lastPage = lastPage;

      log(
        'Pagination: '
        'page=$currentPage, '
        'lastPage=$lastPage, '
        'total=$total, '
        'perPage=$perPage, '
        'hasMore=$hasMore',
        name: 'fetchCreditCardTransactionList',
      );

      // ==========================================================
      // PARSE DATA
      // ==========================================================

      final List<dynamic> responseData =
          body['data'] is List ? body['data'] : <dynamic>[];

      final List<CreditCardTransactionModel> parsedTransactions = responseData
          .whereType<Map>()
          .map(
            (item) => CreditCardTransactionModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      // ==========================================================
      // ADD / REPLACE DATA
      // ==========================================================

      if (loadMore) {
        for (final transaction in parsedTransactions) {
          if (!creditCardTransactionState.dedupeIds.contains(transaction.id)) {
            creditCardTransactionState.dedupeIds.add(transaction.id);

            creditCardTransactionState.items.add(transaction);
          }
        }
      } else {
        creditCardTransactionState.items
          ..clear()
          ..addAll(parsedTransactions);

        creditCardTransactionState.dedupeIds
          ..clear()
          ..addAll(
            parsedTransactions.map(
              (transaction) => transaction.id,
            ),
          );
      }

      log(
        'Fetched page $currentPage/$lastPage | '
        'received=${parsedTransactions.length} | '
        'stored=${creditCardTransactionState.items.length}',
        name: 'fetchCreditCardTransactionList',
      );

      responseModel = ResponseModel(
        true,
        body['message']?.toString() ??
            'Credit card transactions fetched successfully',
      );
    } catch (e, stackTrace) {
      log(
        'ERROR AT fetchCreditCardTransactionList(): $e\n$stackTrace',
        name: 'fetchCreditCardTransactionList',
      );

      // Roll back page if loading more failed.
      if (loadMore && creditCardTransactionState.page > 1) {
        creditCardTransactionState.page--;
      }

      responseModel = ResponseModel(
        false,
        'Error while fetching credit card transactions: $e',
      );
    } finally {
      creditCardTransactionState.isInitialLoading = false;
      creditCardTransactionState.isMoreLoading = false;
      update();
    }

    return responseModel;
  }

  CreditCardCashWithdrawalTransactionDetailsModel?
      creditCardCashWithdrawalTransactionDetailsModel;
//* check a Credit card withdrawal transaction status creditCardCashWithdrawalTransactionStatus()
  Future<ResponseModel> creditCardCashWithdrawalTransactionDetails(
      {required String? transactionId}) async {
    log('----------- creditCardCashWithdrawalTransactionDetails Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response =
          await creditCardRepo.creditCardCashWithdrawalTransactionDetails(
              transactionId: transactionId ?? "");

      if (response.statusCode == 200 && response.body['status'] == "success") {
        creditCardCashWithdrawalTransactionDetailsModel =
            CreditCardCashWithdrawalTransactionDetailsModel.fromJson(
                response.body['data']);
        responseModel = ResponseModel(
            true,
            response.body['message'] ??
                " creditCardCashWithdrawalTransactionDetails success");
      } else {
        responseModel = ResponseModel(
            false,
            response.body?['message'] ??
                response.statusText ??
                "Error while creditCardCashWithdrawalTransactionDetails");
      }
    } catch (e) {
      log('ERROR AT creditCardCashWithdrawalTransactionDetails(): $e');
      responseModel = ResponseModel(false,
          "Error while creditCardCashWithdrawalTransactionDetails user $e");
    }

    isLoading = false;
    update();
    return responseModel;
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
