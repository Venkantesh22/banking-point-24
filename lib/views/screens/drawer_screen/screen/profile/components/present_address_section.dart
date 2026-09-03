import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class PresentAddressSection extends StatefulWidget {
  const PresentAddressSection({
    super.key,
  });

  @override
  State<PresentAddressSection> createState() => _PresentAddressSectionState();
}

class _PresentAddressSectionState extends State<PresentAddressSection> {
  @override
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasicController>(builder: (basicController) {
      return GetBuilder<AuthController>(builder: (authController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Present Address",
                  style: Helper(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: primaryColor),
                ),
              ),
              AppTextFieldWithHeading(
                bgColor: white,
                controller: authController.shopNameController,
                hindText: "Enter Shop Name",
                heading: "Shop Name",
                borderRadius: 8,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Shop Name ';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AppTextFieldWithHeading(
                bgColor: white,
                controller: authController.officeAddressController,
                hindText: "1234 street road delhi india",
                heading: "Office Address",
                borderRadius: 8,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Office Address';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      });
    });
  }
}
