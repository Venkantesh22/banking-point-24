import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';

class DemoScreenModel {
  String? titleImage;
  final Widget title;
  final Widget secondTitle;
  final String subTitle;
  final Widget image;
  final Widget? descr;

  DemoScreenModel(
      {required this.title,
      required this.secondTitle,
      required this.subTitle,
      required this.image,
      this.descr,
      this.titleImage});
}

List<DemoScreenModel> getDemoData(BuildContext context) {
  return [
    DemoScreenModel(
        titleImage: Assets.imagesFullLogo,
        title: CustomText(
          "POS Cash",
          style: TextStyle(
            fontSize: 32.sp,
            color: primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
          ),
        ),
        secondTitle: CustomText(
          "Withdrawal",
          style: Helper(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: 32.sp, color: secondaryColor),
        ),
        subTitle: 'Instant cash in your hands',
        image: Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CustomImage(
              path: Assets.imagesSlider3,
              width: double.infinity,
              height: double.infinity, // Force it to fill the Expanded area
              fit: BoxFit
                  .contain, // Use contain to avoid cropping important demo graphics
            ),
          ),
        ),
        descr: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Slider1DesWidget(Assets.svgsCurrent, "Instant\nCash", context),
              Slider1DesWidget(
                  Assets.svgsSecurity2, "Secure\nTransactions", context),
              Slider1DesWidget(Assets.svgsClock, "Available\n24x7", context)
            ],
          ),
        )),

    //* second screen
    DemoScreenModel(
      title: CustomText(
        "Simple, Secure &",
        style: TextStyle(
          fontSize: 32.sp,
          color: primaryColor,
          fontWeight: FontWeight.bold,
          letterSpacing: -1,
        ),
      ),
      secondTitle: CustomText(
        "Super Fast",
        style: Helper(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontSize: 32.sp, color: secondaryColor),
      ),
      subTitle:
          'Withdraw cash from any credit card using our secure POS device.',
      image: Expanded(
        child: CustomImage(
          path: Assets.imagesSlider1,
          width: double.infinity,
          height: double.infinity, // Force it to fill the Expanded area
          fit: BoxFit
              .contain, // Use contain to avoid cropping important demo graphics
        ),
      ),
    ),

//* 3 screen
    DemoScreenModel(
        titleImage: Assets.imagesFullLogo,
        title: CustomText(
          "Cash When You Need,",
          style: TextStyle(
            fontSize: 32.sp,
            color: primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
          ),
        ),
        secondTitle: CustomText(
          "Where You Need!",
          style: Helper(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: 32.sp, color: secondaryColor),
        ),
        subTitle: 'Reliable POS cash withdrawal service at your fingertips.',
        image: Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CustomImage(
              path: Assets.imagesSlider2,
              width: double.infinity,
              height: double.infinity, // Force it to fill the Expanded area
              fit: BoxFit
                  .contain, // Use contain to avoid cropping important demo graphics
            ),
          ),
        ),
        descr: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: CustomButton(
            height: 60.h,
            radius: 99.r,
            onTap: () {
              Get.find<BasicController>().setIsDemoSave(true);
              navigate(
                  context: context,
                  page: const LoginScreen(),
                  isRemoveUntil: true);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  "Get Started",
                  style: Helper(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 18.sp, color: white),
                ),
                sizedBoxWidth(width: 8.w),
                Icon(
                  Icons.arrow_forward,
                  color: white,
                )
              ],
            ),
          ),
        )),
  ];
}

Widget Slider1DesWidget(String icon, String title, BuildContext context) {
  return Column(
    children: [
      Container(
        height: 48.h,
        width: 48.w,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: secondaryColor.withValues(alpha: 0.30)),
        child: SvgPicture.asset(
          icon,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
        ),
      ),
      sizedBoxHeight(height: 12.h),
      CustomText(
        title,
        textAlign: TextAlign.center,
        style: Helper(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontSize: 12.sp, color: textDartLight),
      ),
    ],
  );
}
