import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

import '../choose_settlement_method_screen.dart';

class SettlementMethodCard extends StatelessWidget {
  const SettlementMethodCard({
    super.key,
    required this.method,
    required this.title,
    required this.subtitle,
    required this.description,
    this.icon,
    this.iconSvg,
    required this.isSelected,
    required this.onTap,
  });

  final SettlementMethod method;
  final String title;
  final String subtitle;
  final String description;
  final IconData? icon;
  final String? iconSvg;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? primaryColor : greyBorder,
              width: isSelected ? 1.4 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Method icon
              Container(
                width: 58.w,
                height: 58.h,
                decoration: BoxDecoration(
                  color:
                      isSelected ? primaryColorLight : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: iconSvg != null
                    ? SvgPicture.asset(
                        iconSvg ?? "",
                        height: 30.h,
                        width: 30.w,
                        fit: BoxFit.contain,
                      )
                    : Icon(
                        icon,
                        size: 30.sp,
                        color: primaryColor,
                      ),
              ),

              sizedBoxWidth(width: 14),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                    ),
                    sizedBoxHeight(height: 5),
                    CustomText(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11.sp,
                            color: textSecondary,
                          ),
                    ),
                    sizedBoxHeight(height: 2),
                    CustomText(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11.sp,
                            color: textSecondary,
                          ),
                    ),
                  ],
                ),
              ),

              sizedBoxWidth(width: 10),

              // Radio selection
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22.w,
                height: 22.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? primaryColor : greyLight,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10.w,
                          height: 10.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
