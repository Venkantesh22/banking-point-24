import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:lekra/controllers/card_money_controller/upi_bank_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class BankCustomerDetails extends StatelessWidget {
  const BankCustomerDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpiBankController>(builder: (upiBankController) {
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
                  width: 52.w,
                  height: 52.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColorLight,
                  ),
                  child: Icon(
                    Icons.account_balance_outlined,
                    size: 27.sp,
                    color: primaryColor,
                  ),
                ),
                sizedBoxWidth(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        // customerName,
                        upiBankController.bankInfoModel?.accountHolderName ??
                            "-",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                      ),
                      sizedBoxHeight(height: 4),
                      CustomText(
                        'A/c No. ${upiBankController.bankInfoModel?.maskedAccount ?? "-"}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 11.sp,
                              color: textSecondary,
                            ),
                      ),
                      sizedBoxHeight(height: 3),
                      CustomText(
                        upiBankController.bankInfoModel?.bankName ?? "-",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 11.sp,
                              color: textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 46.w,
                  height: 46.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F8EF),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.verified_rounded,
                    size: 24.sp,
                    color: const Color(0xFF20A865),
                  ),
                ),
              ],
            ),
            sizedBoxHeight(height: 14),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      'IFSC Code',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11.sp,
                            color: textSecondary,
                          ),
                    ),
                  ),
                  CustomText(
                    upiBankController.bankInfoModel?.ifsc ?? "-",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
