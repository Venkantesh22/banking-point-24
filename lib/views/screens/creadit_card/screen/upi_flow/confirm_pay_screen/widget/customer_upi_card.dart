import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_upi_model.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class CustomerUpiCard extends StatelessWidget {
  final CreditCardUpiModel? cardUpiModel;
  const CustomerUpiCard({
    super.key,
    required this.cardUpiModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18.r),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'To',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: textSecondary,
                ),
          ),
          sizedBoxHeight(height: 12),
          Row(
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColorLight,
                ),
                child: Center(
                  child: CustomText(
                    'RK',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                  ),
                ),
              ),
              sizedBoxWidth(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      cardUpiModel?.recipientName ?? "",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                    ),
                    sizedBoxHeight(height: 4),
                    CustomText(
                      cardUpiModel?.upiId ?? "",
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11.sp,
                            color: textSecondary,
                          ),
                    ),
                    sizedBoxHeight(height: 4),
                    CustomText(
                      "HDFC Bank",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11.sp,
                            color: textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: SvgPicture.asset(
                    Assets.svgsUpi,
                    height: 30.h,
                    width: 30.w,
                    fit: BoxFit.contain,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
