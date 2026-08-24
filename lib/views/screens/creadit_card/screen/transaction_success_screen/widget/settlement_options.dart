import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/creadit_card/screen/choose_settlement_method_screen/choose_settlement_method_screen.dart';
import 'package:lekra/views/screens/creadit_card/screen/payment_result_screen/payment_result_screen.dart';

class SettlementOptions extends StatelessWidget {
  const SettlementOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 112.h,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: greyBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GetBuilder<CreditCardController>(builder: (creditCardController) {
            return Expanded(
              child: SettlementOptionItem(
                icon: Icons.payments_outlined,
                iconColor: const Color(0xFF20A865),
                title: 'Want Money Cash',
                onTap: () {
                  creditCardController.moneyWantCash().then((value) {
                    if (value.isSuccess) {
                      showToast(
                          message: value.message, typeCheck: value.isSuccess);
                      navigate(context: context, page: PaymentResultScreen());
                    } else {
                      showToast(
                          message: value.message, typeCheck: value.isSuccess);
                    }
                  });
                },
              ),
            );
          }),
          Container(
            width: 1,
            height: 70.h,
            color: greyBorder,
          ),
          Expanded(
            child: SettlementOptionItem(
              icon: Icons.account_balance_outlined,
              iconColor: primaryColor,
              title: 'Settlement to Customer',
              onTap: () {
                navigate(
                    context: context, page: ChooseSettlementMethodScreen());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SettlementOptionItem extends StatelessWidget {
  const SettlementOptionItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 10.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32.sp,
                color: iconColor,
              ),
              sizedBoxHeight(height: 8),
              CustomText(
                title,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
