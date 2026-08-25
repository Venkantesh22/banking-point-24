import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/views/screens/creadit_card/screen/credit_card_transaction_list_screen/credit_card_transaction_list_screen.dart';
import 'package:lekra/views/screens/dashboard/home_screen/home_screen.dart';
import 'package:lekra/views/screens/drawer_screen/drawer_screen.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../generated/assets.dart';
import '../../../services/theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _dashboardScaffoldKey =
      GlobalKey<ScaffoldState>();

  // 1. Add a boolean to track if the drawer is currently open
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _dashboardScaffoldKey,

      // 2. Listen for drawer state changes
      onDrawerChanged: (isOpened) {
        setState(() {
          _isDrawerOpen = isOpened;
        });
      },

      drawer: const DrawerScreen(),
      body: GetBuilder<DashBoardController>(
        builder: (DashBoardController controller) {
          return Stack(
            children: [
              // --- BASE LAYER: THE SCREENS ---
              IndexedStack(
                index: controller.dashPage,
                children: [
                  HomeScreen(
                    isReload: true,
                    scaffoldKey: _dashboardScaffoldKey,
                  ),

                  CreditCardTransactionListScreen(),
                  // CheckCustomerKycScreen(),
                  // TransactionHistoryScreen(
                  //   fromDateValue: DateTime(2024, 1, 1),
                  //   todateValue: getDateTime(),
                  // ),
                ],
              ),

              // --- TOP LAYER: THE FLOATING NAVIGATION BAR ---
              // 3. Use AnimatedPositioned to smoothly slide it out of view
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                // If drawer is open, push it 100 pixels off the bottom of the screen.
                // If closed, bring it back up to 20 pixels.
                bottom: _isDrawerOpen ? -100 : 20,
                left: 40,
                right: 40,
                child: SafeArea(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BottomNavigationItemWidget(
                          onTap: () => controller.dashPage = 0,
                          title: 'Home',
                          icon: Assets.svgsHome,
                          isActive: controller.dashPage == 0,
                        ),
                        // BottomNavigationItemWidget(
                        //   onTap: () => controller.dashPage = 1,
                        //   title: 'Card',
                        //   icon: Assets.svgsCard,
                        //   isActive: controller.dashPage == 1,
                        // ),
                        BottomNavigationItemWidget(
                          onTap: () => controller.dashPage = 1,
                          title: 'Report',
                          icon: Assets.svgsReport,
                          isActive: controller.dashPage == 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
// Keep your existing BottomNavigationItemWidget code here...

class BottomNavigationItemWidget extends StatelessWidget {
  const BottomNavigationItemWidget({
    super.key,
    required this.title,
    required this.icon,
    this.isActive = false,
    this.onTap,
  });

  final String title;
  final String icon;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isActive
                    ? primaryColor
                    : Colors.black54, // Softened inactive color slightly
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isActive ? primaryColor : const Color(0xFF393648),
                  ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 4,
              width:
                  isActive ? 16 : 0, // Slightly shorter line for a cleaner look
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
