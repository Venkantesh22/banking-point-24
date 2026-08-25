import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/aes_helper/aes_helper.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/permission_controller.dart';
import 'package:lekra/data/models/company_model.dart';
import 'package:lekra/data/models/merchant_collection_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/service_model/recharge_badge_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/response/user_model.dart';
import '../data/repositories/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final SharedPreferences? sharedPreferences;

  AuthController({
    required this.authRepo,
    required this.sharedPreferences,
  });

  bool _isLoading = false;
  bool _acceptTerms = true;

  bool get isLoading => _isLoading;

  bool get acceptTerms => _acceptTerms;

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController addressNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();

  Future<ResponseModel> registerUser() async {
    log('----------- registerUser Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      String deviceId = await authRepo.getDeviceId();

      Map<String, dynamic> data = {
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "mobile": phoneNumberController.text.trim(),
        "shop_name": shopNameController.text.trim(),
        "address": addressNameController.text.trim(),
        "city": cityController.text.trim(),
        "pin_code": pincodeController.text.trim(),
        "referral_code": referralCodeController.text.trim(),
        "device_id": deviceId,
      };

      Response response = await authRepo.postUserRegister(
        data: FormData(data),
      );

      log("Raw Response: ${response.body}");

      if (response.statusCode == 200 && response.body['status'] == "success") {
        responseModel =
            ResponseModel(true, response.body['message'] ?? "Profile updated");
        firstNameController.clear();
        lastNameController.clear();

        emailController.clear();
        shopNameController.clear();
        addressNameController.clear();
        cityController.clear();
        pincodeController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        referralCodeController.clear();
      } else {
        String errorMessage = "Validation Error";
        var errors = response.body['errors'] as Map;
        if (errors.isNotEmpty) {
          var firstKey = errors.keys.first;
          errorMessage = errors[firstKey][0].toString();
        }

        responseModel = ResponseModel(
            false, errorMessage ?? "Error while registering user");
      }
    } catch (e) {
      log('ERROR AT registerUser(): $e');
      responseModel = ResponseModel(false, "Error while registering user $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  UserModel? userModel;
  List<RechargeBadgeModel> rechargeBadgeList = [];

  String deviceIdSave = "";

  Future<void> setUserInfor(
    String password,
    String number,
    String latitude,
    String longitude,
  ) async {
    // _isLoading = true;
    // update();
    deviceIdSave = await authRepo.getDeviceId();

    try {
      final saved = await authRepo.saveUserLogin(
        number, // number
        password, // plain password
        deviceIdSave, // device id
        latitude, // lat
        longitude, // lon
      );

      if (!saved) {
        log('Warning: saveUserLogin returned false - prefs not saved');
      } else {
        log('Saved plain login values to prefs (before encryption).');
      }
      // _isLoading = false;
      // update();
      update();
    } catch (e, st) {
      log('Error while saving plain login values: $e\n$st');
      update();
      // _isLoading = false;
      // update();
    }
  }

  Future<void> saveFMCToken(String fcmToken) async {
    final saveFCMToken = await authRepo.saveFCMToken(fcmToken: fcmToken);
    log('loginUser: saved FCM token: $saveFCMToken');
  }
  

  MerchantCollectionModel? merchantCollectionModel;
  CompanyModel? companyModel;
  Future<ResponseModel> loginUser(
      {bool isReload = false, required BuildContext context}) async {
    log('----------- loginUser Called ----------');

    // Ensure SharedPreferences is initialized

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      // device id
      String deviceId = await authRepo.getDeviceId();

      // location
      final permissionController = Get.find<PermissionController>();
      if (permissionController.latitude == null ||
          permissionController.longitude == null) {
        await permissionController.requestLocationPermissionAndFetch(context);
      }

      // --- Build loginRequest using either saved prefs (when isReload) or controllers
      final Map<String, dynamic> loginRequest;
      final fcmTokenSharedPreferences =
          sharedPreferences?.getString(AppConstants.fcmToken) ?? '';
      if (isReload) {
        // read from prefs
        final saveNumber =
            sharedPreferences?.getString(AppConstants.number) ?? '';
        final savedPassword =
            sharedPreferences?.getString(AppConstants.password) ?? '';
        final savedDeviceId =
            sharedPreferences?.getString(AppConstants.deviceId) ?? deviceId;
        final savedLat =
            sharedPreferences?.getString(AppConstants.latitude) ?? '0';
        final savedLon =
            sharedPreferences?.getString(AppConstants.longitude) ?? '0';

        final double lat = double.tryParse(savedLat) ?? 0.0;
        final double lon = double.tryParse(savedLon) ?? 0.0;

        loginRequest = {
          "username": saveNumber,
          "password": savedPassword,
          "device_id": savedDeviceId,
          "latitude": lat,
          "longitude": lon,
          // "fcm_token": fcmTokenSharedPreferences
        };
        log('loginUser: using saved credentials for reload.');
      } else {
        loginRequest = {
          "username": phoneNumberController.text.trim(),
          "password": passwordController.text.trim(),
          "device_id": deviceId,
          "latitude": permissionController.latitude ?? 0.0,
          "longitude": permissionController.longitude ?? 0.0,
          // "fcm_token": fcmTokenSharedPreferences,
        };
        log('loginUser: using entered credentials for login.');
      }

      final String jsonPayload = jsonEncode(loginRequest);
      log('Original JSON Payload: $jsonPayload');

      // Encrypt payload
      final String encryptedPayload = AesEncryptor.encryptToBase64(jsonPayload);
      log('Encrypted Payload for API: ${encryptedPayload.substring(0, encryptedPayload.length.clamp(0, 80))}...');

      // Send as form-data
      final Map<String, dynamic> body = {"data": encryptedPayload};
      final formData = FormData(body);

      print("${AppConstants.baseUrl}${AppConstants.loginUri}");

      Response response = await authRepo.postUserLogin(data: formData);

      if (response.statusCode == 200 && response.body['status'] == "success") {
        // parse response.data (may be Map or encrypted String)
        final dynamic maybeData = response.body['data'];
        Map<String, dynamic>? dataMap;

        if (maybeData == null) {
          log('loginUser: response.body["data"] is null');
        } else if (maybeData is Map) {
          dataMap = Map<String, dynamic>.from(maybeData);
          log('loginUser: response.data is already a Map');
        } else if (maybeData is String) {
          final String encryptedBase64 = maybeData;
          log('loginUser: encrypted data length=${encryptedBase64.length}');
          try {
            // normalize and decrypt
            String normalize(String s) {
              s = s.replaceAll('-', '+').replaceAll('_', '/');
              final mod = s.length % 4;
              if (mod != 0) s = s + '=' * (4 - mod);
              return s;
            }

            final normalized = normalize(encryptedBase64);
            final decryptedJson = AesEncryptor.decryptFromBase64(normalized);
            log('loginUser: decryptedJson: $decryptedJson');
            dataMap = jsonDecode(decryptedJson) as Map<String, dynamic>;
          } catch (err, st) {
            log('loginUser: failed to decrypt/parse data -> $err\n$st');
            responseModel =
                ResponseModel(false, "Failed to decrypt server response.");
            _isLoading = false;
            update();
            return responseModel;
          }
        } else {
          log('loginUser: unexpected type for response.body["data"]: ${maybeData.runtimeType}');
        }

        // Now extract userdetails and badges
        if (dataMap != null) {
          final userdetails = dataMap['userdetails'];
          final companyDetails = dataMap['companydetails'];

          if (userdetails is Map) {
            userModel =
                UserModel.fromJson(Map<String, dynamic>.from(userdetails));
            if (companyDetails is Map<String, dynamic>) {
              companyModel = CompanyModel.fromJson(companyDetails);
            }

            // parse rechargeBadgeList (if present)
            rechargeBadgeList = [];
            if (dataMap['recharge_badge'] is List) {
              final badges = dataMap['recharge_badge'] as List;
              rechargeBadgeList = badges
                  .whereType<Map<String, dynamic>>()
                  .map(RechargeBadgeModel.fromJson)
                  .toList();
              // rechargeBadgeList =
              //     badges.map((re) => RechargeBadgeModel.fromJson(re)).toList();
            }
            update();

            log('rechargeBadgeList length: ${rechargeBadgeList.length}');

            // Save ONLY session token (session_id) after successful login
            final sessionId = userdetails['session_id']?.toString();
            final apiToken = userdetails['api_token']?.toString();
            if (sessionId != null &&
                sessionId.isNotEmpty &&
                apiToken != null &&
                apiToken.isNotEmpty) {
              try {
                final savedToken = await authRepo.saveUserToken(sessionId);
                final saveAPiToken =
                    await authRepo.saveAPIToken(apiToken: apiToken);
                if (savedToken && saveAPiToken) {
                  log('loginUser: saved session token: $sessionId');
                  log('loginUser: saved API token: $apiToken');
                } else {
                  log('loginUser: saveUserToken or saveAPIAndFCMToken returned false');
                }
              } catch (e) {
                log('loginUser: failed to save session token: $e');
              }
            } else {
              log('loginUser: session_id not present in userdetails');
            }

            // Clear controllers only if this was a fresh login (not reload)

            responseModel = ResponseModel(
                true, response.body['message'] ?? "loginUser success");
          } else {
            log('loginUser: userdetails missing or not a Map');
            responseModel =
                ResponseModel(false, "Invalid user details in response");
          }

          if (dataMap['merchantCollection'] is Map) {
            merchantCollectionModel = MerchantCollectionModel.fromJson(
                Map<String, dynamic>.from(dataMap['merchantCollection']));
            filterSuggest();
          } else {
            log('merchantCollection is not add');

            responseModel =
                ResponseModel(false, "Empty data merchantCollectionModel ");
          }
        } else {
          responseModel = ResponseModel(false, "Empty data from server");
        }
      } else {
        responseModel = ResponseModel(
            false,
            response.body?['message'] ??
                response.statusText ??
                "Unable to connect to server");
      }
    } catch (e, st) {
      log('ERROR AT loginUser(): $e\n$st');
      responseModel = ResponseModel(false, "Error while loginUser user $e");
    }

    // debug print saved prefs relevant fields
    log('pref token=${(sharedPreferences?.getString(AppConstants.token))} '
        'API_token=${(sharedPreferences?.getString(AppConstants.apiToken))} '
        'FCM_token=${(sharedPreferences?.getString(AppConstants.fcmToken))} '
        'number=${sharedPreferences?.getString(AppConstants.number)} '
        'password=${sharedPreferences?.getString(AppConstants.password)} '
        'deviceId=${sharedPreferences?.getString(AppConstants.deviceId)} '
        'lat=${sharedPreferences?.getString(AppConstants.latitude)} '
        'total Collection=${merchantCollectionModel?.totalCollection} '
        'lon=${sharedPreferences?.getString(AppConstants.longitude)}');

    _isLoading = false;
    update();
    return responseModel;
  }

  List<ServiceModel> suggestedForYouList = [];

  void filterSuggest() {
    List<RechargeBadgeModel> selectedBadges = rechargeBadgeList.length >= 4
        ? rechargeBadgeList.sublist(1, 4)
        : rechargeBadgeList;

    suggestedForYouList = selectedBadges.expand((badge) {
      if (badge.data == null) return <ServiceModel>[];
      return badge.data!.take(4).whereType<ServiceModel>().toList();
    }).toList();
  }

  Future<ResponseModel> postChangePassword() async {
    log('----------- postChangePassword Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "api_token": sharedPreferences?.getString(AppConstants.apiToken),
        "old_password": oldPasswordController.text.trim(),
        "new_password": passwordController.text.trim(),
        "confirm_password": confirmPasswordController.text.trim(),
      };

      Response response = await authRepo.postChangePassword(
        data: FormData(data),
      );

      log("Raw Response: ${response.body}");

      if (response.statusCode == 200 && response.body['status'] == "success") {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "postChangePassword updated");

        oldPasswordController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while postChangePassword ");
      }
    } catch (e) {
      log('ERROR AT postChangePassword(): $e');
      responseModel =
          ResponseModel(false, "Error while postChangePassword  $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  TextEditingController officeAddressController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController memberTypeController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  Future<ResponseModel> postUpdateProfile() async {
    log('----------- postUpdateProfile Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "api_token": sharedPreferences?.getString(AppConstants.apiToken),
        "address": addressController.text.trim(),
        "city": cityController.text.trim(),
        'state_id': Get.find<BasicController>().selectStateModel?.stateId ?? "",
        'district_id':
            Get.find<BasicController>().selectDistrictModel?.districtId ?? "",
        "pin_code": pincodeController.text.trim(),
        "shop_name": shopNameController.text.trim(),
        "office_address": officeAddressController.text.trim(),
      };

      Response response = await authRepo.postUpdateProfile(
        data: FormData(data),
      );

      if (response.statusCode == 200 && response.body['status'] == "success") {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "postUpdateProfile updated");

        addressController.clear();
        cityController.clear();
        pincodeController.clear();
        shopNameController.clear();
        officeAddressController.clear();
        Get.find<BasicController>().setSelectStateModel(reSet: true);
        Get.find<BasicController>().setDistrictModel(reSet: true);
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while postUpdateProfile ");
      }
    } catch (e) {
      log('ERROR AT postUpdateProfile(): $e');
      responseModel = ResponseModel(false, "Error while postUpdateProfile  $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  File? profileImage;
  updateImages(File? image) {
    profileImage = image;
    update();
  }

  Future<ResponseModel> postUpdateProfilePhoto() async {
    log('----------- postUpdateProfilePhoto Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "api_token": sharedPreferences?.getString(AppConstants.apiToken),
        "profile_photo": sharedPreferences?.getString(AppConstants.apiToken),
      };
      if (profileImage != null) {
        data.addAll({
          "image":
              MultipartFile(profileImage, filename: profileImage?.path ?? "")
        });
      }

      Response response = await authRepo.postUpdateProfilePhoto(
        data: FormData(data),
      );

      if (response.statusCode == 200 && response.body['status'] == "success") {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "postUpdateProfilePhoto updated");

        addressController.clear();
        cityController.clear();
        pincodeController.clear();
        shopNameController.clear();
        officeAddressController.clear();
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while postUpdateProfilePhoto ");
      }
    } catch (e) {
      log('ERROR AT postUpdateProfilePhoto(): $e');
      responseModel =
          ResponseModel(false, "Error while postUpdateProfilePhoto  $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> logout(BuildContext context) async {
    log('----------- logout Called ----------');

    update();
    try {
      authRepo.clearSharedData();
      navigate(context: context, page: const LoginScreen());
    } catch (e) {
      log("****** Error in logout() ******", name: "logout");
    }

    _isLoading = false;
    update();
  }

  ServiceModel? selectServiceModel;

  void setServiceModel({required ServiceModel? serviceModel}) {
    selectServiceModel = serviceModel;
    log("selectServiceModel = ${selectServiceModel?.serviceName ?? ""}");
    update();
  }

  Future<ResponseModel> getOTP() async {
    log('----------- getOTP Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "mobile": phoneNumberController.text.trim(),
      };

      Response response = await authRepo.getOTP(
        data: FormData(data),
      );

      if (response.statusCode == 200 && response.body['status'] == "success") {
        responseModel =
            ResponseModel(true, response.body['message'] ?? "getOTP fetch");
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Error while getOTP ");
      }
    } catch (e) {
      log('ERROR AT getOTP(): $e');
      responseModel = ResponseModel(false, "Error while getOTP  $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyOTP({required String opt}) async {
    log('----------- verifyOTP Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      log("opt ${opt}");

      Map<String, dynamic> data = {
        "mobile": phoneNumberController.text.trim(),
        "otp": opt,
      };

      Response response = await authRepo.verifyOTP(
        data: FormData(data),
      );

      if (response.statusCode == 200 && response.body['status'] == "success") {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "verifyOTP success");
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Error while verifyOTP ");
      }
    } catch (e) {
      log('ERROR AT verifyOTP(): $e');
      responseModel = ResponseModel(false, "Error while verifyOTP  $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> checkBalance() async {
    log('----------- CheckBalance Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "api_token": sharedPreferences?.getString(AppConstants.apiToken),
      };

      Response response = await authRepo.postCheckBalance(
        data: FormData(data),
      );

      if (response.statusCode == 200 && response.body['status'] == "success") {
        final dynamic maybeData = response.body['data'];
        Map<String, dynamic>? dataMap;

        if (maybeData == null) {
          log('checkBalance: response.body["data"] is null');
        } else if (maybeData is Map) {
          dataMap = Map<String, dynamic>.from(maybeData);
          log('checkBalance: response.data is already a Map');
        } else if (maybeData is String) {
          final String encryptedBase64 = maybeData;
          log('checkBalance: encrypted data length=${encryptedBase64.length}');
          try {
            // normalize and decrypt
            String normalize(String s) {
              s = s.replaceAll('-', '+').replaceAll('_', '/');
              final mod = s.length % 4;
              if (mod != 0) s = s + '=' * (4 - mod);
              return s;
            }

            final normalized = normalize(encryptedBase64);
            final decryptedJson = AesEncryptor.decryptFromBase64(normalized);
            log('checkBalance: decryptedJson: $decryptedJson');
            dataMap = jsonDecode(decryptedJson) as Map<String, dynamic>;
          } catch (err, st) {
            log('checkBalance: failed to decrypt/parse data -> $err\n$st');
            responseModel =
                ResponseModel(false, "Failed to decrypt server response.");
            _isLoading = false;
            update();
            return responseModel;
          }
        } else {
          log('loginUser: unexpected type for response.body["data"]: ${maybeData.runtimeType}');
        }

        // Now extract userdetails and badges
        if (dataMap != null) {
          final userdetails = dataMap['userdetails'];
          final companyDetails = dataMap['companydetails'];

          if (userdetails is Map) {
            userModel =
                UserModel.fromJson(Map<String, dynamic>.from(userdetails));
            companyModel = CompanyModel.fromJson(
                Map<String, dynamic>.from(companyDetails));
            // parse rechargeBadgeList (if present)
            rechargeBadgeList = [];
            if (dataMap['recharge_badge'] is List) {
              final badges = dataMap['recharge_badge'] as List;
              rechargeBadgeList =
                  badges.map((re) => RechargeBadgeModel.fromJson(re)).toList();
            }
            update();

            log('rechargeBadgeList length: ${rechargeBadgeList.length}');

            responseModel = ResponseModel(
                true, response.body['message'] ?? "loginUser success");
          } else {
            log('loginUser: userdetails missing or not a Map');
            responseModel =
                ResponseModel(false, "Invalid user details in response");
          }

          if (dataMap['merchantCollection'] is Map) {
            merchantCollectionModel = MerchantCollectionModel.fromJson(
                Map<String, dynamic>.from(dataMap['merchantCollection']));
            filterSuggest();
          } else {
            log('merchantCollection is not add');

            responseModel =
                ResponseModel(false, "Empty data merchantCollectionModel ");
          }
        } else {
          responseModel = ResponseModel(false, "Empty data from server");
        }
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Error while CheckBalance ");
      }
    } catch (e) {
      log('ERROR AT CheckBalance(): $e');
      responseModel = ResponseModel(false, "Error while CheckBalance  $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  String getAPIToken() {
    return authRepo.getApiToken();
  }
}
