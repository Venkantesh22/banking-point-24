import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class UpiBankRepo {
  final ApiClient apiClient;

  UpiBankRepo({required this.apiClient});

  Future<Response> validateCustomerUPI({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.postValidateCustomerUPI,
        "validateCustomerUPI",
        data,
      );

  Future<Response> validateBankAccountInfo({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.postValidateBankAccountInfo,
        "validateBankAccountInfo",
        data,
      );


}
