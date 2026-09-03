import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/extensions.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:lekra/views/screens/widget/button/back_buttton.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool? termAndCondition = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _createAccountFun(
      {required AuthController authController}) async {
    if (termAndCondition ?? false) {
      if (_formKey.currentState?.validate() ?? false) {
        log("tap");
        await authController.registerUser().then((value) {
          if (value.isSuccess) {
            showToast(message: value.message, typeCheck: value.isSuccess);
            navigate(context: context, page: const LoginScreen());
          } else {
            showToast(message: value.message, typeCheck: value.isSuccess);
          }
        });
      }
    } else {
      showToast(
        toastType: ToastType.error,
        message: "Please accept terms and conditions",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use a scroll view so keyboard/smaller screens don't overflow
    return Scaffold(
      body: Container(
        padding: AppConstants.screenPadding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: loginBgColor,
              begin: Alignment.centerLeft,
              end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      color: white, borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const CustomBackButton(),
                      GetBuilder<AuthController>(builder: (authController) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 25, right: 16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Create account",
                                    style:
                                        Helper(context).textTheme.titleSmall),
                                const SizedBox(height: 6),
                                Text("Sign up to continue",
                                    style: Helper(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            fontSize: 13, color: greyText)),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextFieldWithHeading(
                                        heading: "First Names",
                                        controller:
                                            authController.firstNameController,
                                        hindText: "First name",
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter first name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: AppTextFieldWithHeading(
                                        heading: "Last Name",
                                        controller:
                                            authController.lastNameController,
                                        hindText: "Last name",
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter last name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 21),
                                AppTextFieldWithHeading(
                                  heading: "Mobile Number",
                                  controller:
                                      authController.phoneNumberController,
                                  hindText: "Enter your mobile number ",
                                  prefixText: "+91",
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter phone number';
                                    }
                                    if (value.length != 10) {
                                      return 'Please enter valid phone number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 21),
                                AppTextFieldWithHeading(
                                  heading: "Email",
                                  controller: authController.emailController,
                                  hindText: "Enter your Email ",
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter phone number';
                                    }
                                    if (value.isNotEmail) {
                                      return 'Please enter valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 21),
                                AppTextFieldWithHeading(
                                  heading: "Shop Name",
                                  controller: authController.shopNameController,
                                  hindText: "Enter your shop name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Shop Name';
                                    }

                                    return null;
                                  },
                                ),
                                const SizedBox(height: 21),
                                AppTextFieldWithHeading(
                                  heading: "Address",
                                  controller:
                                      authController.addressNameController,
                                  hindText: "Enter your address",
                                  maxLines: 2,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Address';
                                    }

                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextFieldWithHeading(
                                        heading: "City",
                                        controller:
                                            authController.cityController,
                                        hindText: "City",
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter city';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: AppTextFieldWithHeading(
                                        heading: "Pincode",
                                        controller:
                                            authController.pincodeController,
                                        hindText: "Pincode",
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(6),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Pincode';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 21),
                                AppTextFieldWithHeading(
                                  heading: "Referral Code",
                                  controller:
                                      authController.referralCodeController,
                                  hindText: "Enter your referral code",
                                ),
                                const SizedBox(height: 21),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: termAndCondition,
                                      onChanged: (value) {
                                        setState(() {
                                          termAndCondition = value;
                                        });
                                      },
                                    ),

                                    // RichText(text:
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: RichText(
                                        text: TextSpan(
                                            text: "I agree to the",
                                            style: Helper(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                            children: [
                                              TextSpan(
                                                text: " Terms",
                                                style: Helper(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: primaryColor),
                                              ),
                                              TextSpan(
                                                text: " and",
                                                style: Helper(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                              ),
                                              TextSpan(
                                                text: " Conditions",
                                                style: Helper(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: primaryColor),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                                CustomButton(
                                  onTap: () => _createAccountFun(
                                      authController: authController),
                                  title: "Create account",
                                  textStyle: Helper(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: white),
                                  elevation: 2,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: greyLight))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Already have an account?",
                                        textAlign: TextAlign.center,
                                        style: Helper(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton(
                                          onPressed: () {
                                            navigate(
                                                context: context,
                                                page: const LoginScreen());
                                          },
                                          child: Text(
                                            "Login",
                                            style: Helper(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryColor),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
