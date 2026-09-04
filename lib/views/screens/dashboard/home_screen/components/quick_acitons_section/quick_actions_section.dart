import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/creadit_card/screen/check_custom_kyc/check_custom_kyc_screen.dart';
import 'package:lekra/views/screens/creadit_card/screen/credit_card_transaction_list_screen/credit_card_transaction_list_screen.dart';
import 'package:lekra/views/screens/pos_machine/connect_pos_device/connect_pos_device_screen/connect_pos_device_screen.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key, t});

  @override
  Widget build(BuildContext context) {
    final List<_QuickActionItem> actions = [
      _QuickActionItem(
        title: 'Credit card to Rent Pay',
        iconColor: const Color(0xFF16A36A),
        backgroundColor: const Color(0xFFEFFBF5),
        svgIcon: Assets.svgsCashWithdraw,
        onTap: () {
          navigate(context: context, page: CheckCustomerKycScreen());
        },
      ),
      _QuickActionItem(
        title: 'Add\nCard / Manage',
        svgIcon: Assets.svgsAddCard,
        iconColor: const Color(0xFF7C3AED),
        backgroundColor: const Color(0xFFF5F0FF),
        onTap: () {
          // navigate(context: context, page: PaymentSoundNotificationScreen());
        },
      ),
      _QuickActionItem(
        title: 'Transaction\nHistory',
        icon: Icons.receipt_long_outlined,
        iconColor: const Color(0xFF2563EB),
        backgroundColor: const Color(0xFFEEF5FF),
        onTap: () {
          // Get.find<CreditCardController>().fetchCreditCardTransactionList();
          // navigate(
          //   context: context,
          //   page:
          //    TransactionHistoryScreen(
          //     fromDateValue: DateTime(2024, 1, 1),
          //     todateValue: getDateTime(),
          //   ),
          // );
          navigate(
            context: context,
            page: CreditCardTransactionListScreen(),
          );
        },
      ),
      _QuickActionItem(
        title: 'POS Devices',
        svgIcon: Assets.svgsPosMachine,
        iconColor: const Color(0xFFF59E0B),
        backgroundColor: const Color(0xFFFFF7E8),
        onTap: () {
          navigate(context: context, page: ConnectPosDeviceScreen());
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Quick Actions',
          style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: black,
              ),
        ),
        SizedBox(height: 14.h),
        Row(
          children: List.generate(
            actions.length,
            (index) {
              final action = actions[index];

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == actions.length - 1 ? 0 : 10.w,
                  ),
                  child: _QuickActionCard(
                    item: action,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final _QuickActionItem item;

  const _QuickActionCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(
                      0,
                      2,
                    ),
                    blurRadius: 4,
                    spreadRadius: -1,
                    color: black.withValues(alpha: 0.03),
                  ),
                  BoxShadow(
                    offset: Offset(
                      0,
                      4,
                    ),
                    blurRadius: 6,
                    spreadRadius: -1,
                    color: black.withValues(alpha: 0.05),
                  ),
                ]),
            child: Container(
              width: 58.w,
              height: 58.w,
              decoration: BoxDecoration(
                color: item.backgroundColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: item.icon != null
                  ? Icon(
                      item.icon,
                      color: item.iconColor,
                      size: 27.r,
                    )
                  : Padding(
                      padding: EdgeInsets.all(16.w),
                      child: SvgPicture.asset(
                        item.svgIcon ?? "",
                        height: 24.h,
                        width: 24.w,
                        fit: BoxFit.cover,
                        colorFilter:
                            ColorFilter.mode(item.iconColor, BlendMode.srcIn),
                      ),
                    ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 34.h,
            child: CustomText(
              item.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem {
  final String title;
  final IconData? icon;
  final String? svgIcon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const _QuickActionItem({
    required this.title,
    required this.iconColor,
    required this.backgroundColor,
    this.onTap,
    this.icon,
    this.svgIcon,
  });
}
