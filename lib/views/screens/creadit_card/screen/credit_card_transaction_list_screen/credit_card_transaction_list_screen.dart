import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/creadit_card/screen/credit_card_transaction_list_screen/creadit_card_transaction_details_screen.dart';
import 'package:lekra/views/screens/creadit_card/screen/credit_card_transaction_list_screen/widget/transaction_widget.dart';

class CreditCardTransactionListScreen extends StatefulWidget {
  const CreditCardTransactionListScreen({
    super.key,
  });

  @override
  State<CreditCardTransactionListScreen> createState() =>
      _CreditCardTransactionListScreenState();
}

class _CreditCardTransactionListScreenState
    extends State<CreditCardTransactionListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<CreditCardController>();

      controller.fetchCreditCardTransactionList(
        fromdate: controller.creditCardTransactionFromDate,
        todate: controller.creditCardTransactionToDate,
      );
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final controller = Get.find<CreditCardController>();

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !controller.creditCardTransactionState.isMoreLoading &&
        controller.creditCardTransactionState.canLoadMore) {
      controller.fetchCreditCardTransactionList(
        fromdate: controller.creditCardTransactionFromDate,
        todate: controller.creditCardTransactionToDate,
        loadMore: true,
      );
    }
  }

  Future<void> _refresh() async {
    await Get.find<CreditCardController>().fetchCreditCardTransactionList(
      fromdate: Get.find<CreditCardController>().creditCardTransactionFromDate,
      todate: Get.find<CreditCardController>().creditCardTransactionToDate,
      refresh: true,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 1,
        centerTitle: true,
        title: CustomText(
          'Transaction History',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 19.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
        ),
      ),
      body: GetBuilder<CreditCardController>(
        builder: (controller) {
          final transactions = controller.creditCardTransactionList;

          if (controller.creditCardTransactionState.isInitialLoading &&
              transactions.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (transactions.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
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
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(
                16.w,
                16.h,
                16.w,
                24.h,
              ),
              itemCount: transactions.length +
                  (controller.creditCardTransactionState.isMoreLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= transactions.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final transaction = transactions[index];

                return CustomShimmer(
                  isLoading: controller.isLoading,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 12.h,
                    ),
                    child: TransactionCard(
                      transaction: transaction,
                      onTap: () {
                        if (controller.isLoading) {
                          return;
                        }
                        navigate(
                            context: context,
                            page:
                                CreditCardCashWithdrawalTransactionDetailsScreen(
                              transactionId: transaction.transactionId ?? "",
                            ));
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


