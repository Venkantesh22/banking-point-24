import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/initiation_withdrawal_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class TransactionDetailsCard extends StatelessWidget {
  const TransactionDetailsCard({
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

    final String bankName = transaction?.cardBankName ?? '-';

    final String accountNumber = transaction?.cardMasked ?? '-';

    final String transactionId = transaction?.transactionId ?? '-';

    final String dateTime = transaction?.dateTime ?? '-';

    final String status = transaction?.status ?? '-';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        18.w,
        18.h,
        18.w,
        8.h,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: greyBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.04,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          TransactionDetailRow(
            label: 'Amount',
            value: PriceConverter.convertToNumberFormat(
                double.tryParse(amount) ?? 0.0),
          ),
          TransactionDetailRow(
            label: 'Processing Fee',
            value: PriceConverter.convertToNumberFormat(
                double.tryParse(processingFee) ?? 0.0),
          ),
          TransactionDetailRow(
            label: 'GST',
            value: PriceConverter.convertToNumberFormat(
                double.tryParse(gst) ?? 0.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.h,
            ),
            child: Divider(
              color: greyBorder,
              height: 1,
            ),
          ),
          TransactionDetailRow(
            label: 'Total Debit',
            value: PriceConverter.convertToNumberFormat(
                double.tryParse(totalDebit) ?? 0.0),
            valueColor: _statusColor(
              status,
            ),
            valueFontWeight: FontWeight.w700,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.h,
            ),
            child: Divider(
              color: greyBorder,
              height: 1,
            ),
          ),
          TransactionDetailRow(
            label: 'To',
            value: bankName,
          ),
          TransactionDetailRow(
            label: 'Card',
            value: accountNumber,
          ),
          TransactionDetailRow(
            label: 'Card Network',
            value: transaction?.cardNetwork ?? '-',
          ),
          TransactionDetailRow(
            label: 'Customer',
            value: transaction?.customerName ?? '-',
          ),
          TransactionDetailRow(
            label: 'Transaction ID',
            value: transactionId,
          ),
          TransactionDetailRow(
            label: 'Date & Time',
            value: dateTime,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.h,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomText(
                    'Status',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp,
                          color: textSecondary,
                        ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomText(
                    status,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: _statusColor(status),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.trim().toUpperCase()) {
      case 'SUCCESS':
      case 'SUCCESSFUL':
      case 'COMPLETED':
        return const Color(0xFF20A865);

      case 'PENDING':
      case 'PROCESSING':
        return Colors.orange;

      case 'FAILED':
      case 'REJECTED':
      case 'CANCELLED':
        return red;

      default:
        return textPrimary;
    }
  }
}

class TransactionDetailRow extends StatelessWidget {
  const TransactionDetailRow({
    super.key,
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
      padding: EdgeInsets.symmetric(
        vertical: 7.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          sizedBoxWidth(width: 12),
          Expanded(
            child: CustomText(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: valueFontWeight,
                    color: valueColor ?? textPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
