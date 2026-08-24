// ignore_for_file: strict_top_level_inference, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lekra/main.dart';
import 'package:lekra/services/route_helper.dart';
import 'package:lekra/services/theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toastification/toastification.dart';

class PriceConverter {
  static convert(price) {
    num _cleanPrice = price.replaceAll(',', '');

    return '₹ ${double.parse('$_cleanPrice').toStringAsFixed(2)}';
  }

  static convertRound(price) {
    num _cleanPrice = price.replaceAll(',', '');
    return '₹ ${double.parse('$_cleanPrice').toInt()}';
  }

  static convertToNumberFormat(num price) {
    final format = NumberFormat("#,##,##,##0.00", "en_IN");
    return '₹ ${format.format(price)}';
  }
}

Widget sizedBoxHeight({required double height}) {
  return SizedBox(
    height: height.h,
  );
}

Widget sizedBoxWidth({required double width}) {
  return SizedBox(
    width: width.w,
  );
}

class Helper {
  final BuildContext context;
  Helper(this.context);

  Size get size => MediaQuery.sizeOf(context);
  TextTheme get textTheme => Theme.of(context).textTheme;
}

String capitalize(String? s) {
  if (s == null || s.isEmpty) return "";
  return s[0].toUpperCase() + s.substring(1);
}

void navigate({
  PageTransitionType type = PageTransitionType.fade,
  required BuildContext context,
  required Widget page,
  bool isReplace = false,
  bool isRemoveUntil = false,
  Duration duration = const Duration(milliseconds: 300),
}) {
  if (isReplace) {
    Navigator.of(context).pushReplacement(
      getCustomRoute(
        child: page,
        type: type,
        duration: duration,
      ),
    );
  } else if (isRemoveUntil) {
    Navigator.of(context).pushAndRemoveUntil(
      getCustomRoute(
        child: page,
        type: type,
        duration: duration,
      ),
      (route) => false,
    );
  } else {
    Navigator.of(context).push(
      getCustomRoute(
        child: page,
        type: type,
        duration: duration,
      ),
    );
  }
}

void pop(BuildContext context, {dynamic data}) {
  Navigator.pop(context, data);
}

enum ToastType {
  info(ToastificationType.info),
  warning(ToastificationType.warning),
  error(ToastificationType.error),
  success(ToastificationType.success);

  const ToastType(this.value);
  final ToastificationType value;
}

void showToast(
    {ToastType? toastType,
    required String message,
    String? description,
    ToastificationStyle? toastificationStyle,
    bool? typeCheck}) {
  toastification.show(
    alignment: Alignment.topLeft,
    type: toastType?.value ??
        ((typeCheck ?? false)
            ? ToastificationType.success
            : ToastificationType.error),
    title: Text(
      message,
      style:
          Helper(navigatorKey.currentContext!).textTheme.bodyMedium!.copyWith(
                color: black,
                fontSize: 14,
              ),
    ),
    description: description != null
        ? Text(description,
            style: Helper(navigatorKey.currentContext!)
                .textTheme
                .bodySmall!
                .copyWith(
                  fontSize: 13,
                  color: black,
                ))
        : null,
    style: toastificationStyle ?? ToastificationStyle.minimal,
    icon: toastType == ToastType.success
        ? const Icon(Icons.check_circle_outline)
        : toastType == ToastType.error
            ? const Icon(Icons.error_outline)
            : toastType == ToastType.warning
                ? const Icon(Icons.warning_amber)
                : const Icon(Icons.info_outline),
    autoCloseDuration: const Duration(seconds: 2),
  );
}

String getStringFromList(List<dynamic>? data) {
  String str = data.toString();
  return data.toString().substring(1, str.length - 1);
}

class AppConstants {
  String get getBaseUrl => baseUrl;
  set setBaseUrl(String url) => baseUrl = url;

  //TODO: Change Base Url
  static String baseUrl = 'https://app.bankingpoint-24.com/';
  static String baseUrlForPrepaidCard = 'https://partner.tpipay.net/';
  //TODO: Change Base Url
  static String appName = 'Banking point 24';

  // Auth
  static const String loginUri = 'api/application/v1/login';
  static const String postUserRegister = 'api/application/v1/sign-up';
  static const String profileUri = 'api/v1/user/profile';
  static const String postChangePassword = 'api/application/v1/change-password';
  static const String postGetOPT = 'api/application/v1/forgot-password-otp';
  static const String postVerifyOTP =
      'api/application/v1/confirm-forgot-password';

  // Profile
  static const String postUpdateProfile = 'api/application/v1/update-profile';
  static const String postUpdateProfilePhoto =
      'api/application/v1/update-profile-photo';

  static const String postCheckBalance = 'api/application/v1/check-balance';

// Basic
  static const String postStatus = 'api/collect-payment/v1/state-list';
  static const String postDistrictByState =
      'api/collect-payment/v1/getDistricByState';

  static const String postCreateVPA = 'api/collect-payment/v1/create-vpa';

  //Report
  static const String yesBankMerchantCollectionGet =
      'api/reports/v1/welcome/yes-bank-merchant-collection';
  static const String getTransactionReport =
      'api/reports/v1/all-transaction-report';

  // QR
  static const String postGenerateQR = 'api/collect-payment/v1/fetch-qr';

  // Mobile Recharge
  static const String postPrepaidPlan = 'api/plans/v1/prepaid-plan';
  static const String postFetchProvider = 'api/plans/v1/fetch-provider';
  static const String postFetchPrepaidROffer = 'api/plans/v1/prepaid-roffer';

  //DHT recharge
  static const String postDTHCustomerInfo = 'api/plans/v1/dth-customer-info';
  static const String postDTHPlan = 'api/plans/v1/dth-plan';

  // Product
  static const String getProductList = 'api/ecommerce/v1/products-list';
  static const String postProductDetails =
      'api/ecommerce/v1/view-product-details';
  static const String postBuyProduct = 'api/ecommerce/v1/view-product-details';
  static const String fetchOrder = 'api/ecommerce/v1/order-report';

  //UPI
  static const String postRechargeViaUpi =
      'api/telecom-via-upi/v1/create-order';

  // Dispute
  static const String postDisputeReason = 'api/dispute/reason';
  static const String postSaveDispute = 'api/dispute/save-dispute';
  static const String postSolverDispute = 'api/dispute/solve-dispute';
  static const String postPendingDispute = 'api/dispute/pending-dispute';

  //* Prepaid card
  static const String postPpcardDetails = 'api/ppcard-details';

  static const String postPrepaidGenerateOTP =
      'api/prepaid-card/v1/generate-kyc-otp';

  static const String postPrepaidVerifyOTP =
      'api/prepaid-card/v1/verify-otp-for-kyc';

  static const String postCardCustomOnBoarding =
      'api/prepaid-card/v1/onboarding-app';

  static const String postViewCardDetailsByCardReference =
      'api/prepaid-card/v1/view-card-data';

  static const String postAddBalance =
      'api/prepaid-card/v1/prepaid/add-balance';

  static const String postBalanceInquiry =
      'api/prepaid-card/v1/balance-inquiry';

  static const String postResetPIN = 'api/prepaid-card/v1/reset-pin';

  static const String postUserStatusCheck =
      'api/prepaid-card/v1/user-status-check';

  static const String postPrepaidCardCVVNo = 'api/prepaid-card/v1/view-cvv';

  static const String postPrepaidCardMiniStatement =
      'api/prepaid-card/v1/mini-statement';

  //* Credit card withdrawal api

  static const String postSubmitCustomKyc =
      'api/credit-card-cash-withdrawal/v1/kyc';

  static const String postSubmitCustomKycLivePhoto =
      'api/credit-card-cash-withdrawal/v1/live-photo';

  //* Credit card withdrawal api

  static const String postCheckCustomer =
      "api/credit-card-cash-withdrawal/v1/check-kyc";

  static const String postCardWithdrawalCustomerKYC =
      "api/credit-card-cash-withdrawal/v1/submit-kyc";

  static const String postCardWithdrawalInitiate =
      "api/credit-card-cash-withdrawal/v1/initiate-withdrawal";

  static const String postCreditCardOTPVerify =
      "api/credit-card-cash-withdrawal/v1/verify-withdrawal-otp";

  static const String postResendCreditCardOTP =
      "api/credit-card-cash-withdrawal/v1/resend-otp";

//* UPI flow Api

  static const String postValidateCustomerUPI =
      "api/credit-card-cash-withdrawal/v1/validate-upi";

  static const String postSendMoneyToUPIOrBank =
      "api/credit-card-cash-withdrawal/v1/process-settlement";

  //* Credit card money want cash

  static const String postMoneyWantCash =
      "api/credit-card-cash-withdrawal/v1/settle-cash";

//* validate bank infor

  static const String postConfirmAndTransaction =
      "api/credit-card-cash-withdrawal/v1/confirm";

  static const String postValidateBankAccountInfo =
      "api/credit-card-cash-withdrawal/v1/verify-account";

  static String getCreditCardCashWithdrawalTransactionStatus(
          {required String transactionId}) =>
      "api/credit-card-cash-withdrawal/v1/:$transactionId/status";

  //* Vender KYC API
  static const String postVenderKycBasicDetails =
      "api/application/v1/merchant-kyc/save-section";

  static const String postVenderKycDocumentDetails =
      "api/application/v1/merchant-kyc/save-section";

  static const String postVenderKycBusinessInfo =
      "api/application/v1/merchant-kyc/save-section";

  static const String postVenderKycLiveShopVerification =
      "api/application/v1/merchant-kyc/upload-shop-photo";

  static const String postVenderKycBankDetails =
      "api/application/v1/merchant-kyc/save-section";

  static const String postVenderKycKYCDocUpload =
      "api/application/v1/merchant-kyc/upload-document";

  static const String venderKycDetail = "api/application/v1/merchant-kyc";

  static const String getVenderKycStatus =
      "api/application/v1/merchant-kyc/status";

  static const String postVenderKycFinalSubmit =
      "api/application/v1/merchant-kyc/submit";

  // helper
  static double horizontalPadding = 16.w;
  static double verticalPadding = 20.h;
  static EdgeInsets screenPadding = EdgeInsets.symmetric(
      horizontal: AppConstants.horizontalPadding,
      vertical: AppConstants.verticalPadding);

  // Shared Key
  static const String token = 'user_app_token';
  static const String apiToken = 'user_app_apiToken';

  static const String number = 'user_app_number';
  static const String password = 'user_app_password';
  static const String deviceId = 'user_device_id';
  static const String latitude = 'user_latitude';
  static const String longitude = 'user_longitude';
  static const String userId = 'user_app_id';
  static const String razorpayKey = 'razorpay_key';
  static const String recentOrders = 'recent_orders';
  static const String isUser = 'is_user';
  static const String isDemoShowKey = 'is_demo_show';
  static const String fcmToken = 'fcm_token';
  static const String soundNotificationIsOn = 'sound_notification_on';
  static const String soundNotificationLanguage = 'sound_notification_language';

  static String azureSpeechKey = dotenv.env['AZURE_SPEECH_KEY'] ?? '';
}
