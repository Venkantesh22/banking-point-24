import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/lanch_helper.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/drawer_screen/drawer_screen.dart';
import 'package:lekra/views/screens/drawer_screen/screen/contact_us/components/contact_us_social_media.dart';
import 'package:lekra/views/screens/drawer_screen/screen/contact_us/components/container_of_call_email.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar_drawer.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => ContactUsScreenState();
}

class ContactUsScreenState extends State<ContactUsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerScreen(),
      backgroundColor: contactUsBackground,
      appBar: CustomAppbarDrawer(
        title: "",
        scaffoldKey: _scaffoldKey,
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contact Us",
              style: Helper(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontSize: 42, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Don’t hesitate to contact us whether you have a suggestion on our improvement, a complain to discuss or an issue to solve.",
              style: Helper(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ContainerOfCallAndEmail(
                    label: "Call Us",
                    icon: Assets.svgsCall,
                    onTap: () => LaunchHelper.callUs(number: "9876543210"),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ContainerOfCallAndEmail(
                    label: "Email Us",
                    icon: Assets.svgsEmail,
                    onTap: () =>
                        LaunchHelper.emailUs(email: "info@banking24.com"),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Contact us in Social Media",
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12, fontWeight: FontWeight.w400, color: grey),
            ),
            const SizedBox(
              height: 8,
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final contactUSSocialMediaWIdget =
                      contactUSSocialMediaWIdgetList[index];
                  return ContactUSSocialMediaWIdget(
                      contactUSSocialMediaWIdget: contactUSSocialMediaWIdget);
                },
                separatorBuilder: (_, __) => const SizedBox(
                      height: 24,
                    ),
                itemCount: contactUSSocialMediaWIdgetList.length)
          ],
        ),
      ),
    );
  }
}
