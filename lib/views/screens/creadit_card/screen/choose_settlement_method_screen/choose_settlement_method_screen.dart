import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/creadit_card/screen/bank_flow/enter_account_details_screen/enter_account_details_screen.dart';
import 'package:lekra/views/screens/creadit_card/screen/choose_settlement_method_screen/widget/settlement_method_card.dart';
import 'package:lekra/views/screens/creadit_card/screen/choose_settlement_method_screen/widget/settlement_method_header.dart';
import 'package:lekra/views/screens/creadit_card/screen/upi_flow/enter_upi_id_screen/enter_upi_id_screen.dart';

class ChooseSettlementMethodScreen extends StatefulWidget {
  const ChooseSettlementMethodScreen({
    super.key,
  });

  @override
  State<ChooseSettlementMethodScreen> createState() =>
      _ChooseSettlementMethodScreenState();
}

class _ChooseSettlementMethodScreenState
    extends State<ChooseSettlementMethodScreen> {
  // Demo selected method
  SettlementMethod selectedMethod = SettlementMethod.upi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: AppConstants.screenPadding,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SettlementMethodHeader(),
                    Column(
                      children: [
                        SettlementMethodCard(
                          method: SettlementMethod.upi,
                          title: 'UPI ID',
                          subtitle: 'Send money to the customer',
                          description: 'via UPI ID',
                          iconSvg: Assets.svgsUpi,
                          isSelected: selectedMethod == SettlementMethod.upi,
                          onTap: () {
                            setState(() {
                              selectedMethod = SettlementMethod.upi;
                            });

                            debugPrint('UPI ID selected');
                          },
                        ),
                        sizedBoxHeight(height: 14),
                        SettlementMethodCard(
                          method: SettlementMethod.account,
                          title: 'Account',
                          subtitle: 'Send money to the customer',
                          description: 'via Bank Account',
                          icon: Icons.account_balance_outlined,
                          isSelected:
                              selectedMethod == SettlementMethod.account,
                          onTap: () {
                            setState(() {
                              selectedMethod = SettlementMethod.account;
                            });

                            debugPrint('Account selected');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CustomImage(
              path: Assets.imagesBankUpi,
              fit: BoxFit.contain,
            ),
            sizedBoxHeight(height: 60),
            CustomButton(
              onTap: () {
                selectedMethod == SettlementMethod.upi
                    ? navigate(context: context, page: EnterUpiIdScreen())
                    : navigate(
                        context: context, page: EnterAccountDetailsScreen());
              },
              title: "Container...",
            )
          ],
        ),
      ),
    );
  }
}

enum SettlementMethod {
  upi,
  account,
}
