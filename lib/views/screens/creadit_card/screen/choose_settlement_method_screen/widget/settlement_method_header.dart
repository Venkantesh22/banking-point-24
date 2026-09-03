import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class SettlementMethodHeader extends StatelessWidget {
  const SettlementMethodHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.w,
        10.h,
        16.w,
        8.h,
      ),
      child: Column(
        children: [
          sizedBoxHeight(height: 20),
          CustomText(
            'Settlement to Customer',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
          ),
          sizedBoxHeight(height: 7),
          CustomText(
            'Choose a settlement method',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
