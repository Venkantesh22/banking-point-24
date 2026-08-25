// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lekra/services/constants.dart';
// import 'package:lekra/services/custom_text.dart';
// import 'package:lekra/services/theme.dart';

// import '../bank_payment_result_screen.dart';

// class BankPaymentResultHeader extends StatelessWidget {
//   const BankPaymentResultHeader({
//     super.key,
//     required this.status,
//   });

//   final BankPaymentStatus status;

//   @override
//   Widget build(BuildContext context) {
//     late final Color color;
//     late final Color lightColor;
//     late final IconData icon;
//     late final String title;
//     late final String subtitle;

//     switch (status) {
//       case BankPaymentStatus.successful:
//         color = const Color(0xFF20B978);
//         lightColor = const Color(0xFFE7F8EF);
//         icon = Icons.check_rounded;
//         title = 'Payment Successful!';
//         subtitle = 'The bank transfer has been completed successfully.';
//         break;

//       case BankPaymentStatus.pending:
//         color = const Color(0xFFF59E0B);
//         lightColor = const Color(0xFFFFF7E6);
//         icon = Icons.access_time_rounded;
//         title = 'Payment Pending';
//         subtitle = 'The bank transfer is being processed.';
//         break;

//       case BankPaymentStatus.cancelled:
//         color = red;
//         lightColor = redLight;
//         icon = Icons.close_rounded;
//         title = 'Payment Cancelled';
//         subtitle = 'The bank transfer was not successful.';
//         break;
//     }

//     return Column(
//       children: [


//         sizedBoxHeight(height: 24),

//         Container(
//           width: 112.w,
//           height: 112.h,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: lightColor,
//           ),
//           child: Center(
//             child: Container(
//               width: 82.w,
//               height: 82.h,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: color,
//               ),
//               child: Icon(
//                 icon,
//                 size: 46.sp,
//                 color: white,
//               ),
//             ),
//           ),
//         ),

//         sizedBoxHeight(height: 20),

//         CustomText(
//           title,
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 fontSize: 24.sp,
//                 fontWeight: FontWeight.w700,
//                 color: textPrimary,
//               ),
//         ),

//         sizedBoxHeight(height: 8),

//         CustomText(
//           subtitle,
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 fontSize: 13.sp,
//                 height: 1.5,
//                 color: textSecondary,
//               ),
//         ),
//       ],
//     );
//   }
// }