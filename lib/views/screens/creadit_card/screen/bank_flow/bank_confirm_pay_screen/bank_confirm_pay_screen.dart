import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/controllers/card_money_controller/upi_bank_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/creadit_card/screen/bank_flow/bank_confirm_pay_screen/widget/bank_confirm_pay_header.dart';
import 'package:lekra/views/screens/creadit_card/screen/bank_flow/bank_confirm_pay_screen/widget/bank_customer_details.dart';
import 'package:lekra/views/screens/creadit_card/screen/bank_flow/bank_confirm_pay_screen/widget/bank_payment_details.dart';
import 'package:lekra/views/screens/creadit_card/screen/bank_flow/bank_confirm_pay_screen/widget/bank_secure_message.dart';
import 'package:lekra/views/screens/creadit_card/screen/bank_flow/bank_payment_result_screen/bank_payment_result_screen.dart';
import 'package:lekra/views/screens/creadit_card/screen/payment_result_screen/payment_result_screen.dart';

class BankConfirmPayScreen extends StatelessWidget {
  const BankConfirmPayScreen({
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
                const BankConfirmPayHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const BankCustomerDetails(),
                        sizedBoxHeight(height: 16),
                        GetBuilder<CreditCardController>(
                            builder: (creditCardController) {
                          return BankPaymentDetails(
                            transaction:
                                creditCardController.initiationWithdrawalModel,
                          );
                        }),
                        sizedBoxHeight(height: 22),
                      ],
                    ),
                  ),
                ),
                const BankSecureMessage(),
                sizedBoxHeight(height: 18),
                GetBuilder<CreditCardController>(
                    builder: (creditCardController) {
                  return CustomButton(
                    title: 'Send Money',
                    type: ButtonType.primary,
                    onTap: () {
                      creditCardController
                          .sendMoneyToUPIOrBank(
                        isUpi: false,
                        accountNo:
                            upiBankController.bankInfoModel?.accountNumber ??
                                "",
                        ifscCode: upiBankController.bankInfoModel?.ifsc ?? "",
                        bankName:
                            upiBankController.bankInfoModel?.bankName ?? "",
                        recipientName: upiBankController
                                .bankInfoModel?.accountHolderName ??
                            "",
                      )
                          .then((value) {
                        if (value.isSuccess) {
                          showToast(
                              message: value.message,
                              typeCheck: value.isSuccess);
                          navigate(
                              context: context, page: PaymentResultScreen());
                        } else {
                          showToast(
                              message: value.message,
                              typeCheck: value.isSuccess);
                        }
                      });
                    },
                    height: 52.h,
                    radius: 14.r,
                    borderWidth: 0,
                    fontSize: 14.sp,
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
