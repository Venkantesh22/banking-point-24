import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/creadit_card/screen/transaction_success_screen/transaction_success_screen.dart';

class WithdrawVerifyOtpScreen extends StatefulWidget {
  const WithdrawVerifyOtpScreen({
    super.key,
  });

  @override
  State<WithdrawVerifyOtpScreen> createState() =>
      _WithdrawVerifyOtpScreenState();
}

class _WithdrawVerifyOtpScreenState extends State<WithdrawVerifyOtpScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<CreditCardController>();
      controller.startOtpTimer();
      controller.otpPinputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditCardController>(
      builder: (creditCardController) {
        final defaultPinTheme = PinTheme(
          width: 48.w,
          height: 52.h,
          textStyle: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: black,
          ),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: grey.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
        );

        final focusedPinTheme = defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: primaryColor,
              width: 1.5,
            ),
          ),
        );

        final submittedPinTheme = defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: primaryColor,
              width: 1,
            ),
          ),
        );

        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            backgroundColor: white,
            elevation: 0,
            centerTitle: true,
            title: CustomText(
              'Verify OTP',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF101B5C),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 15.h,
              ),
              child: Column(
                children: [
                  sizedBoxHeight(height: 20),

                  const _SecurityIcon(),

                  sizedBoxHeight(height: 24),

                  CustomText(
                    'Enter OTP',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF101B5C),
                    ),
                  ),

                  sizedBoxHeight(height: 8),

                  CustomText(
                    'We have sent a 6-digit OTP to',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: greyDark,
                    ),
                  ),

                  sizedBoxHeight(height: 4),

                  CustomText(
                    '+91 98765 43210',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),

                  sizedBoxHeight(height: 30),

                  // ==================================================
                  // PINPUT OTP
                  // ==================================================

                  Pinput(
                    length: 6,
                    keyboardType: TextInputType.number,
                    controller: creditCardController.otpPinputController,
                    focusNode: creditCardController.otpFocusNode,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    showCursor: true,
                    autofocus: true,
                    inputFormatters: const [],
                    onChanged: (value) {
                      creditCardController.otp = value;
                      creditCardController.isOtpVerified = value.length == 6;

                      creditCardController.update();
                    },
                    onCompleted: (value) {
                      creditCardController.otp = value;
                      creditCardController.isOtpVerified = true;
                      creditCardController.update();
                    },
                  ),

                  sizedBoxHeight(height: 24),

                  // ==================================================
                  // TIMER / RESEND
                  // ==================================================

                  CustomText(
                    creditCardController.canResendOtp
                        ? 'Didn’t receive OTP?'
                        : 'Resend OTP in '
                            '${creditCardController.otpTimerText}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: greyDark,
                    ),
                  ),

                  if (creditCardController.canResendOtp) ...[
                    sizedBoxHeight(height: 10),
                    TextButton(
                      onPressed: creditCardController.isLoading
                          ? null
                          : () async {
                              final result = await creditCardController
                                  .resendCreditCardOTP();

                              if (result.isSuccess) {
                                creditCardController.clearOtpForPinput();

                                creditCardController.startOtpTimer();

                                showToast(
                                  message: result.message,
                                  typeCheck: true,
                                );
                              } else {
                                showToast(
                                  message: result.message,
                                  typeCheck: false,
                                );
                              }
                            },
                      child: CustomText(
                        'Resend OTP',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],

                  sizedBoxHeight(height: 35),

                  // ==================================================
                  // VERIFY BUTTON
                  // ==================================================

                  CustomButton(
                    isLoading: creditCardController.isLoading,
                    title: 'Verify OTP',
                    height: 48.h,
                    radius: 8.r,
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        secondaryColor,
                      ],
                    ),
                    onTap: creditCardController.isLoading
                        ? null
                        : () async {
                            if (creditCardController.otp.length != 6) {
                              showToast(
                                message: 'Please enter a valid 6 digit OTP',
                                toastType: ToastType.error,
                              );
                              return;
                            }

                            final result = await creditCardController
                                .creditCardOTPVerify();

                            if (result.isSuccess) {
                              showToast(
                                message: result.message,
                                typeCheck: true,
                              );

                              navigate(
                                context: context,
                                page: const TransactionSuccessScreen(),
                              );
                            } else {
                              showToast(
                                message: result.message,
                                typeCheck: false,
                              );
                            }
                          },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ==================================================================
// SECURITY ICON
// ==================================================================

class _SecurityIcon extends StatelessWidget {
  const _SecurityIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.w,
      height: 110.w,
      decoration: BoxDecoration(
        color: primaryColor.withValues(
          alpha: 0.05,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: const Color(0xFF0D48C8),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Icon(
            Icons.lock_outline_rounded,
            color: white,
            size: 40.r,
          ),
        ),
      ),
    );
  }
}
