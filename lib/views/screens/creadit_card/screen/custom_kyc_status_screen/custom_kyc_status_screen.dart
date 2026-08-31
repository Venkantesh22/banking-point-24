import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/card_money_controller/custom_kyc_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/creadit_card/screen/custom_kyc_status_screen/widget/kyc_status_card.dart';
import 'package:lekra/views/screens/creadit_card/screen/custom_kyc_status_screen/widget/kyc_status_timeline.dart';
import 'package:lekra/views/screens/creadit_card/screen/custom_kyc_status_screen/widget/kyc_withdraw_info_card.dart';
import 'package:lekra/views/screens/creadit_card/screen/withdraw_money_screen/withdraw_money_screen.dart';

class CustomKycStatusScreen extends StatelessWidget {
  const CustomKycStatusScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomKycController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0, // Recommended when using a transparent background

            iconTheme: const IconThemeData(
              color: Colors.black,
            ),

            centerTitle: true,
            title: CustomText(
              "KYC Status",
              style: Helper(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: AppConstants.screenPadding,
              child: Column(
                children: [
                  KycStatusCard(
                    status: controller.status,
                  ),
                  sizedBoxHeight(height: 20),
                  KycStatusTimeline(
                    status: controller.status,
                  ),
                  sizedBoxHeight(height: 18),
                  KycWithdrawInfoCard(),
                  sizedBoxHeight(height: 20),
                  CustomButton(
                    isLoading: controller.isLoading,
                    height: 48.h,
                    radius: 8.r,
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        secondaryColor,
                      ],
                    ),
                    onTap: () {
                      if (controller.cardCashWithdrawalCustomKycStatusModel
                              ?.kycStatus ==
                          "Verified") {
                        navigate(context: context, page: WithdrawMoneyScreen());
                      }
                      log("hii");
                    },
                    title: controller.cardCashWithdrawalCustomKycStatusModel
                                ?.kycStatus ==
                            "Verified"
                        ? "(Verified) Container"
                        : "Wait for KYC Verified",
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
