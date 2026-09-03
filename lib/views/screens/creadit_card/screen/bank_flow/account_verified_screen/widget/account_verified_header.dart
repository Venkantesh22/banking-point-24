import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class AccountVerifiedHeader extends StatelessWidget {
  const AccountVerifiedHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sizedBoxHeight(height: 24),

        // Verified icon
        Container(
          width: 118.w,
          height: 118.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE7F8EF),
          ),
          child: Center(
            child: Container(
              width: 88.w,
              height: 88.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF20B978),
              ),
              child: Icon(
                Icons.check_rounded,
                size: 52.sp,
                color: white,
              ),
            ),
          ),
        ),

        sizedBoxHeight(height: 22),

        CustomText(
          'Account Verified!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
        ),

        sizedBoxHeight(height: 8),

        CustomText(
          'Bank account details have been verified and are ready to proceed',
          textAlign: TextAlign.center,
          overflow: TextOverflow.clip,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                height: 1.5,
                color: textSecondary,
              ),
        ),
      ],
    );
  }
}
