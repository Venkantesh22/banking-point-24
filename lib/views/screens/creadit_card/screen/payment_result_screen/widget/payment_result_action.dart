import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_transaction_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';

class PaymentResultAction extends StatelessWidget {
  const PaymentResultAction({
    super.key,
    required this.status,
  });

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case PaymentStatus.successful:
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    type: ButtonType.secondary,
                    onTap: () {
                      debugPrint('Share receipt');
                    },
                    height: 50.h,
                    radius: 14.r,
                    borderColor: primaryColor,
                    borderWidth: 1,
                    color: white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share_outlined,
                          size: 19.sp,
                          color: primaryColor,
                        ),
                        SizedBox(width: 7.w),
                        Text(
                          'Share',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    type: ButtonType.primary,
                    onTap: () {
                      debugPrint('Download receipt');
                    },
                    height: 50.h,
                    radius: 14.r,
                    borderWidth: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_outlined,
                          size: 19.sp,
                          color: white,
                        ),
                        SizedBox(width: 7.w),
                        Text(
                          'Receipt',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: white,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            sizedBoxHeight(height: 12),
            _dashboardButton(context),
          ],
        );

      case PaymentStatus.pending:
        return Column(
          children: [
            CustomButton(
              type: ButtonType.secondary,
              onTap: () {
                debugPrint('Check payment status');
              },
              height: 52.h,
              radius: 14.r,
              color: white,
              borderColor: const Color(0xFFF59E0B),
              borderWidth: 1.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    size: 20.sp,
                    color: const Color(0xFFF59E0B),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Check Payment Status',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF59E0B),
                        ),
                  ),
                ],
              ),
            ),
            sizedBoxHeight(height: 12),
            _dashboardButton(context),
          ],
        );

      case PaymentStatus.cancelled:
        return Column(
          children: [
            CustomButton(
              type: ButtonType.primary,
              onTap: () {
                debugPrint('Try Again');
              },
              height: 52.h,
              radius: 14.r,
              borderWidth: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    size: 20.sp,
                    color: white,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Try Again',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: white,
                        ),
                  ),
                ],
              ),
            ),
            sizedBoxHeight(height: 12),
            _dashboardButton(context),
          ],
        );

      case PaymentStatus.cash:
        return _dashboardButton(context);
    }
  }

  Widget _dashboardButton(BuildContext context) {
    return CustomButton(
      type: ButtonType.primary,
      onTap: () {
        final dashboardController = Get.find<DashBoardController>();

        dashboardController.dashPage = 0;
        dashboardController.update();

        navigate(context: context, page: DashboardScreen());
      },
      title: 'Go to Dashboard',
      height: 52.h,
      radius: 14.r,
      borderWidth: 0,
    );
  }
}
