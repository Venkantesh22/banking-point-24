import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/creadit_card/screen/credit_card_transaction_list_screen/creadit_card_transaction_details_screen.dart';
import 'package:lekra/views/screens/creadit_card/screen/credit_card_transaction_list_screen/credit_card_transaction_list_screen.dart';
import 'package:lekra/views/screens/creadit_card/screen/credit_card_transaction_list_screen/widget/transaction_widget.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/view_widget.dart';

class TransactionHistoryWidget extends StatelessWidget {
  const TransactionHistoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ==========================================================
        // HEADER
        // ==========================================================
        Row(
          children: [
            Expanded(
              child: Text(
                "Transaction History",
                style: Helper(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
              ),
            ),
            GetBuilder<CreditCardController>(
              builder: (creditCardController) {
                return creditCardController.dashboardTransactionList.isNotEmpty
                    ? ViewAllWidget(
                        onPressed: () {
                          navigate(
                            context: context,
                            page: CreditCardTransactionListScreen(),
                          );
                        },
                      )
                    : const SizedBox();
              },
            ),
          ],
        ),

        sizedBoxHeight(height: 20),

        // ==========================================================
        // TRANSACTIONS
        // ==========================================================
        GetBuilder<CreditCardController>(
          builder: (creditCardController) {
            final transactions = creditCardController.dashboardTransactionList;



            // ======================================================
            // EMPTY
            // ======================================================
            if (transactions.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  SizedBox(height: 180.h),
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 55.r,
                    color: greyText2,
                  ),
                  SizedBox(height: 14.h),
                  Center(
                    child: CustomText(
                      'No transactions found',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Center(
                    child: CustomText(
                      'Your transactions will appear here.',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: greyText2,
                      ),
                    ),
                  ),
                ],
              );
            }

            // ======================================================
            // TRANSACTION LIST
            // ======================================================
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  creditCardController.isLoading ? 4 : transactions.length,
              itemBuilder: (context, index) {
                // ==================================================
                // LOAD MORE
                // ==================================================
                if (index >= transactions.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final transaction = transactions[index];

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: 12.h,
                  ),
                  child: TransactionCard(
                    transaction: transaction,
                    onTap: () {
                      navigate(
                        context: context,
                        page: CreditCardCashWithdrawalTransactionDetailsScreen(
                          transactionId: transaction.transactionId ?? "",
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

// ================================================================
// TRANSACTION HISTORY SHIMMER
// ================================================================

class _TransactionHistoryShimmer extends StatelessWidget {
  const _TransactionHistoryShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: 12.h,
            ),
            child: CustomShimmer(
              isLoading: true,
              child: Container(
                width: double.infinity,
                height: 82.h,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: greyBorder,
                  ),
                ),
                child: Row(
                  children: [
                    // Icon placeholder
                    Container(
                      width: 46.w,
                      height: 46.w,
                      decoration: BoxDecoration(
                        color: greyBorder,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Text placeholders
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 130.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: greyBorder,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: 90.w,
                            height: 9.h,
                            decoration: BoxDecoration(
                              color: greyBorder,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 10.w),

                    // Amount placeholder
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 65.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: greyBorder,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 45.w,
                          height: 9.h,
                          decoration: BoxDecoration(
                            color: greyBorder,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
