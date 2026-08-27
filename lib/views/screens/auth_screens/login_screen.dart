import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/controllers/permission_controller.dart';
import 'package:lekra/firebase/get_Fcm_token.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/auth_screens/create_account_screen.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/auth_screens/forget_password/forget_password_screen.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FCMService.getFCMToken();

      Get.find<PermissionController>()
          .requestLocationPermissionAndFetch(context);

      final AuthController authController = Get.find<AuthController>();
      authController.phoneNumberController.clear();
      authController.passwordController.clear();
      authController.update();
    });
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> _loginFun(
      {required AuthController authController,
      required PermissionController permissionController}) async {
    if (_formKey.currentState?.validate() ?? false) {
      await authController.setUserInfor(
          authController.passwordController.text,
          authController.phoneNumberController.text,
          permissionController.latitude.toString(),
          permissionController.longitude.toString());

      if (permissionController.latitude == null ||
          permissionController.longitude == null ||
          permissionController.latitude == 0.0 ||
          permissionController.longitude == 0.0) {
        await permissionController.requestLocationPermissionAndFetch(context);
      }

      await authController.loginUser(context: context).then((value) {
        if (value.isSuccess) {
          showToast(message: value.message, typeCheck: value.isSuccess);
          Get.find<DashBoardController>().dashPage = 0;
          navigate(
              isRemoveUntil: true, context: context, page: DashboardScreen());
        } else {
          showToast(message: value.message, typeCheck: value.isSuccess);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(builder: (authController) {
        return GetBuilder<PermissionController>(
            builder: (permissionController) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.26,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment:
                            Alignment.center, // 🔹 This centers it horizontally
                        child: CustomImage(
                          path: Assets.imagesFullLogo,
                          // width: 106,
                          height: 114.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Welcome Back",
                          style: Helper(context).textTheme.titleSmall?.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(
                          "Log In",
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                AppTextFieldWithHeading(
                                  heading: "Mobile Number",
                                  controller:
                                      authController.phoneNumberController,
                                  hindText: "Enter your mobile number ",
                                  prefixText: "+91",
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
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
                                const SizedBox(
                                  height: 16,
                                ),
                                AppTextFieldWithHeading(
                                  heading: "Password",
                                  controller: authController.passwordController,
                                  hindText: "Enter your password ",
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _loginFun(
                                      authController: authController,
                                      permissionController:
                                          permissionController),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter phone number';
                                    }

                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                CustomButton(
                                  isLoading: authController.isLoading,
                                  onTap: () => _loginFun(
                                      authController: authController,
                                      permissionController:
                                          permissionController),
                                  title: "Login",
                                  textStyle: Helper(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: white),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const ForgetPasswordScreen()),
                                        );
                                      },
                                      child: Text(
                                        "Forgot Password?",
                                        style: Helper(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: greyText3),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Don't have an account?",
                                        textAlign: TextAlign.end,
                                        style: Helper(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: TextButton(
                                          onPressed: () {
                                            navigate(
                                                context: context,
                                                page:
                                                    const CreateAccountScreen());
                                          },
                                          child: Text(
                                            "Register Now",
                                            style: Helper(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: primaryColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      }),
    );
  }
}
