import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_transaction_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/creadit_card/screen/payment_result_screen/widget/payment_result_action.dart';
import 'package:lekra/views/screens/creadit_card/screen/payment_result_screen/widget/payment_result_details.dart';
import 'package:lekra/views/screens/creadit_card/screen/payment_result_screen/widget/payment_result_header.dart';

class PaymentResultScreen extends StatelessWidget {
  const PaymentResultScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: GetBuilder<CreditCardController>(builder: (creditCardController) {
        PaymentStatus _getPaymentStatus() {
          switch (creditCardController
              .creditCardTransactionModel?.settlementStatus
              ?.trim()
              .toUpperCase()) {
            case 'SUCCESS':
              return PaymentStatus.successful;

            case 'PENDING':
              return PaymentStatus.pending;

            case 'CASH_DISBURSED':
              return PaymentStatus.cash;

            default:
              return PaymentStatus.cancelled;
          }
        }

        final PaymentStatus status = _getPaymentStatus();

        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              16.w,
              10.h,
              16.w,
              24.h,
            ),
            child: Column(
              children: [
                PaymentResultHeader(
                  status: status,
                ),
                sizedBoxHeight(height: 24),
                PaymentResultDetails(
                  status: status,
                  transaction:
                      creditCardController.creditCardTransactionModel ??
                          CreditCardTransactionModel(),
                ),
                sizedBoxHeight(height: 20),
                _StatusMessage(
                  status: status,
                ),
                sizedBoxHeight(height: 24),
                PaymentResultAction(
                  status: status,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({
    required this.status,
  });

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    late final String message;
    late final IconData icon;
    late final Color color;

    switch (status) {
      case PaymentStatus.successful:
        message = 'Payment has been successfully completed.';
        icon = Icons.check_circle_outline_rounded;
        color = const Color(0xFF20A865);
        break;

      case PaymentStatus.pending:
        message = 'Payment is being processed. Please wait for confirmation.';
        icon = Icons.access_time_rounded;
        color = const Color(0xFFF59E0B);
        break;

      case PaymentStatus.cancelled:
        message = 'Payment was not successful and has been cancelled.';
        icon = Icons.cancel_outlined;
        color = red;
        break;

      case PaymentStatus.cash:
        message = 'Cash has been successfully disbursed.';
        icon = Icons.payments_outlined;
        color = const Color(0xFF20A865);
        break;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 14.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: color,
          ),
          sizedBoxWidth(width: 9),
          Expanded(
            child: CustomText(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11.sp,
                    height: 1.5,
                    color: textPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
