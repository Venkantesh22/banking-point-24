import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:lekra/controllers/kyc_controller/form_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';

class KycSubmittedSuccessScreen extends StatelessWidget {
  final VoidCallback? onGoToDashboard;

  const KycSubmittedSuccessScreen({
    super.key,
    this.onGoToDashboard,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: GetBuilder<FormController>(builder: (formController) {
        return SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 30.h,
              ),
              child: Column(
                children: [
                  // ==================================================
                  // SUCCESS ICON
                  // ==================================================

                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withValues(
                        alpha: 0.08,
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            secondaryColor,
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 58.r,
                        color: white,
                      ),
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // ==================================================
                  // TITLE
                  // ==================================================

                  CustomText(
                    'KYC Submitted Successfully!',
                    textAlign: TextAlign.center,
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: black,
                        ),
                  ),

                  SizedBox(height: 10.h),

                  // ==================================================
                  // DESCRIPTION
                  // ==================================================

                  CustomText(
                    'Your KYC application has been submitted successfully '
                    'and is now under verification.',
                    textAlign: TextAlign.center,
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          height: 1.5,
                          color: greyText6,
                        ),
                  ),

                  SizedBox(height: 28.h),

                  // ==================================================
                  // STATUS CARD
                  // ==================================================

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      color: primaryColorLight,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: primaryColor.withValues(
                          alpha: 0.15,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42.w,
                              height: 42.w,
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(
                                  alpha: 0.10,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.verified_outlined,
                                color: primaryColor,
                                size: 22.r,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    'KYC Submitted',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: black,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  CustomText(
                                    'Application received successfully',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: greyText6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: primaryColor,
                              size: 20.r,
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        _StatusRow(
                          icon: Icons.access_time_rounded,
                          title: 'Verification in progress',
                          subtitle: 'Our team will review your information',
                        ),
                        SizedBox(height: 12.h),
                        _StatusRow(
                          icon: Icons.notifications_none_rounded,
                          title: 'You will be notified',
                          subtitle:
                              'Updates will be shared through SMS / Email',
                        ),
                        SizedBox(height: 12.h),
                        _StatusRow(
                          icon: Icons.dashboard_outlined,
                          title: 'Track your application',
                          subtitle:
                              'You can check the status from your dashboard',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // ==================================================
                  // APPLICATION STATUS
                  // ==================================================

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: greyBorder.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.hourglass_top_rounded,
                          color: primaryColor,
                          size: 22.r,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                'Current Status',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: greyText6,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              CustomText(
                                formController
                                        .venderKycStatusModel?.kycStatus ??
                                    "",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // ==================================================
                  // DASHBOARD BUTTON
                  // ==================================================

                  CustomButton(
                    title: 'Go to Dashboard',
                    height: 50.h,
                    radius: 12.r,
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        secondaryColor,
                      ],
                    ),
                    onTap: onGoToDashboard,
                  ),

                  SizedBox(height: 12.h),

                  // ==================================================
                  // SUPPORTING TEXT
                  // ==================================================

                  CustomText(
                    'Please keep your registered mobile number and email '
                    'available for verification updates.',
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      height: 1.4,
                      color: greyText6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StatusRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34.w,
          height: 34.w,
          decoration: BoxDecoration(
            color: primaryColor.withValues(
              alpha: 0.08,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 18.r,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: black,
                ),
              ),
              SizedBox(height: 2.h),
              CustomText(
                subtitle,
                style: TextStyle(
                  fontSize: 10.sp,
                  height: 1.3,
                  color: greyText6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
