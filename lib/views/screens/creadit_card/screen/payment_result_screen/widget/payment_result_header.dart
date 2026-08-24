import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_transaction_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class PaymentResultHeader extends StatelessWidget {
  const PaymentResultHeader({
    super.key,
    required this.status,
  });

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final Color lightColor;
    late final IconData icon;
    late final String title;
    late final String subtitle;

    switch (status) {
      case PaymentStatus.successful:
        color = const Color(0xFF20B978);
        lightColor = const Color(0xFFE7F8EF);
        icon = Icons.check_rounded;
        title = 'Payment Successful!';
        subtitle = 'The payment has been completed successfully.';
        break;

      case PaymentStatus.pending:
        color = const Color(0xFFF59E0B);
        lightColor = const Color(0xFFFFF7E6);
        icon = Icons.access_time_rounded;
        title = 'Payment Pending';
        subtitle = 'Your payment is being processed.';
        break;

      case PaymentStatus.cancelled:
        color = red;
        lightColor = redLight;
        icon = Icons.close_rounded;
        title = 'Payment Cancelled';
        subtitle = 'The payment was not successful.';
        break;

      case PaymentStatus.cash:
        color = const Color(0xFF20B978);
        lightColor = const Color(0xFFE7F8EF);
        icon = Icons.payments_rounded;
        title = 'Cash Disbursed';
        subtitle = 'Cash has been successfully disbursed.';
        break;
    }

    return Column(
      children: [
        GetBuilder<BasicController>(builder: (basicController) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: greyBorder,
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  basicController.isAndroid
                      ? Icons.arrow_back
                      : Icons.arrow_back_ios_new_rounded,
                  size: 18.sp,
                  color: textPrimary,
                ),
              ),
            ),
          );
        }),
        sizedBoxHeight(height: 24),
        Container(
          width: 112.w,
          height: 112.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: lightColor,
          ),
          child: Center(
            child: Container(
              width: 82.w,
              height: 82.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Icon(
                icon,
                size: 46.sp,
                color: white,
              ),
            ),
          ),
        ),
        sizedBoxHeight(height: 20),
        CustomText(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
        ),
        sizedBoxHeight(height: 8),
        CustomText(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                height: 1.5,
                color: textSecondary,
              ),
        ),
      ],
    );
  }
}
