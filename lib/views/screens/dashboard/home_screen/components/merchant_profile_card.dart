import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/copy_text.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';

class MerchantProfileCard extends StatelessWidget {
  const MerchantProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      String activeStatus = (authController.userModel?.isKYCDone ?? false)
          ? 'Active'
          : 'Inactive';

      String todaysCollection = PriceConverter.convertToNumberFormat(120000);
      String growthPercentage = "12.5";
      String merchantID = "7973379934787467";
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1261E8),
              Color(0xFF1747B8),
            ],
          ),
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1261E8).withValues(
                alpha: 0.20,
              ),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // ==================================================
            // TOP SECTION
            // ==================================================

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------------------------------------
                // MERCHANT ICON
                // ------------------------------------------------

                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.14,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.storefront_outlined,
                    size: 27.r,
                    color: white,
                  ),
                ),

                SizedBox(width: 12.w),

                // ------------------------------------------------
                // MERCHANT INFORMATION
                // ------------------------------------------------

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer(
                        isLoading: authController.isLoading,
                        child: CustomText(
                          authController.userModel?.shopName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: white,
                          ),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            'Merchant ID:',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w400,
                              color: white.withValues(
                                alpha: 0.82,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              CustomText(
                                "$merchantID ",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5.sp,
                                  fontWeight: FontWeight.w400,
                                  color: white.withValues(
                                    alpha: 0.82,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  copyText(text: merchantID);
                                },
                                child: Icon(
                                  Icons.copy_outlined,
                                  size: 14.r,
                                  color: white.withValues(
                                    alpha: 0.80,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      // ------------------------------------------------
                      // ACTIVE BADGE
                      // ------------------------------------------------

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 9.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: (authController.userModel?.isKYCDone ?? false)
                              ? const Color(0xFF1BC47D).withValues(alpha: 0.95)
                              : secondaryColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomText(
                          activeStatus,
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                // ------------------------------------------------
                // TODAY COLLECTION
                // ------------------------------------------------

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      "Today's Collection",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: white.withValues(
                          alpha: 0.80,
                        ),
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
                          '$growthPercentage vs yesterday',
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4ADE80),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
