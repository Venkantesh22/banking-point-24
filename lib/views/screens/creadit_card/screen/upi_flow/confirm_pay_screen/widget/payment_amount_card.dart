import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class PaymentAmountCard extends StatelessWidget {
  const PaymentAmountCard({
    super.key,
  });

  // Demo values
  static const String amount = '₹25,000.00';
  static const String processingFee = '₹0.00';
  static const String gst = '₹0.00';
  static const String totalDebit = '₹25,000.00';

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
        children: [
          _AmountRow(
            label: 'Amount',
            value: amount,
          ),

          _AmountRow(
            label: 'Processing Fee',
            value: processingFee,
          ),

          _AmountRow(
            label: 'GST',
            value: gst,
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(
              height: 1,
              color: greyBorder,
            ),
          ),

          _AmountRow(
            label: 'Total Debit',
            value: totalDebit,
            valueColor: primaryColor,
            valueFontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueFontWeight = FontWeight.w500,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final FontWeight valueFontWeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    color: textSecondary,
                  ),
            ),
          ),

          CustomText(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  fontWeight: valueFontWeight,
                  color: valueColor ?? textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}