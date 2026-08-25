import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/lanch_helper.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class ContactUSSocialMediaWIdget extends StatelessWidget {
  final ContactUSSocialMediaWIdgetModel contactUSSocialMediaWIdget;
  const ContactUSSocialMediaWIdget({
    super.key,
    required this.contactUSSocialMediaWIdget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: contactUSSocialMediaWIdget.onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: greyLight)),
        child: Row(
          children: [
            CustomImage(
              path: contactUSSocialMediaWIdget.icon,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contactUSSocialMediaWIdget.title,
                    style: Helper(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    contactUSSocialMediaWIdget.subtitle,
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: primaryColor),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 22,
              backgroundColor: greyText3,
              child: Icon(
                Icons.file_upload_outlined,
                color: white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ContactUSSocialMediaWIdgetModel {
  final String icon;
  final String title;
  final String subtitle;
  final Function()? onTap;

  ContactUSSocialMediaWIdgetModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

List<ContactUSSocialMediaWIdgetModel> contactUSSocialMediaWIdgetList = [
  ContactUSSocialMediaWIdgetModel(
      icon: Assets.imagesInstagramBlack,
      title: "Instagram",
      subtitle: "7,5K Followers",
      onTap: () {
        LaunchHelper.launchInstagram(username: "");
      }),
  ContactUSSocialMediaWIdgetModel(
      icon: Assets.imagesWhatsappBlack,
      title: "WhatsUp",
      subtitle: "Available Mon-Sat  • 9 AM - 7 PM",
      onTap: () {
        LaunchHelper.launchWhatsApp(phone: "11111111111");
      }),
  ContactUSSocialMediaWIdgetModel(
      icon: Assets.imagesWebBlack,
      title: "Visit Website",
      subtitle: "https://www.bankin24.com/",
      onTap: () async {
        LaunchHelper.launchInBrowser(Uri.parse("https://www.bankin24.com/"));
      }),
];
