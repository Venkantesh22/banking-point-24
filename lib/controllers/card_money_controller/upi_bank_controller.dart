import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/state_manager.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/bank_info_model.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_upi_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/card_withdrawal_repo/upi_bank_repo.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpiBankController extends GetxController implements GetxService {
  final UpiBankRepo upiBankRepo;
  final SharedPreferences sharedPreferences;

  UpiBankController(
      {required this.upiBankRepo, required this.sharedPreferences});

  bool isLoading = false;

  final TextEditingController upiController =
      TextEditingController(text: 'rahul.kumar@okhdfcbank');

  CreditCardUpiModel? creditCardUpiModel;
  //* Validate Customer UPI id validateCustomerUPI()
  Future<ResponseModel> validateCustomerUPI() async {
    log('----------- validateCustomerUPI Called ----------');

    ResponseModel responseModel;

    isLoading = true;
    update();

    try {
      final apiToken = sharedPreferences.getString(AppConstants.apiToken) ?? '';

      Map<String, dynamic> data = {
        "session_id": apiToken,
        "upi_id": upiController.text.trim()
      };

      Response response =
          await upiBankRepo.validateCustomerUPI(data: FormData(data));

      if (response.statusCode == 200 && response.body['success'] == true) {
        creditCardUpiModel = CreditCardUpiModel.fromJson(response.body['data']);
        responseModel = ResponseModel(
            true, response.body['message'] ?? " validateCustomerUPI success");
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while validateCustomerUPI");
      }
    } catch (e) {
      log('ERROR AT validateCustomerUPI(): $e');
      responseModel =
          ResponseModel(false, "Error while validateCustomerUPI user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  final TextEditingController accountHolderController = TextEditingController(
    text: 'Rahul Kumar',
  );

  final TextEditingController accountNumberController = TextEditingController(
    text: '123456789012',
  );

  final TextEditingController ifscController = TextEditingController(
    text: 'HDFC0001234',
  );

  final TextEditingController bankNameController = TextEditingController(
    text: 'HDFC Bank',
  );

  BankInfoModel? bankInfoModel;
  //* Validate Customer UPI id validateBankAccountInfo()
  Future<ResponseModel> validateBankAccountInfo() async {
    log('----------- validateBankAccountInfo Called ----------');

    ResponseModel responseModel;

    isLoading = true;
    update();

    try {
      final sessionId =
          sharedPreferences.getString(AppConstants.apiToken) ?? '';

      Map<String, dynamic> data = {
        "session_id": sessionId,
        "account_holder_name": accountHolderController.text.trim(),
        "account_number": accountNumberController.text.trim(),
        "ifsc": ifscController.text.trim(),
        "bank_name": bankNameController.text.trim(),
      };

      Response response =
          await upiBankRepo.validateBankAccountInfo(data: FormData(data));

      if (response.statusCode == 200 && response.body['success'] == true) {
        bankInfoModel = BankInfoModel.fromJson(response.body['data']);
        responseModel = ResponseModel(true,
            response.body['message'] ?? " validateBankAccountInfo success");
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while validateBankAccountInfo");
      }
    } catch (e) {
      log('ERROR AT validateBankAccountInfo(): $e');
      responseModel =
          ResponseModel(false, "Error while validateBankAccountInfo user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  @override
  void dispose() {
    upiController.dispose();
    accountHolderController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    bankNameController.dispose();
    super.dispose();
  }
}
