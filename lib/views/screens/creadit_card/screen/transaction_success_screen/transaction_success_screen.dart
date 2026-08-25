import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/creadit_card/screen/transaction_success_screen/widget/settlement_options.dart';
import 'package:lekra/views/screens/creadit_card/screen/transaction_success_screen/widget/transaction_details_card.dart';
import 'package:lekra/views/screens/creadit_card/screen/transaction_success_screen/widget/transaction_success_header.dart';

class TransactionSuccessScreen extends StatelessWidget {
  const TransactionSuccessScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: GetBuilder<CreditCardController>(
          builder: (creditCardController) {
            final transaction =
                creditCardController.initiationWithdrawalModel;

            return Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: AppConstants.screenPadding,
                  child: Column(
                    children: [
                      const TransactionSuccessHeader(),

                      sizedBoxHeight(height: 24),

                      TransactionDetailsCard(
                        transaction: transaction,
                      ),

                      sizedBoxHeight(height: 20),

                      const SettlementOptions(),
                    ],
                  ),
                ),

                if (creditCardController.isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(
                        alpha: 0.25,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}