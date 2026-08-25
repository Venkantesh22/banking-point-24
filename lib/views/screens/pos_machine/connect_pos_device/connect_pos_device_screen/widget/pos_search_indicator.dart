import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class PosSearchIndicator extends StatelessWidget {
  const PosSearchIndicator({
    super.key,
    required this.isSearching,
    required this.secondsRemaining,
  });

  final bool isSearching;
  final int secondsRemaining;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: greyBorder,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24.w,
            height: 24.w,
            child: isSearching
                ? const CircularProgressIndicator(
                    strokeWidth: 2,
                  )
                : Icon(
                    Icons.bluetooth_disabled_rounded,
                    color: greyText2,
                    size: 22.sp,
                  ),
          ),
          sizedBoxWidth(width: 12),
          Expanded(
            child: CustomText(
              isSearching
                  ? 'Searching nearby devices... '
                  : 'Device search completed',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
