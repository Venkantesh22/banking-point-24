// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
// import 'package:lekra/data/models/cash%20withdrawal%20model/bank_tranfet_model.dart';
// import 'package:lekra/services/constants.dart';
// import 'package:lekra/services/theme.dart';
// import 'package:lekra/views/screens/creadit_card/screen/bank_flow/bank_payment_result_screen/widget/bank_payment_result_action.dart';
// import 'package:lekra/views/screens/creadit_card/screen/bank_flow/bank_payment_result_screen/widget/bank_payment_result_details.dart';
// import 'package:lekra/views/screens/creadit_card/screen/bank_flow/bank_payment_result_screen/widget/bank_payment_result_header.dart';
// import 'package:lekra/views/screens/creadit_card/screen/bank_flow/bank_payment_result_screen/widget/bank_payment_result_message.dart';

// class BankPaymentResultScreen extends StatelessWidget {
//   const BankPaymentResultScreen({
//     super.key,
//     required this.transaction,
//   });

//   final BankTransferModel transaction;

//   BankPaymentStatus _getStatus() {
//     switch (transaction.settlementStatus?.trim().toUpperCase()) {
//       case 'SUCCESS':
//         return BankPaymentStatus.successful;

//       case 'PENDING':
//         return BankPaymentStatus.pending;

//       default:
//         return BankPaymentStatus.cancelled;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final status = _getStatus();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//       ),
//       backgroundColor: backgroundLight,
//       body: SafeArea(
//         child: GetBuilder<CreditCardController>(
//           builder: (controller) {
//             return Stack(
//               children: [
//                 SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   padding: EdgeInsets.fromLTRB(
//                     16.w,
//                     10.h,
//                     16.w,
//                     24.h,
//                   ),
//                   child: Column(
//                     children: [
//                       BankPaymentResultHeader(
//                         status: status,
//                       ),

//                       sizedBoxHeight(height: 24),

//                       BankPaymentResultDetails(
//                         status: status,
//                         transaction: transaction,
//                       ),

//                       sizedBoxHeight(height: 20),

//                       BankPaymentResultMessage(
//                         status: status,
//                       ),

//                       sizedBoxHeight(height: 24),

//                       BankPaymentResultAction(
//                         status: status,
//                       ),
//                     ],
//                   ),
//                 ),

//                 if (controller.isLoading)
//                   Positioned.fill(
//                     child: Container(
//                       color: Colors.black.withValues(
//                         alpha: 0.20,
//                       ),
//                       child: const Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     ),
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }