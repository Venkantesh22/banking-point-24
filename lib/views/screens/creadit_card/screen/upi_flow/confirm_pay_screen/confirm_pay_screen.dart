import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/controllers/card_money_controller/upi_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/creadit_card/screen/payment_result_screen/payment_result_screen.dart';
import 'package:lekra/views/screens/creadit_card/screen/upi_flow/confirm_pay_screen/widget/confirm_pay_header.dart';
import 'package:lekra/views/screens/creadit_card/screen/upi_flow/confirm_pay_screen/widget/customer_upi_card.dart';
import 'package:lekra/views/screens/creadit_card/screen/upi_flow/confirm_pay_screen/widget/payment_amount_card.dart';
import 'package:lekra/views/screens/creadit_card/screen/upi_flow/confirm_pay_screen/widget/send_money_button.dart';

class ConfirmPayScreen extends StatelessWidget {
  const ConfirmPayScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: GetBuilder<UpiController>(builder: (upiController) {
        return SafeArea(
          child: Padding(
            padding: AppConstants.screenPadding,
            child: Column(
              children: [
                const ConfirmPayHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        CustomShimmer(
                          isLoading: upiController.isLoading,
                          child: CustomerUpiCard(
                            cardUpiModel: upiController.creditCardUpiModel,
                          ),
                        ),
                        sizedBoxHeight(height: 16),
                        const PaymentAmountCard(),
                        sizedBoxHeight(height: 24),
                      ],
                    ),
                  ),
                ),
                const _SecureTransactionMessage(),
                sizedBoxHeight(height: 18),
                GetBuilder<CreditCardController>(
                    builder: (creditCardController) {
                  return SendMoneyButton(
                    onTap: () {
                      creditCardController
                          .sendMoneyToUPIOrBank(
                              isUpi: true,
                              upiId:
                                  upiController.creditCardUpiModel?.upiId ?? "",
                              recipientName: upiController
                                      .creditCardUpiModel?.recipientName ??
                                  "")
                          .then((value) {
                        if (value.isSuccess) {
                          navigate(
                              context: context, page: PaymentResultScreen());
                          showToast(
                              message: value.message,
                              typeCheck: value.isSuccess);
                        } else {
                          showToast(
                              message: value.message,
                              typeCheck: value.isSuccess);
                        }
                      });
                    },
                  );
                }),
                sizedBoxHeight(height: 18),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _SecureTransactionMessage extends StatelessWidget {
  const _SecureTransactionMessage();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.verified_user_rounded,
          size: 16.sp,
          color: const Color(0xFF20A865),
        ),
        sizedBoxWidth(width: 6),
        Text(
          'Your transaction is 100% secure',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF20A865),
              ),
        ),
      ],
    );
  }
}
