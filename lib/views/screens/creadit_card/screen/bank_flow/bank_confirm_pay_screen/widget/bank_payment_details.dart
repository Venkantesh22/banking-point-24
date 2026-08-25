import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/initiation_withdrawal_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class BankPaymentDetails extends StatelessWidget {
  const BankPaymentDetails({
    super.key,
    required this.transaction,
  });

  final InitiationWithdrawalModel? transaction;

  @override
  Widget build(BuildContext context) {
    final String amount = transaction?.amount ?? '-';

    final String processingFee = transaction?.processingFee ?? '-';

    final String gst = transaction?.gst ?? '-';

    final String totalDebit = transaction?.totalCardDebit ?? '-';

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
          _PaymentRow(
              label: 'Amount',
              value: PriceConverter.convertToNumberFormat(
                  double.tryParse(amount) ?? 0.0)),
          _PaymentRow(
            label: 'Processing Fee',
            value: PriceConverter.convertToNumberFormat(
                double.tryParse(processingFee) ?? 0.0),
          ),
          _PaymentRow(
            label: 'GST',
            value: PriceConverter.convertToNumberFormat(
                double.tryParse(gst) ?? 0.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(
              height: 1,
              color: greyBorder,
            ),
          ),
          _PaymentRow(
            label: 'Total Debit',
            value: PriceConverter.convertToNumberFormat(
                double.tryParse(totalDebit) ?? 0.0),
            valueColor: const Color(0xFF20A865),
            valueFontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
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
