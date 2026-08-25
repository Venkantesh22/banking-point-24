import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/cash_card_withdrawal_kyc_status_model.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/check_custom_kyc_model.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_transaction_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/card_withdrawal_repo/custom_kyc_repo.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum KycStatus {
  pending,
  verified,
  rejected,
}

class CustomKycController extends GetxController implements GetxService {
  final CustomKycRepo customKycRepo;
  final SharedPreferences sharedPreferences;

  CustomKycController({
    required this.customKycRepo,
    required this.sharedPreferences,
  });

  bool isLoading = false;

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController mobileNumberController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController panController = TextEditingController();

  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  // ============================================================
  // IMAGE PICKER
  // ============================================================

  final ImagePicker imagePicker = ImagePicker();

  // ============================================================
  // STATE
  // ============================================================

  bool isMobileVerified = false;
  bool isOtpVerified = false;
  bool isSubmitting = false;

  // ============================================================
  // OTP
  // ============================================================

  String otp = '';

  void updateOtp() {
    otp = otpControllers.map((controller) => controller.text).join();

    update();
  }

  void verifyOtp() {
    if (otp.length == 6) {
      isOtpVerified = true;
      update();
    }
  }

  // ============================================================
  // MOBILE
  // ============================================================

  void setMobileVerified(bool value) {
    isMobileVerified = value;
    update();
  }

  // ============================================================
  // FILES
  // ============================================================

  File? panCardImage;
  File? aadhaarFrontImage;
  File? aadhaarBackImage;
  File? livePhoto;

  // ============================================================
  // IMAGE SOURCE
  // ============================================================

  Future<ImageSource?> _selectImageSource(
    BuildContext context,
  ) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Image Source',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                  ),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(
                      context,
                      ImageSource.camera,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                  ),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(
                      context,
                      ImageSource.gallery,
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<File?> _pickImage(
    BuildContext context, {
    required ImageSource source,
  }) async {
    final XFile? image = await imagePicker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image == null) {
      return null;
    }

    return File(image.path);
  }

  // ============================================================
  // PAN CARD
  // ============================================================

  Future<void> pickPanCardImage(
    BuildContext context,
  ) async {
    final ImageSource? source = await _selectImageSource(context);

    if (source == null) {
      return;
    }

    final File? image = await _pickImage(
      context,
      source: source,
    );

    if (image == null) {
      return;
    }

    panCardImage = image;
    update();
  }

  void removePanCardImage() {
    panCardImage = null;
    update();
  }

  // ============================================================
  // AADHAAR FRONT
  // ============================================================

  Future<void> pickAadhaarFrontImage(
    BuildContext context,
  ) async {
    final ImageSource? source = await _selectImageSource(context);

    if (source == null) {
      return;
    }

    final File? image = await _pickImage(
      context,
      source: source,
    );

    if (image == null) {
      return;
    }

    aadhaarFrontImage = image;
    update();
  }

  void removeAadhaarFrontImage() {
    aadhaarFrontImage = null;
    update();
  }

  // ============================================================
  // AADHAAR BACK
  // ============================================================

  Future<void> pickAadhaarBackImage(
    BuildContext context,
  ) async {
    final ImageSource? source = await _selectImageSource(context);

    if (source == null) {
      return;
    }

    final File? image = await _pickImage(
      context,
      source: source,
    );

    if (image == null) {
      return;
    }

    aadhaarBackImage = image;
    update();
  }

  void removeAadhaarBackImage() {
    aadhaarBackImage = null;
    update();
  }

  // ============================================================
  // LIVE PHOTO
  // ============================================================

  Future<void> captureLivePhoto(
    BuildContext context,
  ) async {
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.front,
    );

    if (image == null) {
      return;
    }

    livePhoto = File(image.path);
    update();
  }

  void removeLivePhoto() {
    livePhoto = null;
    update();
  }

  CheckCustomKyc? checkCustomKyc;
  //* Call Submit custom Kyc Api checkCustomerKYC()
  Future<ResponseModel> checkCustomerKYC() async {
    log('----------- checkCustomerKYC Called ----------');

    ResponseModel responseModel;

    isLoading = true;
    update();

    try {
      final apiToken = sharedPreferences.getString(AppConstants.apiToken) ?? '';

      Map<String, dynamic> data = {
        "session_id": apiToken,
        "mobile_number": mobileNumberController.text.trim(),
      };
      Response response =
          await customKycRepo.checkCustomerKYC(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        checkCustomKyc = CheckCustomKyc.fromJson(response.body);
        responseModel = ResponseModel(
            true, response.body['message'] ?? " checkCustomerKYC success");
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Error while checkCustomerKYC");
      }
    } catch (e) {
      log('ERROR AT checkCustomerKYC(): $e');
      responseModel =
          ResponseModel(false, "Error while checkCustomerKYC user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  KycStatus getKycStatus(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'verified':
        return KycStatus.verified;

      case 'rejected':
        return KycStatus.rejected;

      case 'pending':
      default:
        return KycStatus.pending;
    }
  }

  CardCashWithdrawalCustomKycStatusModel?
      cardCashWithdrawalCustomKycStatusModel;
  //* Call Submit custom Kyc Api cardWithdrawalCustomerKYC()
  Future<ResponseModel> cardWithdrawalCustomerKYC() async {
    log('----------- cardWithdrawalCustomerKYC Called ----------');

    isLoading = true;
    update();

    try {
      final apiToken = sharedPreferences.getString(AppConstants.apiToken) ?? '';

      if (panCardImage == null) {
        return ResponseModel(false, 'Please upload PAN image');
      }

      if (aadhaarFrontImage == null) {
        return ResponseModel(false, 'Please upload Aadhaar front image');
      }

      if (aadhaarBackImage == null) {
        return ResponseModel(false, 'Please upload Aadhaar back image');
      }

      if (livePhoto == null) {
        return ResponseModel(false, 'Please capture live photo');
      }

      final FormData formData = FormData({
        "session_id": apiToken,
        "full_name": fullNameController.text.trim(),
        "mobile_number": mobileNumberController.text.trim(),
        "email": emailController.text.trim(),
        "pan": panController.text.trim(),
        "pan_image": MultipartFile(
          panCardImage!.path,
          filename: _getFileName(panCardImage!),
        ),
        "aadhaar_front_image": MultipartFile(
          aadhaarFrontImage!.path,
          filename: _getFileName(aadhaarFrontImage!),
        ),
        "aadhaar_back_image": MultipartFile(
          aadhaarBackImage!.path,
          filename: _getFileName(aadhaarBackImage!),
        ),
        "live_photo": MultipartFile(
          livePhoto!.path,
          filename: _getFileName(livePhoto!),
        ),
      });

      // Debug
      log('========== CUSTOMER KYC REQUEST ==========');

      for (final field in formData.fields) {
        log('FIELD: ${field.key} = ${field.value}');
      }

      for (final file in formData.files) {
        log(
          'FILE: ${file.key} = ${file.value.filename}',
        );
      }

      log('==========================================');

      final Response response = await customKycRepo.cardWithdrawalCustomerKYC(
        data: formData,
      );

      log('STATUS CODE: ${response.statusCode}');
      log('RESPONSE BODY: ${response.body}');

      final body = response.body;

      if (response.statusCode == 200 &&
          body is Map &&
          body['status']?.toString().toLowerCase() == 'success') {
        cardCashWithdrawalCustomKycStatusModel =
            CardCashWithdrawalCustomKycStatusModel.fromJson(response.body);

        status = getKycStatus(
          cardCashWithdrawalCustomKycStatusModel?.kycStatus,
        );

        return ResponseModel(
          true,
          body['message']?.toString() ?? 'cardWithdrawalCustomerKYC success',
        );
      }

      return ResponseModel(
        false,
        body is Map
            ? body['message']?.toString() ??
                'Error while cardWithdrawalCustomerKYC'
            : response.statusText ?? 'Error while cardWithdrawalCustomerKYC',
      );
    } catch (e, stackTrace) {
      log(
        'ERROR AT cardWithdrawalCustomerKYC(): $e',
        stackTrace: stackTrace,
      );

      return ResponseModel(
        false,
        'Error while cardWithdrawalCustomerKYC: $e',
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  String _getFileName(File file) {
    return file.path.split(Platform.pathSeparator).last;
  }

  Future<ResponseModel> customerKycMobileCreditCardOTP() async {
    log('----------- customerKycMobileCreditCardOTP Called ----------');

    ResponseModel responseModel;

    isLoading = true;
    update();

    try {
      final apiToken = sharedPreferences.getString(AppConstants.apiToken) ?? '';

      Map<String, dynamic> data = {
        "session_id": apiToken,
        "mobile_number": mobileNumberController.text.trim(),
      };
      Response response = await customKycRepo.customerKycMobileCreditCardOTP(
          data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        checkCustomKyc = CheckCustomKyc.fromJson(
          response.body,
        );

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "OTP sent successfully",
        );
      } else {
        responseModel = ResponseModel(
            false,
            response.body['message'] ??
                "Error while customerKycMobileCreditCardOTP");
      }
    } catch (e) {
      log('ERROR AT customerKycMobileCreditCardOTP(): $e');
      responseModel = ResponseModel(
          false, "Error while customerKycMobileCreditCardOTP user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> customerKycMobileCreditCarVerify() async {
    log('----------- customerKycMobileCreditCarVerify Called ----------');

    if (otp.length != 6) {
      return ResponseModel(
        false,
        'Please enter a valid 6 digit OTP',
      );
    }

    isLoading = true;
    update();

    try {
      final apiToken = sharedPreferences.getString(AppConstants.apiToken) ?? '';

      final Map<String, dynamic> data = {
        "session_id": apiToken,
        "mobile_number": mobileNumberController.text.trim(),
        "otp": otp,
      };

      final Response response =
          await customKycRepo.customerKycMobileCreditCarVerify(
        data: FormData(data),
      );

      log('STATUS CODE: ${response.statusCode}');
      log('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200 && response.body['status'] == 'success') {
        isOtpVerified = true;
        isMobileVerified = true;

        _otpTimer?.cancel();
        _otpTimer = null;

        update();

        return ResponseModel(
          true,
          response.body['message']?.toString() ??
              'Mobile number verified successfully',
        );
      }

      return ResponseModel(
        false,
        response.body['message']?.toString() ??
            'OTP customerKycMobileCreditCarVerify failed',
      );
    } catch (e, stackTrace) {
      log(
        'ERROR AT verifyCustomerKycOtp(): $e',
        stackTrace: stackTrace,
      );

      return ResponseModel(
        false,
        'Error while verifying OTP: $e',
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  //* Call confirm and Transaction credit card confirmAndTransaction()
  Future<ResponseModel> confirmAndTransaction({
    required String? number,
  }) async {
    log('----------- confirmAndTransaction Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "idempotency_key": "",
      };
      Response response =
          await customKycRepo.confirmAndTransaction(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        responseModel = ResponseModel(
            true, response.body['message'] ?? " confirmAndTransaction success");
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while confirmAndTransaction");
      }
    } catch (e) {
      log('ERROR AT confirmAndTransaction(): $e');
      responseModel =
          ResponseModel(false, "Error while confirmAndTransaction user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  String? transactionId;

  void selectTransaction({required String transactionId}) {
    this.transactionId = transactionId;
    update();
  }

  //* check a Credit card withdrawal transaction status creditCardCashWithdrawalTransactionStatus()
  Future<ResponseModel> creditCardCashWithdrawalTransactionStatus(
      {required String? transactionId}) async {
    log('----------- creditCardCashWithdrawalTransactionStatus Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response =
          await customKycRepo.creditCardCashWithdrawalTransactionStatus(
              transactionId: transactionId ?? "");

      if (response.statusCode == 200 && response.body['status'] == "success") {
        responseModel = ResponseModel(
            true,
            response.body['message'] ??
                " creditCardCashWithdrawalTransactionStatus success");
      } else {
        responseModel = ResponseModel(
            false,
            response.body?['message'] ??
                response.statusText ??
                "Error while creditCardCashWithdrawalTransactionStatus");
      }
    } catch (e) {
      log('ERROR AT creditCardCashWithdrawalTransactionStatus(): $e');
      responseModel = ResponseModel(false,
          "Error while creditCardCashWithdrawalTransactionStatus user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  // ============================================================
// OTP TIMER
// ============================================================

  Timer? _otpTimer;

  int otpSecondsRemaining = 30;

  bool otpSent = false;

  bool get canResendOtp {
    return otpSent && otpSecondsRemaining <= 0;
  }

  String get otpTimerText {
    final seconds = otpSecondsRemaining.toString().padLeft(2, '0');

    return '00:$seconds';
  }

  void startOtpTimer() {
    _otpTimer?.cancel();

    otpSent = true;
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

  // ============================================================
  // CLEAR
  // ============================================================

  void clearForm() {
    fullNameController.clear();
    mobileNumberController.clear();
    emailController.clear();

    for (final controller in otpControllers) {
      controller.clear();
    }

    otp = '';

    isMobileVerified = false;
    isOtpVerified = false;
    isSubmitting = false;

    panCardImage = null;
    aadhaarFrontImage = null;
    aadhaarBackImage = null;
    livePhoto = null;

    for (final controller in otpControllers) {
      controller.dispose();
    }

    _otpTimer?.cancel();

    update();
  }

  void clearOtpOnly() {
    for (final controller in otpControllers) {
      controller.clear();
    }

    otp = '';
    isOtpVerified = false;

    update();
  }
  // ============================================================
  // STATE
  // ============================================================

  KycStatus status = KycStatus.pending;

  // ============================================================
  // STATUS
  // ============================================================

  void setStatus(KycStatus value) {
    status = value;
    update();
  }

  // ============================================================
  // RETRY
  // ============================================================

  void retryKyc() {
    isLoading = true;
    update();

    debugPrint('Retry KYC');

    // API will be added later.

    isLoading = false;
    update();
  }

  // ============================================================
  // RESET
  // ============================================================

  void resetStatus() {
    status = KycStatus.pending;
    isLoading = false;
    update();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    fullNameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();

    for (final controller in otpControllers) {
      controller.dispose();
    }

    super.onClose();
  }

  void resetAllKycForm() {
    // ============================================================
    // STOP OTP TIMER
    // ============================================================

    _otpTimer?.cancel();
    _otpTimer = null;

    // ============================================================
    // TEXT FIELDS
    // ============================================================

    fullNameController.clear();
    // mobileNumberController.clear();
    emailController.clear();
    panController.clear();

    // ============================================================
    // OTP
    // ============================================================

    for (final controller in otpControllers) {
      controller.clear();
    }

    otp = '';

    // ============================================================
    // OTP STATE
    // ============================================================

    isMobileVerified = false;
    isOtpVerified = false;

    // ============================================================
    // OTP TIMER STATE
    // ============================================================

    otpSent = false;
    otpSecondsRemaining = 30;

    // ============================================================
    // SUBMIT STATE
    // ============================================================

    isSubmitting = false;
    isLoading = false;

    // ============================================================
    // KYC IMAGES
    // ============================================================

    panCardImage = null;
    aadhaarFrontImage = null;
    aadhaarBackImage = null;
    livePhoto = null;

    // ============================================================
    // API / RESPONSE STATE
    // ============================================================

    checkCustomKyc = null;
    cardCashWithdrawalCustomKycStatusModel = null;

    // ============================================================
    // KYC STATUS
    // ============================================================

    status = KycStatus.pending;

    update();
  }
}
