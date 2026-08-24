import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import 'package:lekra/controllers/card_money_controller/custom_kyc_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';

class CustomerOtpVerificationSection extends StatelessWidget {
  const CustomerOtpVerificationSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomKycController>(
      builder: (controller) {
        final defaultPinTheme = PinTheme(
          width: 48.w,
          height: 50.h,
          textStyle: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: black,
          ),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: grey.withValues(alpha: 0.4),
            ),
          ),
        );

        final focusedPinTheme = defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: primaryColor,
              width: 1.5,
            ),
          ),
        );

        final submittedPinTheme = defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: Colors.green,
              width: 1.2,
            ),
          ),
        );

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: controller.isOtpVerified
                  ? Colors.green
                  : primaryColor.withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  'Enter OTP',
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: black,
                      ),
                ),
              ),
              sizedBoxHeight(height: 12),
              Pinput(
                length: 6,
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: controller.otp,
                    selection: TextSelection.collapsed(
                      offset: controller.otp.length,
                    ),
                  ),
                ),
                enabled: !controller.isMobileVerified,
                keyboardType: TextInputType.number,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                autofocus: true,
                onChanged: (value) {
                  controller.otp = value;
                  controller.update();
                },
                onCompleted: (value) async {
                  if (controller.isOtpVerified) {
                    return;
                  }

                  controller.otp = value;
                  controller.update();

                  await controller
                      .customerKycMobileCreditCarVerify()
                      .then((value) {
                    if (value.isSuccess) {
                      showToast(
                        message: value.message,
                        typeCheck: value.isSuccess,
                      );
                    } else {
                      showToast(
                        message: value.message,
                        typeCheck: value.isSuccess,
                      );
                    }
                  });
                },
              ),
              sizedBoxHeight(height: 10),
              if (!controller.isOtpVerified)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!controller.canResendOtp) ...[
                      CustomText(
                        'Resend OTP in ',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: greyDark,
                        ),
                      ),
                      CustomText(
                        controller.otpTimerText,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ] else ...[
                      CustomButton(
                        type: ButtonType.tertiary,
                        height: 40.h,
                        onTap: () async {
                          final result =
                              await controller.customerKycMobileCreditCardOTP();

                          if (result.isSuccess) {
                            controller.clearOtpOnly();
                            controller.startOtpTimer();

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
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              if (controller.isOtpVerified) ...[
                sizedBoxHeight(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16.r,
                    ),
                    sizedBoxWidth(width: 5),
                    CustomText(
                      'OTP Verified',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
