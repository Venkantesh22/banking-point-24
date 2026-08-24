import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/state_manager.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_upi_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/upi_model.dart';
import 'package:lekra/data/repositories/card_withdrawal_repo/upi_repo.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpiController extends GetxController implements GetxService {
  final UpiRepo upiRepo;
  final SharedPreferences sharedPreferences;

  UpiController({required this.upiRepo, required this.sharedPreferences});

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
          await upiRepo.validateCustomerUPI(data: FormData(data));

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



  @override
  void dispose() {
    upiController.dispose();
    super.dispose();
  }
}
