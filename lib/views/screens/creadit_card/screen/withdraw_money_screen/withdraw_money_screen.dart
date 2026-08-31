import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/controllers/card_money_controller/custom_kyc_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/creadit_card/screen/withdraw_money_screen/widget/expiry_dateInput_formatter.dart';
import 'package:lekra/views/screens/creadit_card/screen/withdraw_verify_otp_screen/withdraw_verify_otp_screen.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class WithdrawMoneyScreen extends StatefulWidget {
  WithdrawMoneyScreen({
    super.key,
  });

  @override
  State<WithdrawMoneyScreen> createState() => _WithdrawMoneyScreenState();
}

class _WithdrawMoneyScreenState extends State<WithdrawMoneyScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<CreditCardController>();
      controller.fetchCreditCardCharges();
      controller.amountController.clear();
      controller.cardNumberController.clear();
      controller.expiryDateController.clear();
      controller.cvvController.clear();
      controller.cardHolderNameController.clear();
      controller.bankNameController.clear();
      controller.calRealTimeCharges = null;
      controller.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditCardController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            backgroundColor: white,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  'Withdraw Money',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF101B5C),
                  ),
                ),
                sizedBoxHeight(height: 4.h),
                CustomText(
                  'Enter amount and card details',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: greyDark,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: AppConstants.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // WITHDRAW AMOUNT
                    // ==================================================

                    _WithdrawAmountCard(
                      controller: controller,
                    ),

                    sizedBoxHeight(
                      height: 20,
                    ),

                    // ==================================================
                    // CARD INFORMATION
                    // ==================================================

                    CustomText(
                      'Credit Card Information',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: black,
                      ),
                    ),

                    sizedBoxHeight(
                      height: 10,
                    ),

                    _CreditCardForm(
                      controller: controller,
                    ),

                    sizedBoxHeight(
                      height: 22,
                    ),

                    // ==================================================
                    // WITHDRAW BUTTON
                    // ==================================================

                    GetBuilder<CustomKycController>(
                      builder: (customKycController) {
                        return CustomButton(
                          isLoading: customKycController.isLoading,
                          title: 'Withdraw Money (Send OTP)',
                          height: 48.h,
                          radius: 8.r,
                          gradient: LinearGradient(
                            colors: [
                              primaryColor,
                              secondaryColor,
                            ],
                          ),
                          onTap: () {
                            // ==========================================================
                            // VALIDATE AMOUNT
                            // ==========================================================

                            final amount = double.tryParse(
                              controller.amountController.text.trim(),
                            );

                            final minAmount =
                                controller.creditCardChargesModel?.minAmount ??
                                    0;
                            final maxAmount =
                                controller.creditCardChargesModel?.maxAmount ??
                                    0;

                            if (amount == null || amount <= 0) {
                              showToast(
                                message:
                                    'Please enter a valid withdrawal amount',
                                toastType: ToastType.warning,
                              );
                              return;
                            }

                            if (amount < minAmount) {
                              showToast(
                                message:
                                    'Minimum withdrawal amount is ₹${minAmount.toStringAsFixed(0)}',
                                toastType: ToastType.warning,
                              );
                              return;
                            }

                            if (amount > maxAmount) {
                              showToast(
                                message:
                                    'Maximum withdrawal amount is ₹${maxAmount.toStringAsFixed(0)}',
                                toastType: ToastType.warning,
                              );
                              return;
                            }

                            // ==========================================================
                            // FORM VALIDATION
                            // ==========================================================

                            if (!(formKey.currentState?.validate() ?? false)) {
                              return;
                            }

                            // ==========================================================
                            // API
                            // ==========================================================

                            controller
                                .cardWithdrawalInitiate(
                              number: customKycController
                                  .mobileNumberController.text
                                  .trim(),
                            )
                                .then((value) {
                              if (value.isSuccess) {
                                showToast(
                                  message: value.message,
                                  typeCheck: true,
                                );

                                navigate(
                                  context: context,
                                  page: const WithdrawVerifyOtpScreen(),
                                );
                              } else {
                                showToast(
                                  message: value.message,
                                  typeCheck: false,
                                );
                              }
                            });
                          },
                        );
                      },
                    ),
                    sizedBoxHeight(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ==================================================================
// WITHDRAW AMOUNT CARD
// ==================================================================
class _WithdrawAmountCard extends StatefulWidget {
  final CreditCardController controller;

  const _WithdrawAmountCard({
    required this.controller,
  });

  @override
  State<_WithdrawAmountCard> createState() => _WithdrawAmountCardState();
}

class _WithdrawAmountCardState extends State<_WithdrawAmountCard> {
  Timer? _amountDebounce;

  CreditCardController get controller => widget.controller;

  @override
  void dispose() {
    _amountDebounce?.cancel();
    super.dispose();
  }

  void _onAmountChanged(
    String value,
    CreditCardController creditCardController,
  ) {
    _amountDebounce?.cancel();

    final amount = double.tryParse(value.trim());

    // ------------------------------------------------------------
    // EMPTY / INVALID
    // ------------------------------------------------------------

    if (amount == null || amount <= 0) {
      creditCardController.calRealTimeCharges = null;
      creditCardController.update();
      return;
    }

    // ------------------------------------------------------------
    // MIN / MAX FROM API
    // ------------------------------------------------------------

    final minAmount =
        creditCardController.creditCardChargesModel?.minAmount ?? 0.0;

    final maxAmount =
        creditCardController.creditCardChargesModel?.maxAmount ?? 0.0;

    // ------------------------------------------------------------
    // MINIMUM VALIDATION
    // ------------------------------------------------------------

    // ------------------------------------------------------------
    // VALID AMOUNT
    // ------------------------------------------------------------

    _amountDebounce = Timer(
      const Duration(milliseconds: 1000),
      () async {
        if (!mounted) {
          return;
        }
        if (minAmount > 0 && amount < minAmount) {
          creditCardController.calRealTimeCharges = null;
          creditCardController.update();

          showToast(
            toastType: ToastType.warning,
            message: 'Invalid Withdrawal Amount',
            description:
                'Minimum withdrawal amount is ₹${minAmount.toStringAsFixed(0)}',
          );

          return;
        }

        // ------------------------------------------------------------
        // MAXIMUM VALIDATION
        // ------------------------------------------------------------

        if (maxAmount > 0 && amount > maxAmount) {
          creditCardController.calRealTimeCharges = null;
          creditCardController.update();

          showToast(
            toastType: ToastType.warning,
            message: 'Invalid Withdrawal Amount',
            description:
                'Maximum withdrawal amount is ₹${maxAmount.toStringAsFixed(0)}',
          );

          return;
        }

        final latestAmount = double.tryParse(
          controller.amountController.text.trim(),
        );

        if (latestAmount == null || latestAmount <= 0) {
          return;
        }

        if (latestAmount < minAmount) {
          return;
        }

        if (latestAmount > maxAmount) {
          return;
        }

        debugPrint(
          'Calling calRealTimeCharge() for: $latestAmount',
        );

        await creditCardController.calRealTimeCharge();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditCardController>(
      builder: (creditCardController) {
        final double minAmount =
            creditCardController.creditCardChargesModel?.minAmount ?? 0.00;

        final double maxAmount =
            creditCardController.creditCardChargesModel?.maxAmount ?? 0.00;

        final String minAmountFormat =
            creditCardController.creditCardChargesModel?.minAmountFormat ?? "-";

        final String maxAmountFormat =
            creditCardController.creditCardChargesModel?.maxAmountFormat ?? "-";

        final realTimeCharge = creditCardController.calRealTimeCharges;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFFE5E9F2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'Enter Withdraw Amount',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: black,
                ),
              ),
              sizedBoxHeight(height: 8),
              AppTextFieldWithHeading(
                controller: controller.amountController,
                hindText: '0.00',
                prefixText: '₹  ',
                prefixStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,2}'),
                  ),
                ],
                bgColor: white,
                borderColor: primaryColor,
                borderWidth: 1,
                borderRadius: 8,
                onChanged: (value) {
                  _onAmountChanged(
                    value,
                    creditCardController,
                  );
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter withdrawal amount';
                  }

                  final amount = double.tryParse(value.trim());

                  if (amount == null) {
                    return 'Please enter a valid amount';
                  }

                  if (amount < minAmount) {
                    return 'Minimum amount is ₹${minAmount.toStringAsFixed(0)}';
                  }

                  if (amount > maxAmount) {
                    return 'Maximum amount is ₹${maxAmount.toStringAsFixed(0)}';
                  }

                  return null;
                },
              ),
              sizedBoxHeight(height: 12),
              _amountRow('Min. Amount', minAmountFormat),
              _amountRow(
                'Max. Amount',
                maxAmountFormat,
              ),
              controller.calRealTimeCharges != null
                  ? _amountRow(
                      'Processing Fee  ${(controller.calRealTimeCharges?.isPercent ?? false) ? "(${controller.calRealTimeCharges?.chargeValue ?? ""}%)" : ""}',
                      controller.calRealTimeCharges == null
                          ? "-"
                          : '${controller.calRealTimeCharges?.processingFeeFormat}',
                    )
                  : SizedBox(),
              controller.calRealTimeCharges != null
                  ? _amountRow(
                      'GST  ${controller.calRealTimeCharges?.gstPercentage}%',
                      controller.calRealTimeCharges == null
                          ? "-"
                          : '${controller.calRealTimeCharges?.gstFormat ?? 0.0}')
                  : SizedBox(),
              sizedBoxHeight(height: 6),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6FF),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      'Total money card debit',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    if (creditCardController.isCalculatingCharge)
                      SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    else
                      CustomText(
                        realTimeCharge == null
                            ? '₹0.00'
                            : realTimeCharge.totalCardDebitFormat,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF101B5C),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _amountRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              letterSpacing: 0.2,
              color: const Color(0xFF27366F),
            ),
          ),
          CustomText(
            value,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: const Color(0xFF101B5C),
            ),
          ),
        ],
      ),
    );
  }
}
// ==================================================================
// CREDIT CARD FORM
// ==================================================================

class _CreditCardForm extends StatelessWidget {
  final CreditCardController controller;

  const _CreditCardForm({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE5E9F2),
        ),
      ),
      child: Column(
        children: [
          AppTextFieldWithHeading(
            controller: controller.bankNameController,
            heading: 'Bank Name',
            hindText: 'Enter card bank name',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter card bank name';
              }

              return null;
            },
          ),
          sizedBoxHeight(
            height: 14,
          ),
          AppTextFieldWithHeading(
            controller: controller.cardNumberController,
            heading: 'Card Number',
            hindText: '1234 5678 9012 3456',
            keyboardType: TextInputType.number,
            maxLength: 19,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CardNumberFormatter(),
            ],
            validator: (value) {
              final number = value?.replaceAll(
                    ' ',
                    '',
                  ) ??
                  '';

              if (number.isEmpty) {
                return 'Please enter card number';
              }

              if (number.length != 16) {
                return 'Please enter a valid card number';
              }

              return null;
            },
          ),
          sizedBoxHeight(
            height: 14,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextFieldWithHeading(
                  controller: controller.expiryDateController,
                  heading: 'Expiry Date',
                  hindText: 'MM/YY',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    ExpiryDateInputFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }

                    if (!RegExp(
                      r'^(0[1-9]|1[0-2])\/\d{2}$',
                    ).hasMatch(
                      value.trim(),
                    )) {
                      return 'Invalid';
                    }

                    return null;
                  },
                ),
              ),
              sizedBoxWidth(width: 12),
              Expanded(
                child: AppTextFieldWithHeading(
                  controller: controller.cvvController,
                  heading: 'CVV',
                  hindText: '123',
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length != 3) {
                      return 'Invalid CVV';
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),
          sizedBoxHeight(
            height: 14,
          ),
          AppTextFieldWithHeading(
            controller: controller.cardHolderNameController,
            heading: 'Card Holder Name',
            hindText: 'Enter card holder name',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter card holder name';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// CARD NUMBER FORMATTER
// ==================================================================

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String digits = newValue.text.replaceAll(' ', '');

    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }

      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.length,
      ),
    );
  }
}
