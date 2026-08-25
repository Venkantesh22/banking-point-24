import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class CreditCardRepo {
  final ApiClient apiClient;

  CreditCardRepo({required this.apiClient});

  Future<Response> cardWithdrawalInitiate({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.postCardWithdrawalInitiate,
        "cardWithdrawalInitiate",
        data,
      );

  Future<Response> resendCreditCardOTP({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.postResendCreditCardOTP,
        "resendCreditCardOTP",
        data,
      );

  Future<Response> creditCardOTPVerify({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.postCreditCardOTPVerify,
        "creditCardOTPVerify",
        data,
      );

  Future<Response> sendMoneyToUPIOrBank({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.postSendMoneyToUPIOrBank,
        "sendMoneyToUPIOrBank",
        data,
      );

  Future<Response> moneyWantCash({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.postMoneyWantCash,
        "moneyWantCash",
        data,
      );

  Future<Response> fetchCreditCardCharges() async => await apiClient.getData(
        AppConstants.getCreditCardCharges,
        "getCreditCardCharges",
      );

  Future<Response> calRealTimeCharge({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.postCalRealTimeCharge,
        "calRealTimeCharge",
        data,
      );

  

  Future<Response> fetchCreditCardTransactionList({
    required int page,
    required int limit,
    required String fromdate,
    required String todate,
  }) async =>
      await apiClient.postData(
        AppConstants.getCreditCardTransactionList,
        "fetchCreditCardTransactionList",
        FormData({
          "page": page,
          "limit": limit,
          "fromdate": fromdate,
          "todate": todate,
        }),
      );


        Future<Response> creditCardCashWithdrawalTransactionDetails(
          {required String transactionId}) async =>
      await apiClient.getData(
        AppConstants.getCreditCardCashWithdrawalTransactionStatus(
            transactionId: transactionId),
        "creditCardCashWithdrawalTransactionDetails",
      );
}
