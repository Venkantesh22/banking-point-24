import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/pos_machine/connect_pos_device/connect_pos_device_screen/widget/available_pos_devices.dart';
import 'package:lekra/views/screens/pos_machine/connect_pos_device/connect_pos_device_screen/widget/pos_search_indicator.dart';
import 'package:lekra/views/screens/pos_machine/connect_pos_device/connect_pos_device_screen/widget/scan_again_button.dart';

class ConnectPosDeviceScreen extends StatefulWidget {
  const ConnectPosDeviceScreen({
    super.key,
  });

  @override
  State<ConnectPosDeviceScreen> createState() =>
      _ConnectPosDeviceScreenState();
}

class _ConnectPosDeviceScreenState
    extends State<ConnectPosDeviceScreen> {
  Timer? _scanTimer;

  bool isScanning = true;

  int scanSecondsRemaining = 10;

  @override
  void initState() {
    super.initState();

    _startScanning();
  }

  void _startScanning() {
    _scanTimer?.cancel();

    setState(() {
      isScanning = true;
      scanSecondsRemaining = 10;
    });

    _scanTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (scanSecondsRemaining > 1) {
          if (mounted) {
            setState(() {
              scanSecondsRemaining--;
            });
          }
        } else {
          timer.cancel();

          if (mounted) {
            setState(() {
              scanSecondsRemaining = 0;
              isScanning = false;
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 3,
        centerTitle: true,
        title: CustomText(
          'Connect to POS Device',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 19.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
        ),
      ),
      backgroundColor: backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: AppConstants.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PosSearchIndicator(
                      isSearching: isScanning,
                      secondsRemaining: scanSecondsRemaining,
                    ),

                    sizedBoxHeight(height: 28),

                    if (isScanning)
                      _ScanningMessage(
                        secondsRemaining: scanSecondsRemaining,
                      )
                    else
                      const _NoDeviceFound(),

                    sizedBoxHeight(height: 24),

                    // Do not show any devices.
                    const SizedBox.shrink(),

                    ScanAgainButton(
                      onTap: isScanning
                          ? () {}
                          : _startScanning,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanningMessage extends StatelessWidget {
  const _ScanningMessage({
    required this.secondsRemaining,
  });

  final int secondsRemaining;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 20.h,
      ),
      decoration: BoxDecoration(
        color: primaryColorLight,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 36.w,
            height: 36.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2.5,
            ),
          ),
          sizedBoxHeight(height: 12),
          CustomText(
            'Searching for nearby POS devices...',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
          ),
          sizedBoxHeight(height: 5),
          CustomText(
            '$secondsRemaining seconds remaining',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11.sp,
                  color: greyText2,
                ),
          ),
        ],
      ),
    );
  }
}

class _NoDeviceFound extends StatelessWidget {
  const _NoDeviceFound();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
        vertical: 24.h,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: greyBorder,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: grey.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bluetooth_disabled_rounded,
              size: 30.sp,
              color: greyText2,
            ),
          ),
          sizedBoxHeight(height: 14),
          CustomText(
            'No device found near you',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
          ),
          sizedBoxHeight(height: 6),
          CustomText(
            'Make sure your POS device is nearby and Bluetooth is turned on.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11.sp,
                  height: 1.4,
                  color: greyText2,
                ),
          ),
        ],
      ),
    );
  }
}