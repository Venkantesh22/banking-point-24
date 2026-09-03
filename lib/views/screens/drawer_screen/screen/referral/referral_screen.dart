import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/drawer_screen/drawer_screen.dart';
import 'package:lekra/views/screens/drawer_screen/screen/referral/components/Invite_your_frients_widget.dart';
import 'package:lekra/views/screens/drawer_screen/screen/referral/components/row_of_referral.dart';
import 'package:lekra/views/screens/drawer_screen/screen/referral/widget_to_share_code.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar_drawer.dart';
import 'package:share_plus/share_plus.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> shareReferralCode(AuthController authController) async {
    try {
      final params = ShareParams(
        text:
            '${authController.userModel?.referralCode}  User is referral code of ${authController.userModel?.fullName}',
      );

      await SharePlus.instance.share(params);
    } catch (e, st) {
      print('shareImage error: $e\n$st');
      showToast(
        message: "Unable to referral code. Please try again.",
        toastType: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerScreen(),
      appBar: CustomAppbarDrawer(
        scaffoldKey: _scaffoldKey,
        title: "Referral",
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: GetBuilder<AuthController>(builder: (authController) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello, ${authController.userModel?.fullName}",
                  style: Helper(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(
                height: 20,
              ),
              Text(
                  "Have a referral code? Add it here.\nStart earning points instantly.",
                  style: Helper(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 12, fontWeight: FontWeight.w400)),
              const SizedBox(
                height: 20,
              ),
              InviteYOurFriendWidget(
                authController: authController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomShimmer(
                isLoading: authController.isLoading,
                child: GestureDetector(
                  onTap: () async {
                    if (authController.isLoading) return;

                    // Await the share operation so we don't race with the platform share sheet.
                    try {
                      await shareReferralCode(authController);
                    } catch (e, st) {
                      debugPrint('shareReferralCode failed: $e\n$st');
                      showToast(
                        message:
                            "Unable to share referral code. Please try again.",
                        toastType: ToastType.error,
                      );
                      return;
                    }

                    // Widget might have been disposed while awaiting — check mounted.
                    if (!mounted) return;

                    // Now show the dialog (use showDialog with AlertDialog for better look on Android/iOS).
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Your Referral Code",
                                  style: Helper(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    authController.userModel?.referralCode ??
                                        'N/A',
                                    style: Helper(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const WidgetToShareCode(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("How the Referral Works",
                  style: Helper(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 15,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final rowOFReferral = rowOfReferralWorksModelList[index];
                    return RowOfReferralWorks(
                        rowOfReferralWorksModel: rowOFReferral);
                  },
                  separatorBuilder: (_, __) {
                    return const SizedBox(
                      height: 30,
                    );
                  },
                  itemCount: rowOfReferralWorksModelList.length),
            ],
          );
        }),
      ),
    );
  }
}
