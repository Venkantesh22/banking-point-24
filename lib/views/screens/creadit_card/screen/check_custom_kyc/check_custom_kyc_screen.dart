// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lekra/controllers/card_money_controller/custom_kyc_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/creadit_card/screen/custom_kyc_screen/custom_kyc_screen.dart';
import 'package:lekra/views/screens/creadit_card/screen/withdraw_money_screen/withdraw_money_screen.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class CheckCustomerKycScreen extends StatefulWidget {
  const CheckCustomerKycScreen({
    super.key,
  });

  @override
  State<CheckCustomerKycScreen> createState() => _CheckCustomerKycScreenState();
}

class _CheckCustomerKycScreenState extends State<CheckCustomerKycScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CustomKycController>().mobileNumberController.clear();
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomKycController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            backgroundColor: white,
            elevation: 0,

            title: CustomText(
              'Check Customer KYC',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF101B5C),
              ),
            ),
            centerTitle: true,
          ),

          // ==========================================================
          // BODY
          // ==========================================================

          body: SafeArea(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 10.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // IMAGE
                    // ==================================================

                    Center(
                      child: CustomImage(
                        path: Assets.imagesSearchInMobile,
                        height: 300.h,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // ==================================================
                    // TITLE
                    // ==================================================

                    Center(
                      child: CustomText(
                        'Enter Customer Mobile Number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF101B5C),
                        ),
                      ),
                    ),

                    sizedBoxHeight(height: 8),

                    // ==================================================
                    // DESCRIPTION
                    // ==================================================

                    Center(
                      child: CustomText(
                        'We will check if this customer is registered\n'
                        'and KYC is completed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.6,
                          color: greyDark,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    sizedBoxHeight(height: 28),

                    // ==================================================
                    // MOBILE NUMBER
                    // ==================================================

                    AppTextFieldWithHeading(
                      controller: controller.mobileNumberController,
                      heading: 'Mobile Number',
                      hindText: 'Enter mobile number',
                      prefixText: '+91 ',
                      prefixStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF101B5C),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      maxLength: 10,
                      isRequired: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                          10,
                        ),
                      ],
                      bgColor: white,
                      borderColor: const Color(0xFFD6DCE8),
                      borderWidth: 1,
                      borderRadius: 12,
                      validator: (value) {
                        final String mobile = value?.trim() ?? '';

                        if (mobile.isEmpty) {
                          return 'Please enter customer mobile number';
                        }

                        if (!RegExp(
                          r'^[6-9][0-9]{9}$',
                        ).hasMatch(mobile)) {
                          return 'Please enter a valid 10 digit mobile number';
                        }

                        return null;
                      },
                    ),

                    sizedBoxHeight(height: 18),

                    // ==================================================
                    // INFO CARD
                    // ==================================================

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F6FF),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFD5E3FF),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: white,
                              size: 19.r,
                            ),
                          ),
                          sizedBoxWidth(width: 10),
                          Expanded(
                            child: CustomText(
                              'We will check this number in our '
                              'system and return the customer KYC status.',
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontSize: 12.sp,
                                height: 1.5,
                                color: const Color(
                                  0xFF27366F,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    sizedBoxHeight(height: 26),

                    // ==================================================
                    // WHAT HAPPENS NEXT
                    // ==================================================

                    CustomText(
                      'What happens next?',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF101B5C),
                      ),
                    ),

                    sizedBoxHeight(height: 14),

                    _StatusInfoRow(
                      icon: Icons.check_rounded,
                      iconColor: const Color(0xFF16B66A),
                      title: 'If KYC is already completed',
                      description: 'You will be directed to withdraw money.',
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        left: 22.w,
                      ),
                      child: Divider(
                        height: 22.h,
                        color: const Color(0xFFE5E9F2),
                      ),
                    ),

                    _StatusInfoRow(
                      icon: Icons.person_outline_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      title: 'If KYC is not completed',
                      description:
                          'You will be directed to complete customer KYC.',
                    ),

                    sizedBoxHeight(height: 28),

                    // ==================================================
                    // CHECK BUTTON
                    // ==================================================

                    CustomButton(
                      isLoading: controller.isLoading,
                      title: 'Check Customer KYC',
                      height: 52.h,
                      radius: 12.r,
                      gradient: const LinearGradient(
                        colors: [
                          primaryColor,
                          Color(0xFF1747B8),
                        ],
                      ),
                      onTap: () {
                        if (formKey.currentState?.validate() ?? false) {
                          controller.checkCustomerKYC().then((value) {
                            if (value.isSuccess) {
                              showToast(
                                  message: value.message,
                                  typeCheck: value.isSuccess);
                              (controller.checkCustomKyc?.canWithdraw == false)
                                  ? navigate(
                                      context: context, page: CustomKycScreen())
                                  : navigate(
                                      context: context,
                                      page: WithdrawMoneyScreen());
                            } else {
                              showToast(
                                  message: value.message,
                                  typeCheck: value.isSuccess);
                            }
                          });
                        }
                      },
                    ),

                    sizedBoxHeight(height: 18),

                    // ==================================================
                    // SECURITY
                    // ==================================================

                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 16.r,
                            color: greyDark,
                          ),
                          sizedBoxWidth(width: 6),
                          CustomText(
                            'Your information is secure and protected',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: greyDark,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    sizedBoxHeight(height: 200),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ================================================================
// STATUS INFORMATION ROW
// ================================================================

class _StatusInfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _StatusInfoRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24.r,
          ),
        ),
        sizedBoxWidth(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF101B5C),
                ),
              ),
              sizedBoxHeight(height: 4),
              CustomText(
                description,
                style: TextStyle(
                  fontSize: 12.sp,
                  height: 1.4,
                  color: greyDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
