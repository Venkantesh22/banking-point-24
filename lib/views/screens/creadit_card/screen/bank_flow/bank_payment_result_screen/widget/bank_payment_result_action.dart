// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lekra/services/theme.dart';
// import 'package:lekra/views/base/common_button.dart';

// import '../bank_payment_result_screen.dart';

// class BankPaymentResultAction extends StatelessWidget {
//   const BankPaymentResultAction({
//     super.key,
//     required this.status,
//   });

//   final BankPaymentStatus status;

//   @override
//   Widget build(BuildContext context) {
//     switch (status) {
//       case BankPaymentStatus.successful:
//         return Row(
//           children: [
//             Expanded(
//               child: CustomButton(
//                 type: ButtonType.secondary,
//                 onTap: () {
//                   debugPrint('Share bank receipt');
//                 },
//                 height: 50.h,
//                 radius: 14.r,
//                 borderColor: primaryColor,
//                 borderWidth: 1,
//                 color: white,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.share_outlined,
//                       size: 19.sp,
//                       color: primaryColor,
//                     ),
//                     SizedBox(width: 7.w),
//                     Text(
//                       'Share',
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                             fontSize: 13.sp,
//                             fontWeight: FontWeight.w600,
//                             color: primaryColor,
//                           ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             SizedBox(width: 12.w),

//             Expanded(
//               child: CustomButton(
//                 type: ButtonType.primary,
//                 onTap: () {
//                   debugPrint('Download bank receipt');
//                 },
//                 height: 50.h,
//                 radius: 14.r,
//                 borderWidth: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.download_outlined,
//                       size: 19.sp,
//                       color: white,
//                     ),
//                     SizedBox(width: 7.w),
//                     Text(
//                       'Receipt',
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                             fontSize: 13.sp,
//                             fontWeight: FontWeight.w600,
//                             color: white,
//                           ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );

//       case BankPaymentStatus.pending:
//         return CustomButton(
//           type: ButtonType.secondary,
//           onTap: () {
//             debugPrint('Check bank payment status');
//           },
//           height: 52.h,
//           radius: 14.r,
//           color: white,
//           borderColor: const Color(0xFFF59E0B),
//           borderWidth: 1.2,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.refresh_rounded,
//                 size: 20.sp,
//                 color: const Color(0xFFF59E0B),
//               ),
//               SizedBox(width: 8.w),
//               Text(
//                 'Check Payment Status',
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xFFF59E0B),
//                     ),
//               ),
//             ],
//           ),
//         );

//       case BankPaymentStatus.cancelled:
//         return CustomButton(
//           type: ButtonType.primary,
//           onTap: () {
//             debugPrint('Retry bank payment');
//           },
//           height: 52.h,
//           radius: 14.r,
//           borderWidth: 0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.refresh_rounded,
//                 size: 20.sp,
//                 color: white,
//               ),
//               SizedBox(width: 8.w),
//               Text(
//                 'Try Again',
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                       color: white,
//                     ),
//               ),
//             ],
//           ),
//         );
//     }
//   }
// }
