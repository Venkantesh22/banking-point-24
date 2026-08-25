// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lekra/data/models/cash%20withdrawal%20model/bank_tranfet_model.dart';
// import 'package:lekra/services/constants.dart';
// import 'package:lekra/services/custom_text.dart';
// import 'package:lekra/services/theme.dart';

// import '../bank_payment_result_screen.dart';

// class BankPaymentResultDetails extends StatelessWidget {
//   const BankPaymentResultDetails({
//     super.key,
//     required this.status,
//     required this.transaction,
//   });

//   final BankPaymentStatus status;
//   final BankTransferModel transaction;

//   @override
//   Widget build(BuildContext context) {
//     late final String statusText;
//     late final Color statusColor;
//     late final Color statusBackground;

//     switch (status) {
//       case BankPaymentStatus.successful:
//         statusText = 'Successful';
//         statusColor = const Color(0xFF20A865);
//         statusBackground = const Color(0xFFE7F8EF);
//         break;

//       case BankPaymentStatus.pending:
//         statusText = 'Pending';
//         statusColor = const Color(0xFFF59E0B);
//         statusBackground = const Color(0xFFFFF7E6);
//         break;

//       case BankPaymentStatus.cancelled:
//         statusText = 'Cancelled';
//         statusColor = red;
//         statusBackground = redLight;
//         break;
//     }

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.fromLTRB(
//         18.w,
//         18.h,
//         18.w,
//         8.h,
//       ),
//       decoration: BoxDecoration(
//         color: white,
//         borderRadius: BorderRadius.circular(20.r),
//         border: Border.all(
//           color: greyBorder,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.04),
//             blurRadius: 14,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _DetailRow(
//             label: 'Amount',
//             value: transaction.amount ?? '-',
//           ),

//           _DetailRow(
//             label: 'Processing Fee',
//             value: transaction.processingFee ?? '-',
//           ),

//           _DetailRow(
//             label: 'GST',
//             value: transaction.gst ?? '-',
//           ),

//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 10.h),
//             child: Divider(
//               color: greyBorder,
//               height: 1,
//             ),
//           ),

//           _DetailRow(
//             label: 'Total Debit',
//             value: transaction.totalDebit ??
//                 transaction.totalDebitAmount ??
//                 '-',
//             valueColor: status == BankPaymentStatus.cancelled
//                 ? red
//                 : textPrimary,
//             valueFontWeight: FontWeight.w700,
//           ),

//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 10.h),
//             child: Divider(
//               color: greyBorder,
//               height: 1,
//             ),
//           ),

//           _DetailRow(
//             label: 'Recipient',
//             value: transaction.recipientName ??
//                 transaction.customerName ??
//                 '-',
//           ),

//           _DetailRow(
//             label: 'A/c No.',
//             value: transaction.destination ?? '-',
//           ),

//           _DetailRow(
//             label: 'Bank',
//             value: transaction.bankName ?? '-',
//           ),

//           _DetailRow(
//             label: 'Transaction ID',
//             value: transaction.transactionId ?? '-',
//           ),

//           if (transaction.utr != null &&
//               transaction.utr!.trim().isNotEmpty)
//             _DetailRow(
//               label: 'UTR',
//               value: transaction.utr!,
//             ),

//           _DetailRow(
//             label: 'Settlement Type',
//             value: transaction.settlementType ?? '-',
//           ),

//           _DetailRow(
//             label: 'Date & Time',
//             value: transaction.dateTime ?? '-',
//           ),

//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 10.h),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: CustomText(
//                     'Status',
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyMedium
//                         ?.copyWith(
//                           fontSize: 13.sp,
//                           color: textSecondary,
//                         ),
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 12.w,
//                     vertical: 6.h,
//                   ),
//                   decoration: BoxDecoration(
//                     color: statusBackground,
//                     borderRadius: BorderRadius.circular(20.r),
//                   ),
//                   child: CustomText(
//                     statusText,
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodySmall
//                         ?.copyWith(
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w600,
//                           color: statusColor,
//                         ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DetailRow extends StatelessWidget {
//   const _DetailRow({
//     required this.label,
//     required this.value,
//     this.valueColor,
//     this.valueFontWeight = FontWeight.w500,
//   });

//   final String label;
//   final String value;
//   final Color? valueColor;
//   final FontWeight valueFontWeight;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 7.h),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: CustomText(
//               label,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyMedium
//                   ?.copyWith(
//                     fontSize: 13.sp,
//                     color: textSecondary,
//                   ),
//             ),
//           ),
//           sizedBoxWidth(width: 12),
//           Flexible(
//             child: CustomText(
//               value,
//               textAlign: TextAlign.right,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyMedium
//                   ?.copyWith(
//                     fontSize: 13.sp,
//                     fontWeight: valueFontWeight,
//                     color: valueColor ?? textPrimary,
//                   ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }