import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/controllers/card_money_controller/upi_bank_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/base/shimmer.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/creadit_card/screen/bank_flow/account_verified_screen/widget/account_verified_header.dart';
import 'package:lekra/views/screens/creadit_card/screen/bank_flow/account_verified_screen/widget/verified_account_details.dart';
import 'package:lekra/views/screens/creadit_card/screen/bank_flow/bank_confirm_pay_screen/bank_confirm_pay_screen.dart';

class AccountVerifiedScreen extends StatelessWidget {
  const AccountVerifiedScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: GetBuilder<UpiBankController>(builder: (upiBankController) {
          return Padding(
            padding: AppConstants.screenPadding,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const AccountVerifiedHeader(),
                        sizedBoxHeight(height: 28),
                        CustomShimmer(
                          isLoading: upiBankController.isLoading,
                          child: VerifiedAccountDetails(
                            bankInfoModel: upiBankController.bankInfoModel,
                          ),
                        ),
                        sizedBoxHeight(height: 24),
                      ],
                    ),
                  ),
                ),
                GetBuilder<CreditCardController>(
                    builder: (creditCardController) {
                  return CustomButton(
                    isLoading: upiBankController.isLoading,
                    title: 'Proceed to Confirm',
                    type: ButtonType.primary,
                    onTap: () {
                      // creditCardController.sendMoneyToUPIOrBank(
                      //     isUpi: false,
                      //     upiId: upiId,
                      //     recipientName: recipientName);

                      navigate(context: context, page: BankConfirmPayScreen());
                    },
                    height: 52.h,
                    radius: 14.r,
                    borderWidth: 0,
                    fontSize: 14.sp,
                  );
                })
              ],
            ),
          );
        }),
      ),
    );
  }
}
