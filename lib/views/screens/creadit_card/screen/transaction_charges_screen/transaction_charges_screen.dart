import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lekra/controllers/card_money_controller/credit_card_controller.dart';
import 'package:lekra/data/models/cash%20withdrawal%20model/credit_card_charges_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class TransactionChargesScreen extends StatelessWidget {
  const TransactionChargesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditCardController>(
      builder: (controller) {
        final CreditCardChargesModel? chargesModel =
            controller.creditCardChargesModel;

        final activeCharges = chargesModel?.data
                .where(
                  (charge) => charge.status?.toLowerCase() == 'active',
                )
                .toList() ??
            [];

        return Scaffold(
          backgroundColor: backgroundLight,
          appBar: AppBar(
            backgroundColor: white,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: primaryColor,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Transaction Charges',
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
                CustomText(
                  'Credit card withdrawal charges',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: greyDark,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ======================================================
                  // CHARGE SUMMARY
                  // ======================================================

                  _ChargeSummaryCard(
                    minAmount: chargesModel?.minAmount,
                    maxAmount: chargesModel?.maxAmount,
                    gstPercentage: chargesModel?.defaultGstPercent,
                  ),

                  SizedBox(height: 20.h),

                  // ======================================================
                  // TITLE
                  // ======================================================

                  CustomText(
                    'Applicable Charges',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: black,
                    ),
                  ),

                  SizedBox(height: 5.h),

                  CustomText(
                    'Charges applicable based on withdrawal amount',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: greyDark,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // ======================================================
                  // ACTIVE CHARGE SLABS
                  // ======================================================

                  if (activeCharges.isEmpty)
                    _EmptyChargesCard()
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activeCharges.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final charge = activeCharges[index];

                        return _ChargeSlabCard(
                          charge: charge,
                          gstPercentage: chargesModel?.defaultGstPercent ?? 0,
                        );
                      },
                    ),

                  SizedBox(height: 20.h),

                  // ======================================================
                  // GST INFORMATION
                  // ======================================================

                  _GstInfoCard(
                    gstPercentage: chargesModel?.defaultGstPercent ?? 0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChargeSummaryCard extends StatelessWidget {
  final double? minAmount;
  final double? maxAmount;
  final double? gstPercentage;

  const _ChargeSummaryCard({
    this.minAmount,
    this.maxAmount,
    this.gstPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            primaryColor.withValues(alpha: 0.88),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Withdrawal Charges',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: white,
            ),
          ),
          SizedBox(height: 5.h),
          CustomText(
            'Transparent charges based on your withdrawal amount',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  title: 'Minimum',
                  value: PriceConverter.convertToNumberFormat(minAmount ?? 0.0),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _SummaryItem(
                  title: 'Maximum',
                  value: PriceConverter.convertToNumberFormat(maxAmount ?? 0.0),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _SummaryItem(
                  title: 'GST',
                  value: '${(gstPercentage ?? 0).toStringAsFixed(0)}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
          SizedBox(height: 4.h),
          CustomText(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChargeSlabCard extends StatelessWidget {
  final ChargeModel charge;
  final double gstPercentage;

  const _ChargeSlabCard({
    required this.charge,
    required this.gstPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final min = charge.minAmount ?? 0.0;
    final max = charge.maxAmount ?? 0.0;
    final chargeValue = charge.chargeValue ?? 0.0;

    final String chargeText = charge.isPercent
        ? '${chargeValue.toStringAsFixed(
            chargeValue % 1 == 0 ? 0 : 2,
          )}%'
        : PriceConverter.convertToNumberFormat(chargeValue);

    final String chargeDescription = charge.isPercent
        ? '$chargeText of withdrawal amount + GST'
        : '$chargeText flat charge + GST';

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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: primaryColorLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  charge.isPercent
                      ? Icons.percent_rounded
                      : Icons.currency_rupee_rounded,
                  color: primaryColor,
                  size: 21.r,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Withdrawal Slab',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: black,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      charge.isPercent ? 'PERCENTAGE CHARGE' : 'FLAT CHARGE',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: greyDark,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    CustomText(
                      'Active',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Divider(
            height: 1,
            color: greyBorder,
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _ChargeInfo(
                  title: 'Withdrawal Range',
                  value:
                      '${PriceConverter.convertToNumberFormat(min)} - ₹${PriceConverter.convertToNumberFormat(max)}',
                ),
              ),
              Container(
                width: 1,
                height: 35.h,
                color: greyBorder,
              ),
              Expanded(
                child: _ChargeInfo(
                  title: charge.isPercent ? 'Processing Fee' : 'Flat Charge',
                  value: chargeText,
                  valueColor: primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 9.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FF),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 15.r,
                  color: primaryColor,
                ),
                SizedBox(width: 7.w),
                Expanded(
                  child: CustomText(
                    chargeDescription,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: greyText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChargeInfo extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const _ChargeInfo({
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            style: TextStyle(
              fontSize: 9.sp,
              color: greyDark,
            ),
          ),
          SizedBox(height: 4.h),
          CustomText(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: valueColor ?? black,
            ),
          ),
        ],
      ),
    );
  }
}

class _GstInfoCard extends StatelessWidget {
  final double gstPercentage;

  const _GstInfoCard({
    required this.gstPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: primaryColorLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            color: primaryColor,
            size: 22.r,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'GST Information',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 4.h),
                CustomText(
                  'GST of ${gstPercentage.toStringAsFixed(0)}% '
                  'is applicable on the processing fee.',
                  style: TextStyle(
                    fontSize: 10.sp,
                    height: 1.4,
                    color: greyText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChargesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: greyBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 42.r,
            color: grey,
          ),
          SizedBox(height: 10.h),
          CustomText(
            'No active charges available',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: black,
            ),
          ),
          SizedBox(height: 4.h),
          CustomText(
            'Please try again later.',
            style: TextStyle(
              fontSize: 11.sp,
              color: greyDark,
            ),
          ),
        ],
      ),
    );
  }
}
