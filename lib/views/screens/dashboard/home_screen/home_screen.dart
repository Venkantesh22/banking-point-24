import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/controllers/kyc_controller/form_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/banner_image_section.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/kyc_pending_card.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/kyc_successfull_card.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/quick_acitons_section/quick_actions_section.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/top_banner_section.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/transaction_history_section.dart';
import 'package:lekra/views/screens/kyc_form/components/screen/kycSubmittedSuccessScreen/kyc_submitted_success_screen.dart';
import 'package:lekra/views/screens/kyc_form/kyc_form_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isReload;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeScreen(
      {super.key, this.isReload = false, required this.scaffoldKey});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("initState tap");

      Get.find<FormController>().venderKycStatus();

      if (widget.isReload) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final controller = Get.find<CreditCardController>();

          controller.fetchDashboardTransactionList(
            fromdate: DateFormat('yyyy-MM-dd').format(
              DateTime.now(),
            ),
            todate: DateFormat('yyyy-MM-dd').format(
              DateTime.now(),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 2,
        leading: IconButton(
            onPressed: () {
              widget.scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: primaryColor,
            )),
        title: Row(
          children: [
            CustomImage(
              path: Assets.imagesLogoIcon,
              height: 60.h,
              width: 60.w,
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  AppConstants.appName,
                  style: Helper(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                CustomText(
                  "Credit Card Cash Withdrawal",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: GetBuilder<AuthController>(
        builder: (authController) {
          if (authController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 16.h,
              bottom: 120.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // MERCHANT PROFILE
                // ==================================================
                TopBannerSection(),

                // const MerchantProfileCard(),

                SizedBox(height: 16.h),

                // ==================================================
                // KYC PENDING
                // ==================================================

                GetBuilder<FormController>(
                  builder: (formController) {
                    final String status = formController
                            .venderKycStatusModel?.kycStatus
                            ?.trim()
                            .toLowerCase() ??
                        '';

                    if (status == 'approved') {
                      return CustomShimmer(
                        isLoading: formController.isLoading,
                        child: const KycSuccessCard(),
                      );
                    }

                    return CustomShimmer(
                      isLoading: formController.isLoading,
                      child: KycPendingCard(
                        kycStatus:
                            formController.venderKycStatusModel?.kycStatus ??
                                '',
                        onTap: () {
                          final isRegistrationStarted = formController
                                  .venderKycStatusModel
                                  ?.isRegistrationStarted ??
                              false;

                          if (isRegistrationStarted) {
                            navigate(
                              context: context,
                              page: const KycFormScreen(),
                            );
                          } else {
                            navigate(
                              context: context,
                              page: KycSubmittedSuccessScreen(
                                onGoToDashboard: () {
                                  Get.find<DashBoardController>().dashPage = 0;

                                  navigate(
                                    context: context,
                                    page: DashboardScreen(),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),

                // ==================================================
                // QUICK ACTIONS
                // ==================================================

                const QuickActionsSection(),

                SizedBox(height: 24.h),

                // ==================================================
                // RECEIVE PAYMENT BANNER
                // ==================================================

                const BannerImage(),

                SizedBox(height: 20.h),

                // ==================================================
                // TRANSACTION HISTORY
                // ==================================================

                const TransactionHistoryWidget(),
                SizedBox(height: 40.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
