import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/controllers/report_contoller.dart';
import 'package:lekra/data/models/transaction_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/transcation_details/transaction_details_screen.dart';
import 'package:lekra/views/screens/widget/transaction_row.dart';

class TransactionListSection extends StatelessWidget {
  const TransactionListSection({
    super.key,
    required ScrollController scrollController,
    required this.isInitialLoading,
    required this.isMoreLoading,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final bool isInitialLoading;
  final bool isMoreLoading;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditCardController>(
      builder: (creditCardController) {
        return GetBuilder<ReportController>(builder: (reportController) {
          return Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: isInitialLoading
                  ? 4
                  : reportController.itemsToShow.length + (isMoreLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (isInitialLoading) {
                  final transactionModel = TransactionModel();
                  return CustomShimmer(
                      isLoading: true,
                      child: TransactionRow(transactionModel: transactionModel));
                }
        
                // loader tile at the end when loading more
                if (isMoreLoading && index == reportController.itemsToShow.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                  );
                }
        
                final transaction = reportController.itemsToShow[index];
                return CustomShimmer(
                    isLoading: false,
                    child: GestureDetector(
                        onTap: () {
                          reportController.setTransactionModel(transaction);
                          
                          navigate(
                              context: context,
                              page: TransactionDetailsScreen(
                                transactionModel: transaction,
                              ));
                        },
                        child: TransactionRow(transactionModel: transaction)));
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
            ),
          );
        });
      }
    );
  }
}
