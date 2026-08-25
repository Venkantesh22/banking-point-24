import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';

class TopBannerSection extends StatelessWidget {
  const TopBannerSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String todaysCollection = PriceConverter.convertToNumberFormat(0);
    String growthPercentage = "0";
    return Stack(
      children: [
        CustomImage(
          path: Assets.imagesTopBanner,
          width: double.infinity,
          fit: BoxFit.contain,
          radius: 16.r,
        ),
        Positioned(
          left: 10.w,
          top: 10.h,
          bottom: 10.h,
          child: CustomImage(
            path: Assets.imagesTopBannerCardAtm,
            width: MediaQuery.of(context).size.width / 2,
            fit: BoxFit.contain,
            radius: 16.r,
          ),
        ),
        Positioned(
          right: 12.w,
          top: 10.h,
          bottom: 10.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                "Today's Collection",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: white,
                ),
              ),
              SizedBox(height: 4.h),
              CustomText(
                todaysCollection,
                style: TextStyle(
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w800,
                  color: white,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_upward_rounded,
                    size: 13.r,
                    color: const Color(0xFF4ADE80),
                  ),
                  SizedBox(width: 2.w),
                  CustomText(
                    '$growthPercentage vs Yesterday',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4ADE80),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              CustomButton(
                type: ButtonType.secondary,
                onTap: () {
                  Get.find<DashBoardController>().dashPage = 1;
                  navigate(context: context, page: DashboardScreen());
                },
                radius: 20.r,
                height: 30.h,
                borderColor: white,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
                  child: CustomText(
                    "View Statement",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
