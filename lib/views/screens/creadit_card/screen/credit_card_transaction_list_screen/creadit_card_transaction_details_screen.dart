import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_transaction_details_model.dart';

import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class CreditCardCashWithdrawalTransactionDetailsScreen
    extends StatelessWidget {
  const CreditCardCashWithdrawalTransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  final CreditCardCashWithdrawalTransactionDetailsModel transaction;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(transaction);
    final statusText = _statusText(transaction);

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.5,
        centerTitle: true,
        title: CustomText(
          'Transaction Details',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          16.w,
          16.h,
          16.w,
          30.h,
        ),
        child: Column(
          children: [
            _TransactionHeader(
              transaction: transaction,
              statusColor: statusColor,
              statusText: statusText,
            ),

            sizedBoxHeight(height: 16),

            _AmountCard(
              transaction: transaction,
              statusColor: statusColor,
            ),

            sizedBoxHeight(height: 16),

            _DestinationCard(
              transaction: transaction,
            ),

            sizedBoxHeight(height: 16),

            _TransactionInformationCard(
              transaction: transaction,
            ),

            sizedBoxHeight(height: 16),

            _CardInformationCard(
              transaction: transaction,
            ),

            if (transaction.isTransactionFailed &&
                transaction.failureReason != null &&
                transaction.failureReason!.trim().isNotEmpty) ...[
              sizedBoxHeight(height: 16),
              _FailureCard(
                reason: transaction.failureReason!,
              ),
            ],

            if (transaction.settlementTime != null ||
                transaction.formattedSettlementTime != null) ...[
              sizedBoxHeight(height: 16),
              _TimelineCard(
                transaction: transaction,
              ),
            ],

            sizedBoxHeight(height: 12),

            _SupportNote(),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// HEADER
// ================================================================

class _TransactionHeader extends StatelessWidget {
  const _TransactionHeader({
    required this.transaction,
    required this.statusColor,
    required this.statusText,
  });

  final CreditCardCashWithdrawalTransactionDetailsModel transaction;
  final Color statusColor;
  final String statusText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _TypeIcon(
            transaction: transaction,
            size: 64,
          ),

          sizedBoxHeight(height: 12),

          CustomText(
            transaction.title ?? _typeTitle(transaction),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),

          sizedBoxHeight(height: 5),

          CustomText(
            transaction.transactionId ??
                transaction.transId ??
                '-',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              color: greyText2,
            ),
          ),

          sizedBoxHeight(height: 12),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7.w,
                  height: 7.w,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                CustomText(
                  statusText,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// AMOUNT
// ================================================================

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.transaction,
    required this.statusColor,
  });

  final CreditCardCashWithdrawalTransactionDetailsModel transaction;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Transaction Amount',
            style: TextStyle(
              fontSize: 11.sp,
              color: white.withValues(alpha: 0.80),
            ),
          ),

          sizedBoxHeight(height: 6),

          CustomText(
            transaction.formattedAmount ??
                transaction.displayAmount,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: white,
            ),
          ),

          sizedBoxHeight(height: 14),

          Row(
            children: [
              Expanded(
                child: _AmountMiniInfo(
                  title: 'Processing Fee',
                  value: transaction.displayProcessingFee,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _AmountMiniInfo(
                  title: 'GST',
                  value: transaction.displayGst,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _AmountMiniInfo(
                  title: 'Total Debit',
                  value: transaction.displayTotalCardDebit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountMiniInfo extends StatelessWidget {
  const _AmountMiniInfo({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 8.sp,
              color: white.withValues(alpha: 0.75),
            ),
          ),
          SizedBox(height: 4.h),
          CustomText(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: white,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// DESTINATION
// ================================================================

class _DestinationCard extends StatelessWidget {
  const _DestinationCard({
    required this.transaction,
  });

  final CreditCardCashWithdrawalTransactionDetailsModel transaction;

  @override
  Widget build(BuildContext context) {
    late final String heading;
    late final IconData icon;

    if (transaction.isCash) {
      heading = 'Cash Withdrawal';
      icon = Icons.payments_outlined;
    } else if (transaction.isUpi) {
      heading = 'UPI Payment';
      icon = Icons.account_balance_wallet_outlined;
    } else {
      heading = 'Bank Transfer';
      icon = Icons.account_balance_outlined;
    }

    return _SectionCard(
      title: heading,
      icon: icon,
      children: [
        if (transaction.isCash) ...[
          _DetailRow(
            label: 'Customer',
            value: transaction.customerName ?? '-',
          ),
          _DetailRow(
            label: 'Mobile',
            value: transaction.customerMobile ?? '-',
          ),
          _DetailRow(
            label: 'Recipient',
            value: transaction.displayRecipient,
          ),
        ],

        if (transaction.isUpi) ...[
          _DetailRow(
            label: 'Recipient',
            value: transaction.displayRecipient,
          ),
          _DetailRow(
            label: 'UPI ID',
            value: transaction.destinationUpiId ??
                transaction.upiId ??
                '-',
          ),
        ],

        if (transaction.isBank) ...[
          _DetailRow(
            label: 'Bank',
            value: transaction.displayBankName,
          ),
          _DetailRow(
            label: 'Account Holder',
            value: transaction.displayRecipient,
          ),
          _DetailRow(
            label: 'Account Number',
            value: transaction.destinationAccountNumber ??
                transaction.accountNumber ??
                '-',
          ),
          _DetailRow(
            label: 'IFSC',
            value: transaction.destinationIfsc ??
                transaction.ifsc ??
                '-',
          ),
        ],
      ],
    );
  }
}

// ================================================================
// TRANSACTION INFORMATION
// ================================================================

class _TransactionInformationCard extends StatelessWidget {
  const _TransactionInformationCard({
    required this.transaction,
  });

  final CreditCardCashWithdrawalTransactionDetailsModel transaction;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Transaction Information',
      icon: Icons.receipt_long_outlined,
      children: [
        _DetailRow(
          label: 'Transaction ID',
          value:
              transaction.transactionId ??
                  transaction.transId ??
                  '-',
          copyable: true,
        ),
        _DetailRow(
          label: 'Payment Reference',
          value: transaction.paymentReference ?? '-',
          copyable: true,
        ),
        _DetailRow(
          label: 'Bank Reference',
          value: transaction.bankReference ?? '-',
          copyable: true,
        ),
        _DetailRow(
          label: 'UTR',
          value: transaction.utr ?? '-',
          copyable: true,
        ),
        if (transaction.settlementUtr != null)
          _DetailRow(
            label: 'Settlement UTR',
            value: transaction.settlementUtr!,
            copyable: true,
          ),
        _DetailRow(
          label: 'Type',
          value: transaction.type ?? '-',
        ),
        _DetailRow(
          label: 'Settlement Type',
          value: transaction.settlementType ?? '-',
        ),
        _DetailRow(
          label: 'Destination Type',
          value: transaction.destinationType ?? '-',
        ),
      ],
    );
  }
}

// ================================================================
// CARD INFORMATION
// ================================================================

class _CardInformationCard extends StatelessWidget {
  const _CardInformationCard({
    required this.transaction,
  });

  final CreditCardCashWithdrawalTransactionDetailsModel transaction;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Card Information',
      icon: Icons.credit_card_outlined,
      children: [
        _DetailRow(
          label: 'Card',
          value: transaction.cardMasked ?? '-',
        ),
        _DetailRow(
          label: 'Network',
          value: transaction.cardNetwork ?? '-',
        ),
        _DetailRow(
          label: 'Card Bank',
          value: transaction.cardBankName ?? '-',
        ),
        _DetailRow(
          label: 'Card Holder',
          value: transaction.cardHolderName ??
              transaction.customerName ??
              '-',
        ),
      ],
    );
  }
}

// ================================================================
// TIMELINE
// ================================================================

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.transaction,
  });

  final CreditCardCashWithdrawalTransactionDetailsModel transaction;

  @override
  Widget build(BuildContext context) {
    final hasSettlement =
        transaction.formattedSettlementTime != null ||
        transaction.settlementTime != null;

    return _SectionCard(
      title: 'Transaction Timeline',
      icon: Icons.schedule_outlined,
      children: [
        _TimelineRow(
          icon: Icons.receipt_long_outlined,
          title: 'Created',
          value: transaction.formattedCreatedAt ??
              transaction.time ??
              transaction.createdAt ??
              '-',
          color: primaryColor,
        ),

        if (hasSettlement)
          _TimelineRow(
            icon: Icons.check_circle_outline,
            title: 'Settlement',
            value:
                transaction.formattedSettlementTime ??
                    transaction.settlementTime ??
                    '-',
            color: const Color(0xFF20A865),
          ),
      ],
    );
  }
}

// ================================================================
// FAILURE
// ================================================================

class _FailureCard extends StatelessWidget {
  const _FailureCard({
    required this.reason,
  });

  final String reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: red.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: red,
            size: 22.r,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Failure Reason',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: red,
                  ),
                ),
                SizedBox(height: 4.h),
                CustomText(
                  reason,
                  style: TextStyle(
                    fontSize: 11.sp,
                    height: 1.4,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// SECTION CARD
// ================================================================

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16.w,
        15.h,
        16.w,
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
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Icon(
                  icon,
                  size: 18.r,
                  color: primaryColor,
                ),
              ),
              SizedBox(width: 10.w),
              CustomText(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          ...List.generate(
            children.length,
            (index) {
              return Column(
                children: [
                  children[index],
                  if (index != children.length - 1)
                    Divider(
                      height: 1,
                      color: greyBorder,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ================================================================
// DETAIL ROW
// ================================================================

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.copyable = false,
  });

  final String label;
  final String value;
  final bool copyable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: CustomText(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: textSecondary,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: CustomText(
                    value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ),
                if (copyable &&
                    value != '-') ...[
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.copy_outlined,
                    size: 13.r,
                    color: greyText2,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// TIMELINE ROW
// ================================================================

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16.r,
              color: color,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                CustomText(
                  value,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: greyText2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// TYPE ICON
// ================================================================

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({
    required this.transaction,
    required this.size,
  });

  final CreditCardCashWithdrawalTransactionDetailsModel transaction;
  final double size;

  @override
  Widget build(BuildContext context) {
    late final IconData icon;
    late final Color color;

    if (transaction.isCash) {
      icon = Icons.payments_outlined;
      color = Colors.green;
    } else if (transaction.isUpi) {
      icon = Icons.account_balance_wallet_outlined;
      color = Colors.deepPurple;
    } else {
      icon = Icons.account_balance_outlined;
      color = primaryColor;
    }

    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: (size * 0.46).r,
      ),
    );
  }
}

// ================================================================
// SUPPORT NOTE
// ================================================================

class _SupportNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 17.r,
            color: primaryColor,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: CustomText(
              'Keep your transaction ID and UTR available if you need support.',
              style: TextStyle(
                fontSize: 10.sp,
                height: 1.4,
                color: textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// HELPERS
// ================================================================

String _typeTitle(
  CreditCardCashWithdrawalTransactionDetailsModel transaction,
) {
  if (transaction.isCash) {
    return 'Cash Withdrawal';
  }

  if (transaction.isUpi) {
    return 'UPI Payment';
  }

  return 'Bank Transfer';
}

String _statusText(
  CreditCardCashWithdrawalTransactionDetailsModel transaction,
) {
  if (transaction.isCashDisbursed) {
    return 'Cash Disbursed';
  }

  if (transaction.isSettlementSuccess) {
    return 'Successful';
  }

  if (transaction.isSettlementPending) {
    return 'Pending';
  }

  if (transaction.isTransactionFailed) {
    return 'Failed';
  }

  return transaction.displayStatus;
}

Color _statusColor(
  CreditCardCashWithdrawalTransactionDetailsModel transaction,
) {
  if (transaction.isCashDisbursed ||
      transaction.isSettlementSuccess) {
    return const Color(0xFF20A865);
  }

  if (transaction.isSettlementPending) {
    return const Color(0xFFF59E0B);
  }

  if (transaction.isTransactionFailed) {
    return red;
  }

  return greyText2;
}