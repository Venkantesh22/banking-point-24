import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_transaction_details_model.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_transaction_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/creadit_card/screen/credit_card_transaction_list_screen/creadit_card_transaction_details_screen.dart';

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
                    child: _TransactionCard(
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

// ================================================================
// TRANSACTION CARD
// ================================================================

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    required this.transaction,
    required this.onTap,
  });

  final CreditCardTransactionModel transaction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _statusColor(
      transaction.status,
    );

    return Material(
      color: white,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: greyBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.03,
                ),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _TransactionTypeIcon(
                    type: transaction.type,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          transaction.title ?? '-',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        CustomText(
                          _subtitle(transaction),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: greyText2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        transaction.formattedAmount ??
                            transaction.amount ??
                            '-',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(
                            alpha: 0.10,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomText(
                          transaction.status ?? '-',
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Divider(
                height: 1,
                color: greyBorder,
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: _SmallInfo(
                      label: 'Transaction ID',
                      value: transaction.transactionId ?? '-',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _SmallInfo(
                      label: 'Time',
                      value: transaction.time ?? '-',
                      alignEnd: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitle(
    CreditCardTransactionModel transaction,
  ) {
    switch (transaction.type?.trim().toUpperCase()) {
      case 'UPI':
        return transaction.number ?? transaction.no ?? 'UPI transaction';

      case 'CASH':
        return transaction.number ?? transaction.no ?? 'Cash withdrawal';

      case 'BANK':
      case 'PENDING_CHOICE':
        return transaction.bankName ?? 'Bank transaction';

      default:
        return transaction.bankName ??
            transaction.number ??
            transaction.no ??
            'Transaction';
    }
  }

  Color _statusColor(String? status) {
    switch (status?.trim().toUpperCase()) {
      case 'SUCCESS':
        return const Color(0xFF20A865);

      case 'PENDING':
        return const Color(0xFFF59E0B);

      case 'FAILED':
      case 'FAILURE':
      case 'CANCELLED':
        return Colors.red;

      default:
        return greyText2;
    }
  }
}

// ================================================================
// TYPE ICON
// ================================================================

class _TransactionTypeIcon extends StatelessWidget {
  const _TransactionTypeIcon({
    required this.type,
  });

  final String? type;

  @override
  Widget build(BuildContext context) {
    final String transactionType = type?.trim().toUpperCase() ?? '';

    late final IconData icon;
    late final Color color;

    switch (transactionType) {
      case 'UPI':
        icon = Icons.account_balance_wallet_outlined;
        color = Colors.deepPurple;
        break;

      case 'CASH':
        icon = Icons.payments_outlined;
        color = Colors.green;
        break;

      case 'BANK':
      case 'PENDING_CHOICE':
        icon = Icons.account_balance_outlined;
        color = primaryColor;
        break;

      default:
        icon = Icons.receipt_long_outlined;
        color = greyText2;
    }

    return Container(
      width: 46.w,
      height: 46.w,
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.10,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        icon,
        size: 23.r,
        color: color,
      ),
    );
  }
}

// ================================================================
// SMALL INFO
// ================================================================

class _SmallInfo extends StatelessWidget {
  const _SmallInfo({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        CustomText(
          label,
          style: TextStyle(
            fontSize: 9.sp,
            color: greyText2,
          ),
        ),
        SizedBox(height: 3.h),
        CustomText(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
      ],
    );
  }
}
