import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class CustomKycRepo {
  final ApiClient apiClient;

  CustomKycRepo({required this.apiClient});

  Future<Response> checkCustomerKYC({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.postCheckCustomer,
        "checkCustomerKYC",
        data,
      );

  Future<Response> cardWithdrawalCustomerKYC({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.postCardWithdrawalCustomerKYC,
        "cardWithdrawalCustomerKYC",
        data,
      );

  Future<Response> customerKycMobileCreditCardOTP(
          {required FormData data}) async =>
      await apiClient.postData(
        AppConstants.postCustomerKycMobileCreditCardOTP,
        "customerKycMobileCreditCardOTP",
        data,
      );

  Future<Response> customerKycMobileCreditCarVerify(
          {required FormData data}) async =>
      await apiClient.postData(
        AppConstants.postCustomerKycMobileCreditCarVerify,
        "customerKycMobileCreditCarVerify",
        data,
      );

  //

  Future<Response> confirmAndTransaction({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.postConfirmAndTransaction,
        "confirmAndTransaction",
        data,
      );

  

}
