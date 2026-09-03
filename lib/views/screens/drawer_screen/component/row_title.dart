import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/drawer_screen/screen/change_password/change_password_screen.dart';
import 'package:lekra/views/screens/drawer_screen/screen/contact_us/contact_us_screen.dart';
import 'package:lekra/views/screens/drawer_screen/screen/dispute/dispute_screen/dispute_screen.dart';
import 'package:lekra/views/screens/drawer_screen/screen/download_qr/download_qr_screen.dart';
import 'package:lekra/views/screens/drawer_screen/screen/profile/my_profile_screen.dart';
import 'package:lekra/views/screens/drawer_screen/screen/referral/referral_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class RowOFTitle extends StatelessWidget {
  final DrawerTitleRowModel drawerTitleRowModel;

  const RowOFTitle({
    super.key,
    required this.drawerTitleRowModel,
  });

  static const String _packageName = 'com.myfoozzybusiness';

  Future<void> _openPlayStore() async {
    final Uri marketUri = Uri.parse('market://details?id=$_packageName');
    final Uri webUri = Uri.parse(
        'https://play.google.com/store/apps/details?id=$_packageName');

    try {
      // Try the Play Store app first
      if (await canLaunchUrl(marketUri)) {
        await launchUrl(marketUri, mode: LaunchMode.externalApplication);
        return;
      }

      // Fallback to the web link
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return;
      }

      showToast(
        message: "Could not open Play Store.",
        toastType: ToastType.error,
      );
    } catch (e) {
      showToast(
        message: "Error opening Play Store.",
        toastType: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return GestureDetector(
        onTap: () {
          // 1 – Play Store -> open rating dialog
          if (drawerTitleRowModel.isPlayStore == true) {
            _openPlayStore();
            return;
          }

          // 2 – Check KYC before navigating to QR screen
          if (drawerTitleRowModel.page is DownloadQrScreen) {
            if (!(authController.userModel?.isKYCDone ?? false)) {
              return showToast(
                message: "KYC is Required",
                toastType: ToastType.info,
              );
            }
          }

          // 3 – Normal navigation
          navigate(context: context, page: drawerTitleRowModel.page);

          // 4 – Logout
          if (drawerTitleRowModel.islogout == true) {
            Get.find<AuthController>().logout(context);
            return;
          }
        },
        child: Row(
          children: [
            SvgPicture.asset(
              drawerTitleRowModel.icon,
              height: 24.h,
              width: 24.w,
              colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: CustomText(
                drawerTitleRowModel.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: drawerTitleRowModel.islogout ? red : black),
              ),
            )
          ],
        ),
      );
    });
  }
}

class DrawerTitleRowModel {
  final String icon;
  final String title;
  final Widget page;
  final bool islogout;
  final bool isPlayStore;
  DrawerTitleRowModel({
    required this.icon,
    required this.title,
    required this.page,
    this.islogout = false,
    this.isPlayStore = false,
  });
}

List<DrawerTitleRowModel> drawerTitleList = [
  DrawerTitleRowModel(
      icon: Assets.svgsHome, title: "Home", page: const DashboardScreen()),
  DrawerTitleRowModel(
      icon: Assets.svgsPerson, title: "Profile", page: const MyProfileScreen()),
  // DrawerTitleRowModel(
  //     icon: Assets.svgsImage,
  //     title: "Set QR as Wallpaper",
  //     page: const DownloadQrScreen(
  //       setAsWellPaper: true,
  //     )),
  // DrawerTitleRowModel(
  //     icon: Assets.svgsVolumeUp,
  //     title: "Payment Sound Setting",
  //     page: PaymentSoundNotificationScreen()),
  DrawerTitleRowModel(
      icon: Assets.svgsReferralCode,
      title: "Referral Code",
      page: const ReferralScreen()),
  DrawerTitleRowModel(
      icon: Assets.svgsLock,
      title: "Change Password",
      page: const ChangePasswordScreen()),
  DrawerTitleRowModel(
      icon: Assets.svgsDispute, title: "Dispute", page: const DisputeScreen()),
  DrawerTitleRowModel(
      icon: Assets.svgsContactUs,
      title: "Contact Us",
      page: const ContactUsScreen()),
  DrawerTitleRowModel(
      icon: Assets.svgsAboutUs, title: "About", page: const DashboardScreen()),
  DrawerTitleRowModel(
      icon: Assets.svgsStar,
      title: "Rate Us",
      page: const DashboardScreen(),
      isPlayStore: true),
  DrawerTitleRowModel(
    icon: Assets.svgsLogOut,
    title: "Log out",
    page: const LoginScreen(),
    islogout: true,
  ),
];
