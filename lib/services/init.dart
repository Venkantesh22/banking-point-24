import 'dart:developer';
import 'package:get/instance_manager.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/controllers/card_money_controller/custom_kyc_controller.dart';
import 'package:lekra/controllers/card_money_controller/upi_bank_controller.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/controllers/dispute_controller.dart';
import 'package:lekra/controllers/kyc_controller/bank_details_controller.dart';
import 'package:lekra/controllers/kyc_controller/bank_document_upload_controller.dart';
import 'package:lekra/controllers/kyc_controller/business_information_controller.dart';
import 'package:lekra/controllers/kyc_controller/document_details_controller.dart';
import 'package:lekra/controllers/kyc_controller/form_controller.dart';
import 'package:lekra/controllers/kyc_controller.dart';
import 'package:lekra/controllers/kyc_controller/kyc_document_upload_controller.dart';
import 'package:lekra/controllers/kyc_controller/kyc_review_controller.dart';
import 'package:lekra/controllers/kyc_controller/live_shop_verification_controller.dart';
import 'package:lekra/controllers/kyc_controller/registration_kyc_form_controller.dart';
import 'package:lekra/controllers/kyc_controller/self_live_verification_controller.dart';
import 'package:lekra/controllers/mobile_service_controller.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/controllers/report_contoller.dart';
import 'package:lekra/controllers/voice_service_controller.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/data/repositories/card_repo.dart';
import 'package:lekra/data/repositories/card_withdrawal_repo/credit_card_repo.dart';
import 'package:lekra/data/repositories/card_withdrawal_repo/custom_kyc_repo.dart';
import 'package:lekra/data/repositories/card_withdrawal_repo/upi_bank_repo.dart';
import 'package:lekra/data/repositories/card_withdrawal_repo/vender_kyc_repo.dart';
import 'package:lekra/data/repositories/dispute_repo.dart';
import 'package:lekra/data/repositories/kyc_repo.dart';
import 'package:lekra/data/repositories/mobile_service_repo.dart';
import 'package:lekra/data/repositories/product_repo.dart';
import 'package:lekra/data/repositories/recharge_repo.dart';
import 'package:lekra/data/repositories/report_repo.dart';
import 'package:lekra/data/repositories/wallet_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth_controller.dart';
import '../controllers/permission_controller.dart';
import '../data/api/api_client.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/basic_repo.dart';
import 'constants.dart';

class Init {
  initialize() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut<SharedPreferences>(() => sharedPreferences);

    try {
      // ApiClient
      Get.lazyPut(() => ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: sharedPreferences));
      Get.lazyPut(
          () => ApiClient(
                appBaseUrl:
                    AppConstants.baseUrlForPrepaidCard, // 👈 prepaid client
                sharedPreferences: sharedPreferences,
              ),
          tag: "prepaid");

      Get.lazyPut(() => PermissionController());

      // Get Repo's...
      Get.lazyPut(
          () => AuthRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
      // Get Repo's...
      Get.lazyPut(() =>
          ReportRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
      Get.lazyPut(() =>
          BasicRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
      Get.lazyPut(() => WalletRepo(apiClient: Get.find()));
      Get.lazyPut(() =>
          ProductRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
      Get.lazyPut(() =>
          RechargeRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
      Get.lazyPut(() => DisputeRepo(apiClient: Get.find()));
      Get.lazyPut(() => KycRepo(apiClient: Get.find()));
      Get.lazyPut(() => MobileServiceRepo(apiClient: Get.find()));
      Get.lazyPut(() => CardRepo(
            apiClient: Get.find(),
            prepaidClient: Get.find<ApiClient>(tag: "prepaid"),
          ));

      //* Custom KYC controller
      Get.lazyPut(() => CustomKycRepo(apiClient: Get.find()));
      Get.lazyPut(() => CreditCardRepo(apiClient: Get.find()));
      Get.lazyPut(() => UpiBankRepo(apiClient: Get.find()));

      //* Vender kYC
      Get.lazyPut(
        () => VenderKycRepo(
          apiClient: Get.find(),
          sharedPreferences: Get.find(),
        ),
      );

      //! Get Controller's...
      Get.lazyPut(() => DashBoardController());
      Get.lazyPut(() => AuthController(
          authRepo: Get.find(), sharedPreferences: sharedPreferences));
      Get.lazyPut(() => BasicController(
          sharedPreferences: sharedPreferences, basicRepo: Get.find()));
      Get.lazyPut(() => ReportController(reportRepo: Get.find()));
      Get.lazyPut(() => WalletController(walletRepo: Get.find()));
      Get.lazyPut(() => FormController(venderKycRepo: Get.find()));
      Get.lazyPut(() => RechargeController(
          rechargeRepo: Get.find(), sharedPreferences: sharedPreferences));
      Get.lazyPut(() => ProductController(
          productRepo: Get.find(), sharedPreferences: sharedPreferences));
      Get.lazyPut(() => DisputeController(
          disputeRepo: Get.find(), sharedPreferences: sharedPreferences));
      Get.lazyPut(() => MobileServiceController(
          mobileServiceRepo: Get.find(), sharedPreferences: sharedPreferences));
      Get.lazyPut(() => KycController(
          kycRepo: Get.find(), sharedPreferences: sharedPreferences));
      Get.lazyPut(() => CardController(
          cardRepo: Get.find(),
          authRepo: Get.find(),
          sharedPreferences: sharedPreferences));
      Get.lazyPut(() => VoiceServiceController());

      //*KYC controller list
      Get.lazyPut(
          () => RegistrationKycFromController(venderKycRepo: Get.find()));
      Get.lazyPut(() => KycDocumentUploadController(venderKycRepo: Get.find()));
      Get.lazyPut(() => DocumentDetailsController(venderKycRepo: Get.find()));
      Get.lazyPut(
          () => BusinessInformationController(venderKycRepo: Get.find()));
      Get.lazyPut(
          () => LiveShopVerificationController(venderKycRepo: Get.find()));
      Get.lazyPut(() => SelfLiveVerificationController());
      Get.lazyPut(() => BankDetailsController(venderKycRepo: Get.find()));
      Get.lazyPut(() => BankDocumentUploadController());
      Get.lazyPut(() => KycReviewController(venderKycRepo: Get.find()));
      Get.lazyPut(() => UpiBankController(
          upiBankRepo: Get.find(), sharedPreferences: Get.find()));

      //* Custom KYC controller

      Get.lazyPut(() => CustomKycController(
            customKycRepo: Get.find(),
            sharedPreferences: Get.find(),
          ));

      //* cried card controller

      Get.lazyPut(() => CreditCardController(
            creditCardRepo: Get.find(),
            sharedPreferences: Get.find(),
          ));
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT initialize()");
    }
  }
}
