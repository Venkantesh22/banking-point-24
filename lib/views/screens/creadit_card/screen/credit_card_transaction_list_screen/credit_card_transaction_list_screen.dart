import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';

class CreditCardTransactionListScreen extends StatefulWidget {
  const CreditCardTransactionListScreen({super.key});

  @override
  State<CreditCardTransactionListScreen> createState() =>
      _CreditCardTransactionListScreenState();
}

class _CreditCardTransactionListScreenState
    extends State<CreditCardTransactionListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CreditCardController>().fetchCreditCardTransactionList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
