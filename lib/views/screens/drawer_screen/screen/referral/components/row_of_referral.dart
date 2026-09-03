import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class RowOfReferralWorks extends StatelessWidget {
  final RowOfReferralWorksModel rowOfReferralWorksModel;
  const RowOfReferralWorks({
    super.key,
    required this.rowOfReferralWorksModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: primaryColor,
          child: Text(
            rowOfReferralWorksModel.no,
            style: Helper(context).textTheme.bodySmall?.copyWith(
                fontSize: 13, fontWeight: FontWeight.w500, color: white),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Text(
            rowOfReferralWorksModel.label,
            overflow: TextOverflow.clip,
            style: Helper(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      ],
    );
  }
}

class RowOfReferralWorksModel {
  final String no;
  final String label;
  RowOfReferralWorksModel({required this.no, required this.label});
}

List<RowOfReferralWorksModel> rowOfReferralWorksModelList = [
  RowOfReferralWorksModel(
      no: "1",
      label:
          "Invite your friends to use our application with your referral code. They will receive a bonus when they join using your referral code. Every friend who joins and makes a transaction will earn you a reward."),
  RowOfReferralWorksModel(
      no: "2",
      label:
          'Check "Activated Referral" to see which friends have joined using your referral code.'),
  RowOfReferralWorksModel(
      no: "3",
      label:
          "Get a bonus every time your friends make a transaction. The rewards will be added to your account automatically.")
];
