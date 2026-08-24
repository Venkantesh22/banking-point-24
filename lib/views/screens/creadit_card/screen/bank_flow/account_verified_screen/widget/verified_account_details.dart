import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/bank_info_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class VerifiedAccountDetails extends StatelessWidget {
  final BankInfoModel? bankInfoModel;
  const VerifiedAccountDetails({
    super.key,
    this.bankInfoModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        18.w,
        18.h,
        18.w,
        10.h,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: greyBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _VerifiedRow(
            label: 'Account Holder Name',
            value: bankInfoModel?.accountHolderName ?? "-",
          ),
          _VerifiedRow(
            label: 'Account Number',
            value: bankInfoModel?.maskedAccount ?? "-",
          ),
          _VerifiedRow(
            label: 'IFSC Code',
            value: bankInfoModel?.ifsc ?? "-",
          ),
          _VerifiedRow(
            label: 'Bank Name',
            value: bankInfoModel?.bankName ?? "-",
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F8EF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 19.sp,
                    color: const Color(0xFF20A865),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomText(
                      'Bank account verified successfully',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF20A865),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifiedRow extends StatelessWidget {
  const _VerifiedRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 9.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomText(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    color: textSecondary,
                  ),
            ),
          ),
          sizedBoxWidth(width: 12),
          Flexible(
            child: CustomText(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
