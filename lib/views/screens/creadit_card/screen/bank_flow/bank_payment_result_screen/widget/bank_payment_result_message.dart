// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lekra/services/constants.dart';
// import 'package:lekra/services/custom_text.dart';
// import 'package:lekra/services/theme.dart';

// import '../bank_payment_result_screen.dart';

// class BankPaymentResultMessage extends StatelessWidget {
//   const BankPaymentResultMessage({
//     super.key,
//     required this.status,
//   });

//   final BankPaymentStatus status;

//   @override
//   Widget build(BuildContext context) {
//     late final String message;
//     late final IconData icon;
//     late final Color color;

//     switch (status) {
//       case BankPaymentStatus.successful:
//         message = 'The amount has been successfully transferred to the customer bank account.';
//         icon = Icons.check_circle_outline_rounded;
//         color = const Color(0xFF20A865);
//         break;

//       case BankPaymentStatus.pending:
//         message = 'The bank is processing this transaction. Please check the payment status again.';
//         icon = Icons.access_time_rounded;
//         color = const Color(0xFFF59E0B);
//         break;

//       case BankPaymentStatus.cancelled:
//         message = 'The bank transfer was not successful. The transaction has been cancelled.';
//         icon = Icons.cancel_outlined;
//         color = red;
//         break;
//     }

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(
//         horizontal: 16.w,
//         vertical: 14.h,
//       ),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.07),
//         borderRadius: BorderRadius.circular(14.r),
//         border: Border.all(
//           color: color.withValues(alpha: 0.12),
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(
//             icon,
//             size: 20.sp,
//             color: color,
//           ),

//           sizedBoxWidth(width: 9),

//           Expanded(
//             child: CustomText(
//               message,
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     fontSize: 11.sp,
//                     height: 1.5,
//                     color: textPrimary,
//                   ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }