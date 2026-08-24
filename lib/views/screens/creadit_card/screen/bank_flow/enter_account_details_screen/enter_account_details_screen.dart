import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_money_controller/upi_bank_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/creadit_card/screen/bank_flow/account_verified_screen/account_verified_screen.dart';
import 'package:lekra/views/screens/creadit_card/screen/bank_flow/enter_account_details_screen/widget/account_details_header.dart';
import 'package:lekra/views/screens/kyc_form/components/widget/uppper_case_text_formatter.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class EnterAccountDetailsScreen extends StatefulWidget {
  const EnterAccountDetailsScreen({
    super.key,
  });

  @override
  State<EnterAccountDetailsScreen> createState() =>
      _EnterAccountDetailsScreenState();
}

class _EnterAccountDetailsScreenState extends State<EnterAccountDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: GetBuilder<UpiBankController>(builder: (upiBankController) {
          return SingleChildScrollView(
            padding: AppConstants.screenPadding,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const AccountDetailsHeader(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextFieldWithHeading(
                        controller: upiBankController.accountHolderController,
                        heading: 'Account Holder Name',
                        hindText: 'Enter account holder name',
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        preFixWidget: Icon(
                          Icons.person_outline,
                          color: grey,
                        ),
                        borderRadius: 12.r,
                        borderWidth: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z ]'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Place enter a Account Holder Name";
                          }
                          return null;
                        },
                      ),
                      sizedBoxHeight(height: 16),
                      AppTextFieldWithHeading(
                        controller: upiBankController.accountNumberController,
                        heading: 'Account Number',
                        hindText: 'Enter account number',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        borderRadius: 12.r,
                        borderWidth: 1,
                        preFixWidget: Icon(
                          Icons.account_balance,
                          color: grey,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(18),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Place enter a Account Number";
                          }
                          if (value.length < 9) {
                            return "Place enter a proper account Number";
                          }
                          return null;
                        },
                      ),
                      sizedBoxHeight(height: 16),
                      AppTextFieldWithHeading(
                        controller: upiBankController.ifscController,
                        heading: 'IFSC Code',
                        hindText: 'Enter IFSC code',
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        borderRadius: 12.r,
                        borderWidth: 1,
                        preFixWidget: Icon(
                          Icons.location_on_outlined,
                          color: grey,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]'),
                          ),
                          UpperCaseTextFormatter(),
                          LengthLimitingTextInputFormatter(11),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Place enter a IFSC Code";
                          }

                          return null;
                        },
                      ),
                      sizedBoxHeight(height: 16),
                      AppTextFieldWithHeading(
                        controller: upiBankController.bankNameController,
                        heading: 'Bank Name',
                        hindText: 'Bank name',
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        borderRadius: 12.r,
                        borderWidth: 1,
                        preFixWidget: Icon(
                          Icons.account_balance_outlined,
                          color: grey,
                        ),
                      ),
                      sizedBoxHeight(height: 26),
                    ],
                  ),
                  sizedBoxHeight(height: 100),
                  CustomButton(
                    isLoading: upiBankController.isLoading,
                    title: 'Verify Account',
                    type: ButtonType.primary,
                    height: 52.h,
                    radius: 14.r,
                    borderWidth: 0,
                    fontSize: 14.sp,
                    onTap: () {
                      upiBankController.validateBankAccountInfo().then((value) {
                        if (value.isSuccess) {
                          showToast(
                              message: value.message,
                              typeCheck: value.isSuccess);
                          navigate(
                              context: context, page: AccountVerifiedScreen());
                        } else {
                          showToast(
                              message: value.message,
                              typeCheck: value.isSuccess);
                        }
                      });
                    },
                  ),
                  sizedBoxHeight(height: 18),
                  const _SecurityMessage(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ============================================================
// SECURITY MESSAGE
// ============================================================

class _SecurityMessage extends StatelessWidget {
  const _SecurityMessage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: primaryColorLight,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.w,
            height: 38.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: white,
            ),
            child: Icon(
              Icons.security_rounded,
              size: 20.sp,
              color: primaryColor,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Bank Settlement',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Please enter the customer bank details '
                  'carefully. The account will be verified '
                  'before sending money.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10.5.sp,
                        height: 1.45,
                        color: textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
